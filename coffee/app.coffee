Ti.UI.setBackgroundColor '#fff'

tabGroup = Ti.UI.createTabGroup()

window = Ti.UI.createWindow
  title:'Tab 1',
  backgroundColor:'#fff'
webView = Ti.UI.createWebView
  url: 'index.html'

window.add webView
tab = Ti.UI.createTab  
  icon:'KS_nav_views.png',
  title:'Tab 1',
  window:window
tabGroup.addTab tab


#webViewが発信したグローバルイベントを受信してfakeUrlで振り分ける
_dispatch = (e)->
  if e.fakeUrl is 'ti/hello'
    _fakeServerRequest e.params
  else if e.fakeUrl is 'ti/goodbye'
    _fakeServerRequest e.params
  return

#webViewにグローバルイベントでレスポンスを送る。 
_responseToWebView = (data)->
  Ti.App.fireEvent 'response', {
    status: data.status,
    message: data.message
  }    
  return

#擬似的なサーバーリクエスト
_fakeServerRequest = (params)->
  if Math.round Math.random()
    res = 
      status: 'success'
      message: params.message + ' Titanium'
  else
    res = 
      status: 'failure'
      message: 'Something Wrong'

  setTimeout ()->
    _responseToWebView res
  , 3000
  return

Ti.App.addEventListener 'dispatch', _dispatch

tabGroup.open()