var $$, TabGroup, dir, mix, mod, trace;
dir = 'ui';
mod = "" + dir + "/TabGroup";
$$ = (require("" + dir + "/style")).style;
trace = function(mes) {
  return Ti.API.info("" + mod + ":" + mes);
};
mix = (require('helpers/util')).mix;
TabGroup = (function() {
  function TabGroup() {
    var currentTabIndex, i_, isOpendMenu, isOpened, menuWindow, nextTabIndex, offset, tab, tabGroup, tabs, touchStartX, touchStarted, win, windowDir, _catchBubble, _i, _len, _len2, _switchTab, _toggleMenu, _touchHandler;
    trace("start constructor");
    windowDir = ['red', 'blue'];
    tabs = [];
    currentTabIndex = 0;
    nextTabIndex = 0;
    offset = 260;
    isOpened = false;
    touchStartX = 0;
    touchStarted = false;
    isOpendMenu = false;
    menuWindow = new (require("" + dir + "/menu/Window"))();
    menuWindow.open();
    for (i_ = 0, _len = windowDir.length; i_ < _len; i_++) {
      win = windowDir[i_];
      tabs.push(Ti.UI.createTab($$.tab));
      tabs[i_].window = new (require("" + dir + "/" + win + "/Window"))(tabs[i_]);
      tabs[i_].maskView = Ti.UI.createView({
        width: Ti.UI.FILL,
        height: Ti.UI.FILL,
        zIndex: 100,
        visible: false
      });
      tabs[i_].window.add(tabs[i_].maskView);
      if (i_ === 0) {
        tabs[0].window.refresh();
      }
    }
    tabGroup = Ti.UI.createTabGroup(mix($$.tabGroup, {
      tabs: tabs,
      zIndex: 10
    }));
    _catchBubble = function(e) {
      if (e.btype === 'didSelectView') {
        nextTabIndex = e.boptions.index;
        if (nextTabIndex === currentTabIndex) {
          _toggleMenu('left', true);
        } else {
          _switchTab(nextTabIndex);
        }
        tabs[currentTabIndex].maskView.visible = false;
      } else if (e.btype === 'showMenu') {
        _toggleMenu('left', isOpendMenu);
        tabs[currentTabIndex].maskView.visible = true;
      }
    };
    _toggleMenu = function(direction, isOpened) {
      var left;
      if (direction === 'left') {
        left = !isOpened && offset || 0;
      } else {
        left = !isOpened && -offset || 0;
      }
      tabGroup.animate(mix($$.animation, {
        left: left
      }), function() {
        isOpendMenu = !isOpened;
      });
    };
    _switchTab = function(nextTabIndex) {
      var animation;
      animation = {
        left: 320,
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT,
        duration: 300
      };
      tabGroup.animate(animation, function() {
        tabs[nextTabIndex].window.refresh();
        tabGroup.setActiveTab(nextTabIndex);
        tabGroup.animate(mix($$.animation, {
          left: 0
        }), function() {
          currentTabIndex = nextTabIndex;
          isOpendMenu = false;
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
          if (typeof e.globalPoint !== 'undefined') {
            x = parseInt(e.globalPoint.x, 10);
            newLeft = x - touchStartX;
            if (touchStarted) {
              if (newLeft <= offset) {
                tabGroup.left = newLeft;
              }
            }
            if (newLeft > 30) {
              touchStarted = true;
            }
          }
          break;
        case 'touchend':
          touchStarted = false;
          if (tabGroup.left >= 140) {
            tabGroup.animate(mix($$.animation, {
              left: offset
            }), function() {
              tabs[currentTabIndex].maskView.visible = true;
              return isOpendMenu = true;
            });
          } else {
            tabGroup.animate(mix($$.animation, {
              left: 0
            }), function() {
              isOpendMenu = false;
              return tabs[currentTabIndex].maskView.visible = false;
            });
          }
      }
    };
    menuWindow.addEventListener('bubble', _catchBubble);
    for (_i = 0, _len2 = tabs.length; _i < _len2; _i++) {
      tab = tabs[_i];
      win = tab.window;
      win.addEventListener('bubble', _catchBubble);
      win.addEventListener('touchstart', _touchHandler);
      win.addEventListener('touchmove', _touchHandler);
      win.addEventListener('touchend', _touchHandler);
    }
    tabGroup.addEventListener('open', function() {
      menuWindow.refresh();
      menuWindow.visible = true;
    });
    trace("end constructor");
    return tabGroup;
  }
  return TabGroup;
})();
trace("end load");
module.exports = TabGroup;