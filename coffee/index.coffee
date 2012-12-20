#HTML側のJS
((win, doc) -> 

  #他のリクエストが動作中の時は邪魔しない
  isConnected = false

  #TitaniumのJSにAjax風にリクエストする  
  _ajaxLikeRequest = (attr)->
    #成功時
    success = attr.success || ()-> return
    #エラー時
    error = attr.error || ()-> return
    #後片付け 
    complete = attr.complete || ()-> return

    #Titanium側からレスポンスが帰ってきた時に呼び出されるコールバック
    _callback = (data)->
      #setTimeoutでcallstackを断ち切らないとうまく動作してくれない。
      setTimeout ()->
        if data.status is 'success'
          success data.responseData
        else
          error data.responseData

        complete()

        #用がすんだらさっさとイベントをunbind
        Ti.App.removeEventListener 'response', _callback

        isConnected = false
        return
      , 0
      return

    #_callbackをグローバルイベントにbind 
    Ti.App.addEventListener 'response', _callback

    #Titanium側のグローバルイベントを呼び出す 
    Ti.App.fireEvent 'dispatch', {
      fakeUrl: attr.url,
      params: attr.params
    }  
    isConnected = true 
    return

  _hello = (e)->
    button = e.target
    if isConnected  
      alert "I'm busy."
    else
      button.disabled =true
      _ajaxLikeRequest
        url: 'ti/hello',
        params: {message: 'Hello'},
        success: (data)->
          alert data.message
          return
        ,
        error: (error)->
          alert error.message
          return
        ,
        complete: ()->
          button.disabled = false
          return
    return

  _goodbye = (e)->
    button = e.target
    if isConnected  
      alert "I'm busy."
    else
      button.disabled =true
      _ajaxLikeRequest
        url: 'ti/goodbye',
        params: {message: 'Goodbye'},
        success: (data)->
          alert data.message
          return
        ,
        error: (error)->
          alert error.message
          return
        ,
        complete: ()->
          button.disabled = false
          return
    return

  hellobtn = document.getElementById('hellobtn')
  hellobtn.addEventListener('click', _hello, false)

  goodbyebtn = document.getElementById('goodbyebtn')
  goodbyebtn.addEventListener('click', _goodbye, false)

  return
)( window, document ) 