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
tabGroup.tabs = [tab]


#webViewにレスポンスを返す 
_responseToWebView = (data)->
  Ti.App.fireEvent 'response', {
    status: data.status,
    responseData: data.responseData
  }    
  return

_fakeRequest = (params)->
  if Math.round Math.random()
    res = 
      status: 'success'
      responseData: {message: params.message + ' Titanium'}
  else
    res = 
      status: 'failure'
      responseData: {message: 'Something Wrong'}

  setTimeout ()->
    _responseToWebView res
  , 3000
  return

#webViewが発信したグローバルイベントを振り分け
Ti.App.addEventListener 'dispatch', (e)->
  if e.fakeUrl is 'ti/hello'
    _fakeRequest e.params
  else if e.fakeUrl is 'ti/goodbye'
    _fakeRequest e.params
  return

tabGroup.open()
