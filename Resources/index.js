(function(win, doc) {
  var goodbyebtn, hellobtn, isConnected, _ajaxLikeRequest, _goodbyeBtnHandler, _helloBtnHandler;
  isConnected = false;
  _ajaxLikeRequest = function(attr) {
    var complete, error, fakeUrl, params, success, _callback;
    fakeUrl = attr.url || '';
    params = attr.params || {};
    success = attr.success || function() {};
    error = attr.error || function() {};
    complete = attr.complete || function() {};
    _callback = function(data) {
      setTimeout(function() {
        Ti.App.removeEventListener('response', _callback);
        if (data.status === 'success') {
          success(data);
        } else {
          error(data);
        }
        complete();
        isConnected = false;
      }, 0);
    };
    Ti.App.addEventListener('response', _callback);
    Ti.App.fireEvent('dispatch', {
      fakeUrl: fakeUrl,
      params: params
    });
    isConnected = true;
  };
  _helloBtnHandler = function(e) {
    var button;
    if (isConnected) {
      alert("I'm busy.");
      return;
    }
    button = e.target;
    button.disabled = true;
    _ajaxLikeRequest({
      url: 'ti/hello',
      params: {
        message: 'Hello'
      },
      success: function(data) {
        alert(data.message);
      },
      error: function(error) {
        alert(error.message);
      },
      complete: function() {
        button.disabled = false;
      }
    });
  };
  _goodbyeBtnHandler = function(e) {
    var button;
    if (isConnected) {
      alert("I'm busy.");
      return;
    }
    button = e.target;
    button.disabled = true;
    _ajaxLikeRequest({
      url: 'ti/goodbye',
      params: {
        message: 'Goodbye'
      },
      success: function(data) {
        alert(data.message);
      },
      error: function(error) {
        alert(error.message);
      },
      complete: function() {
        button.disabled = false;
      }
    });
  };
  hellobtn = document.getElementById('hello_btn');
  hellobtn.addEventListener('click', _helloBtnHandler, false);
  goodbyebtn = document.getElementById('goodbye_btn');
  goodbyebtn.addEventListener('click', _goodbyeBtnHandler, false);
})(window, document);