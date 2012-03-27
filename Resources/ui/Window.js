var $$, Window, dir, mix, mod, trace;
dir = 'ui';
mod = "" + dir + "/Window";
$$ = (require("" + dir + "/style")).style;
trace = function(mes) {
  return Ti.API.info("" + mod + ":" + mes);
};
mix = (require('helpers/util')).mix;
Window = (function() {
  function Window() {
    var color, detailView, floatWindow, menuView, tab, tabGroup, touchStartX, touchStarted, window, _bubble, _catchBubble, _switchColor, _toggleMenu, _touchHandler;
    trace("start constructor");
    touchStartX = 0;
    touchStarted = false;
    color = 'red';
    window = Ti.UI.createWindow($$.window);
    tab = Ti.UI.createTab({
      window: window
    });
    tabGroup = Ti.UI.createTabGroup({
      tabs: [tab]
    });
    detailView = new (require("" + dir + "/Detail"))();
    detailView.left = 30;
    detailView.refresh();
    window.add(detailView);
    menuView = new (require("" + dir + "/Menu"))();
    menuView.width = 280;
    menuView.refresh();
    window.add(menuView);
    floatWindow = new (require("" + dir + "/FloatWindow"))();
    window.add(floatWindow);
    _bubble = function(type, options, propagation, source) {
      window.fireEvent('bubble', {
        btype: type,
        boptions: options || {},
        bpropagation: propagation || true,
        bsource: source || mod
      });
    };
    _catchBubble = function(e) {
      var nextColor;
      if (e.btype === 'didSelectView') {
        if (e.boptions.index === 0) {
          nextColor = 'red';
        } else {
          nextColor = 'blue';
        }
        if (nextColor === color) {
          _toggleMenu('left', true);
        } else {
          _switchColor(nextColor);
        }
      } else if (e.btype === 'showMenu') {
        _toggleMenu('left', floatWindow.isOpened);
      } else if (e.btype === 'showDetail') {
        _toggleMenu('right', floatWindow.isOpened);
      }
      if (e.bpropagation) {
        _bubble(e.btype, e.boptions, true, e.source);
      }
    };
    _toggleMenu = function(direction, isOpened) {
      var left;
      if (direction === 'left') {
        left = !isOpened && 260 || 0;
        menuView.width = 280;
      } else {
        left = !isOpened && -260 || 0;
        menuView.width = 30;
      }
      floatWindow.animate(mix($$.animation, {
        left: left
      }), function() {
        floatWindow.isOpened = !isOpened;
      });
    };
    _switchColor = function(nextColor) {
      var animation;
      menuView.width = 320;
      animation = {
        left: 320,
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT,
        duration: 300
      };
      floatWindow.animate(animation, function() {
        floatWindow.refresh(nextColor);
        floatWindow.animate(mix($$.animation, {
          left: 0
        }), function() {
          color = nextColor;
          floatWindow.isOpened = false;
          menuView.width = 280;
        });
      });
    };
    _touchHandler = function(e) {
      var newLeft, x;
      switch (e.type) {
        case 'touchstart':
          touchStartX = parseInt(e.x, 10);
          break;
        case 'touchmove':
          x = parseInt(e.globalPoint.x, 10);
          newLeft = x - touchStartX;
          if (touchStarted) {
            if (newLeft <= 260 && newLeft >= -260) {
              floatWindow.left = newLeft;
            }
          }
          if (newLeft > 30 || newLeft < -30) {
            touchStarted = true;
          }
          if (newLeft < 0) {
            menuView.width = 30;
          } else {
            menuView.width = 280;
          }
          break;
        case 'touchend':
          touchStarted = false;
          if (floatWindow.left < 0) {
            if (floatWindow.left <= -140) {
              floatWindow.animate(mix($$.animation, {
                left: -260
              }), function() {
                return floatWindow.isOpened = true;
              });
            } else {
              floatWindow.animate(mix($$.animation, {
                left: 0
              }), function() {
                return floatWindow.isOpened = false;
              });
            }
          } else {
            if (floatWindow.left >= 140) {
              floatWindow.animate(mix($$.animation, {
                left: 260
              }), function() {
                return floatWindow.isOpened = true;
              });
            } else {
              floatWindow.animate(mix($$.animation, {
                left: 0
              }), function() {
                return floatWindow.isOpened = false;
              });
            }
          }
      }
    };
    floatWindow.addEventListener('touchstart', _touchHandler);
    floatWindow.addEventListener('touchmove', _touchHandler);
    floatWindow.addEventListener('touchend', _touchHandler);
    menuView.addEventListener('bubble', _catchBubble);
    detailView.addEventListener('bubble', _catchBubble);
    floatWindow.addEventListener('bubble', _catchBubble);
    trace("end constructor");
    return tabGroup;
  }
  return Window;
})();
trace("end load");
module.exports = Window;