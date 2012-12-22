var tab, tabGroup, webView, window, _dispatch, _fakeServerRequest, _responseToWebView;
Ti.UI.setBackgroundColor('#fff');
tabGroup = Ti.UI.createTabGroup();
window = Ti.UI.createWindow({
  title: 'Tab 1',
  backgroundColor: '#fff'
});
webView = Ti.UI.createWebView({
  url: 'index.html'
});
window.add(webView);
tab = Ti.UI.createTab({
  icon: 'KS_nav_views.png',
  title: 'Tab 1',
  window: window
});
tabGroup.addTab(tab);
_dispatch = function(e) {
  if (e.fakeUrl === 'ti/hello') {
    _fakeServerRequest(e.params);
  } else if (e.fakeUrl === 'ti/goodbye') {
    _fakeServerRequest(e.params);
  }
};
_responseToWebView = function(data) {
  Ti.App.fireEvent('response', {
    status: data.status,
    message: data.message
  });
};
_fakeServerRequest = function(params) {
  var res;
  if (Math.round(Math.random())) {
    res = {
      status: 'success',
      message: params.message + ' Titanium'
    };
  } else {
    res = {
      status: 'failure',
      message: 'Something Wrong'
    };
  }
  setTimeout(function() {
    return _responseToWebView(res);
  }, 3000);
};
Ti.App.addEventListener('dispatch', _dispatch);
tabGroup.open();