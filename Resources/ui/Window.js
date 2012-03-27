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
    var blueView, currentView, detailView, menuView, redView, tab, tabGroup, touchStartX, touchStarted, window, _bubble, _catchBubble, _switchView, _toggleMenu;
    trace("start constructor");
    touchStartX = 0;
    touchStarted = false;
    window = Ti.UI.createWindow($$.window);
    tab = Ti.UI.createTab({
      window: window
    });
    tabGroup = Ti.UI.createTabGroup({
      tabs: [tab]
    });
    detailView = new (require("" + dir + "/Detail"))();
    detailView.refresh();
    window.add(detailView);
    menuView = new (require("" + dir + "/Menu"))();
    menuView.refresh();
    window.add(menuView);
    blueView = new (require("" + dir + "/Blue"))();
    blueView.visible = false;
    window.add(blueView);
    redView = new (require("" + dir + "/Red"))();
    window.add(redView);
    currentView = redView;
    currentView.isOpened = false;
    _bubble = function(type, options, propagation, source) {
      window.fireEvent('bubble', {
        btype: type,
        boptions: options || {},
        bpropagation: propagation || true,
        bsource: source || mod
      });
    };
    _catchBubble = function(e) {
      var nextView;
      if (e.btype === 'didSelectView') {
        if (e.boptions.index === 0) {
          nextView = redView;
        } else {
          nextView = blueView;
        }
        if (nextView === currentView) {
          _toggleMenu('left', true);
        } else {
          _switchView(nextView);
        }
      } else if (e.btype === 'showMenu') {
        _toggleMenu('left', currentView.isOpened);
      } else if (e.btype === 'showDetail') {
        _toggleMenu('right', currentView.isOpened);
      }
      if (e.bpropagation) {
        _bubble(e.btype, e.boptions, true, e.source);
      }
    };
    _toggleMenu = function(direction, isOpened) {
      var left;
      if (direction === 'left') {
        left = !isOpened && 260 || 0;
      } else {
        left = !isOpened && -260 || 0;
      }
      trace(isOpened);
      currentView.animate(mix($$.animation, {
        left: left
      }), function() {
        currentView.isOpened = !isOpened;
      });
    };
    _switchView = function(nextView) {
      var animation;
      animation = {
        left: 320,
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT,
        duration: 300
      };
      currentView.animate(animation, function() {
        nextView.visible = true;
        currentView.visible = false;
        nextView.animate(mix($$.animation, {
          left: 0
        }), function() {
          currentView = nextView;
          currentView.isOpened = false;
        });
      });
    };
    currentView.addEventListener('touchstart', function(e) {
      touchStartX = parseInt(e.x, 10);
    });
    currentView.addEventListener('touchend', function(e) {
      var isToggled;
      touchStarted = false;
      if (currentView.left < 0) {
        if (currentView.left <= -140) {
          currentView.animate(mix($$.animation, {
            left: -260
          }));
          return currentView.isOpened = true;
        } else {
          currentView.animate(mix($$.animation, {
            left: 0
          }));
          return isToggled = false;
        }
      } else {
        if (currentView.left >= 140) {
          currentView.animate(mix($$.animation, {
            left: 260
          }));
          return currentView.isOpened = true;
        } else {
          currentView.animate(mix($$.animation, {
            left: 0
          }));
          return currentView.isOpened = false;
        }
      }
    });
    currentView.addEventListener('touchmove', function(e) {
      var newLeft, x;
      x = parseInt(e.globalPoint.x, 10);
      newLeft = x - touchStartX;
      if (touchStarted) {
        if (newLeft <= 150 && newLeft >= -150) {
          currentView.left = newLeft;
        }
      }
      if (newLeft > 30 || newLeft < -30) {
        return touchStarted = true;
      }
    });
    menuView.addEventListener('bubble', _catchBubble);
    detailView.addEventListener('bubble', _catchBubble);
    redView.addEventListener('bubble', _catchBubble);
    blueView.addEventListener('bubble', _catchBubble);
    trace("end constructor");
    return tabGroup;
  }
  return Window;
})();
trace("end load");
module.exports = Window;