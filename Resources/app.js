var tab, tabGroup, webView, window, _fakeRequest, _responseToWebView;
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
tabGroup.tabs = [tab];
_responseToWebView = function(data) {
  Ti.App.fireEvent('response', {
    status: data.status,
    responseData: data.responseData
  });
};
_fakeRequest = function(params) {
  var res;
  if (Math.round(Math.random())) {
    res = {
      status: 'success',
      responseData: {
        message: params.message + ' Titanium'
      }
    };
  } else {
    res = {
      status: 'failure',
      responseData: {
        message: 'Something Wrong'
      }
    };
  }
  setTimeout(function() {
    return _responseToWebView(res);
  }, 3000);
};
Ti.App.addEventListener('dispatch', function(e) {
  if (e.fakeUrl === 'ti/hello') {
    _fakeRequest(e.params);
  } else if (e.fakeUrl === 'ti/goodbye') {
    _fakeRequest(e.params);
  }
});
tabGroup.open();