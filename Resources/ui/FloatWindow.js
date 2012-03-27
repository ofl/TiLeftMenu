var $$, Window, dir, mix, mod, trace;
dir = 'ui';
mod = "" + dir + "/FloatWindow";
$$ = (require("" + dir + "/style")).style;
trace = function(mes) {
  return Ti.API.info("" + mod + ":" + mes);
};
mix = (require('helpers/util')).mix;
Window = (function() {
  function Window() {
    var leftBtn, refresh, rightBtn, window, _bubble, _catchBubble;
    trace("start constructor");
    window = Ti.UI.createWindow(mix($$.window, {
      left: 0,
      width: 320,
      height: 460,
      backgroundColor: '#990000'
    }));
    leftBtn = Ti.UI.createButton(mix($$.menuBtn, {
      left: 10,
      title: 'Left'
    }));
    window.add(leftBtn);
    rightBtn = Ti.UI.createButton(mix($$.menuBtn, {
      right: 10,
      title: 'Right'
    }));
    window.add(rightBtn);
    refresh = function(color) {
      if (color === 'red') {
        window.backgroundColor = '#990000';
      } else {
        window.backgroundColor = '#000099';
      }
    };
    _bubble = function(type, options, propagation, source) {
      window.fireEvent('bubble', {
        btype: type,
        boptions: options || {},
        bpropagation: propagation || true,
        bsource: source || mod
      });
    };
    _catchBubble = function(e) {};
    leftBtn.addEventListener('click', function() {
      _bubble('showMenu');
    });
    rightBtn.addEventListener('click', function() {
      _bubble('showDetail');
    });
    window.refresh = refresh;
    trace("end constructor");
    return window;
  }
  return Window;
})();
trace("end load");
module.exports = Window;