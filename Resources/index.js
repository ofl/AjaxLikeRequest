(function(win, doc) {
  var goodbyebtn, hellobtn, isConnected, _ajaxLikeRequest, _goodbye, _hello;
  isConnected = false;
  _ajaxLikeRequest = function(attr) {
    var complete, error, success, _callback;
    success = attr.success || function() {};
    error = attr.error || function() {};
    complete = attr.complete || function() {};
    _callback = function(data) {
      setTimeout(function() {
        if (data.status === 'success') {
          success(data.responseData);
        } else {
          error(data.responseData);
        }
        complete();
        Ti.App.removeEventListener('response', _callback);
        isConnected = false;
      }, 0);
    };
    Ti.App.addEventListener('response', _callback);
    Ti.App.fireEvent('dispatch', {
      fakeUrl: attr.url,
      params: attr.params
    });
    isConnected = true;
  };
  _hello = function(e) {
    var button;
    button = e.target;
    if (isConnected) {
      alert("I'm busy.");
    } else {
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
    }
  };
  _goodbye = function(e) {
    var button;
    button = e.target;
    if (isConnected) {
      alert("I'm busy.");
    } else {
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
    }
  };
  hellobtn = document.getElementById('hellobtn');
  hellobtn.addEventListener('click', _hello, false);
  goodbyebtn = document.getElementById('goodbyebtn');
  goodbyebtn.addEventListener('click', _goodbye, false);
})(window, document);