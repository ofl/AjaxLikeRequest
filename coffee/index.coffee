#HTML側のJS
((win, doc) -> 

  #他のリクエストを処理中かどうか
  isConnected = false


  #TitaniumのJSにAjax風にリクエストする  
  _ajaxLikeRequest = (attr)->

    fakeUrl = attr.url || '' #Titanium側をサーバーに見立てて処理をURLで分岐させる
    params = attr.params || {}

    success = attr.success || ()-> return
    error = attr.error || ()-> return
    complete = attr.complete || ()-> return

    #Titanium側からレスポンスが帰ってきた時に呼び出されるコールバック
    #setTimeoutでcallstackを断ち切らないとうまく動作してくれない。
    _callback = (data)->
      setTimeout ()->
        #すぐにコールバックはunbind
        Ti.App.removeEventListener 'response', _callback
        if data.status is 'success'
          success data
        else
          error data
        complete()
        isConnected = false
        return
      ,0
      return

    Ti.App.addEventListener 'response', _callback

    #Titanium側のグローバルイベントを呼び出す 
    Ti.App.fireEvent 'dispatch', {fakeUrl: fakeUrl, params: params}  
    isConnected = true 
    return


  _helloBtnHandler = (e)->
    if isConnected  
      alert "I'm busy."
      return

    button = e.target
    button.disabled = true
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

  _goodbyeBtnHandler = (e)->
    if isConnected  
      alert "I'm busy."
      return

    button = e.target
    button.disabled = true
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

  hellobtn = document.getElementById('hello_btn')
  hellobtn.addEventListener('click', _helloBtnHandler, false)

  goodbyebtn = document.getElementById('goodbye_btn')
  goodbyebtn.addEventListener('click', _goodbyeBtnHandler, false)

  return
)( window, document ) 