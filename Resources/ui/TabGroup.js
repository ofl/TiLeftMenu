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
    var currentPage, isOpen, maskView, menuWindow, offsetWidth, pages, refresh, tabGroup, touchStartX, touchStarted, _addWindow, _catchBubble, _removeWindow, _switchWindow, _toggleMenu, _touchHandler;
    trace("start constructor");
    pages = [
      {
        title: 'Red',
        dir: 'red',
        option: {}
      }, {
        title: 'Blue(A)',
        dir: 'blue',
        option: {
          name: 'A'
        }
      }, {
        title: 'Blue(B)',
        dir: 'blue',
        option: {
          name: 'B'
        }
      }, {
        title: 'Yellow',
        dir: 'yellow',
        option: {}
      }
    ];
    currentPage = 0;
    offsetWidth = 260;
    isOpen = false;
    touchStartX = 0;
    touchStarted = false;
    tabGroup = Ti.UI.createTabGroup(mix($$.tabGroup, {
      tabs: [Ti.UI.createTab($$.tab)],
      zIndex: 10
    }));
    tabGroup.tabs[0].window = new (require("" + dir + "/" + pages[currentPage].dir + "/Window"))(tabGroup.tabs[0]);
    menuWindow = new (require("" + dir + "/menu/Window"))();
    menuWindow.open();
    maskView = Ti.UI.createView({
      width: Ti.UI.FILL,
      height: Ti.UI.FILL,
      zIndex: 100,
      visible: false
    });
    refresh = function() {
      _addWindow();
      tabGroup.tabs[0].window.refresh();
    };
    _catchBubble = function(e) {
      var nextPage;
      switch (e.btype) {
        case 'showMenu':
          _toggleMenu('left', isOpen);
          maskView.visible = true;
          break;
        case 'didSelectView':
          nextPage = e.boptions.index;
          if (nextPage === currentPage) {
            _toggleMenu('left', true);
          } else if (pages[nextPage].dir === pages[currentPage].dir) {
            tabGroup.tabs[0].window.refresh(pages[nextPage].option);
            _toggleMenu('left', true);
            currentPage = nextPage;
          } else {
            _switchWindow(nextPage);
          }
          maskView.visible = false;
      }
    };
    _toggleMenu = function(direction, isOpen) {
      var left;
      if (direction === 'left') {
        left = !isOpen && offsetWidth || 0;
      } else {
        left = !isOpen && -offsetWidth || 0;
      }
      tabGroup.animate(mix($$.animation, {
        left: left
      }), function() {
        isOpen = !isOpen;
      });
    };
    _switchWindow = function(nextPage) {
      var animation;
      animation = {
        left: 320,
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT,
        duration: 300
      };
      tabGroup.animate(animation, function() {
        var tab;
        _removeWindow();
        tab = Ti.UI.createTab($$.tab);
        tab.window = new (require("" + dir + "/" + pages[nextPage].dir + "/Window"))(tab);
        tab.window.refresh(pages[nextPage].option);
        tabGroup.setTabs([tab]);
        _addWindow();
        tabGroup.setActiveTab(tab);
        tabGroup.animate(mix($$.animation, {
          left: 0
        }), function() {
          currentPage = nextPage;
          isOpen = false;
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
              if (newLeft <= offsetWidth) {
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
              left: offsetWidth
            }), function() {
              maskView.visible = true;
              return isOpen = true;
            });
          } else {
            tabGroup.animate(mix($$.animation, {
              left: 0
            }), function() {
              isOpen = false;
              return maskView.visible = false;
            });
          }
      }
    };
    _addWindow = function() {
      var w;
      w = tabGroup.tabs[0].window;
      w.add(maskView);
      w.addEventListener('bubble', _catchBubble);
      w.addEventListener('touchstart', _touchHandler);
      w.addEventListener('touchmove', _touchHandler);
      w.addEventListener('touchend', _touchHandler);
    };
    _removeWindow = function() {
      var w;
      w = tabGroup.tabs[0].window;
      w.remove(maskView);
      w.removeEventListener('bubble', _catchBubble);
      w.removeEventListener('touchstart', _touchHandler);
      w.removeEventListener('touchmove', _touchHandler);
      w.removeEventListener('touchend', _touchHandler);
    };
    menuWindow.addEventListener('bubble', _catchBubble);
    tabGroup.addEventListener('open', function() {
      menuWindow.refresh(pages);
      menuWindow.visible = true;
    });
    tabGroup.refresh = refresh;
    _addWindow();
    tabGroup.tabs[0].window.refresh();
    trace("end constructor");
    return tabGroup;
  }
  return TabGroup;
})();
trace("end load");
module.exports = TabGroup;