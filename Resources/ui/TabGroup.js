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
    var index, maskView, menuWindow, offsetWidth, pages, tabGroup, tabs, touchStartX, touchStarted, _addWindowEvent, _catchBubble, _switchWindow, _toggleOpenMenu, _touchHandler;
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
    offsetWidth = 260;
    tabs = {};
    index = 0;
    touchStartX = 0;
    touchStarted = false;
    tabs[pages[index].dir] = Ti.UI.createTab($$.tab);
    tabGroup = Ti.UI.createTabGroup(mix($$.tabGroup, {
      tabs: [tabs[pages[index].dir]],
      zIndex: 10,
      left: 0
    }));
    tabs[pages[index].dir].window = new (require("" + dir + "/" + pages[index].dir + "/Window"))(tabs[pages[index].dir]);
    menuWindow = new (require("" + dir + "/menu/Window"))();
    menuWindow.open();
    maskView = Ti.UI.createView({
      width: Ti.UI.FILL,
      height: Ti.UI.FILL,
      zIndex: 100,
      visible: false
    });
    _catchBubble = function(e) {
      var nextIndex;
      switch (e.btype) {
        case 'showMenu':
          _toggleOpenMenu();
          maskView.visible = true;
          break;
        case 'didSelectMenu':
          nextIndex = e.boptions.index;
          if (nextIndex === index) {
            _toggleOpenMenu(true);
          } else if (pages[nextIndex].dir === pages[index].dir) {
            tabs[pages[nextIndex].dir].window.refresh(pages[nextIndex].option);
            _toggleOpenMenu(true);
            index = nextIndex;
          } else {
            _switchWindow(nextIndex);
          }
          maskView.visible = false;
      }
    };
    _toggleOpenMenu = function() {
      var left;
      left = tabGroup.left < 100 ? offsetWidth : 0;
      tabGroup.animate(mix($$.animation, {
        left: left
      }), function() {
        tabGroup.left = left;
      });
    };
    _switchWindow = function(nextIndex) {
      var a;
      a = {
        left: 320,
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT,
        duration: 300
      };
      tabGroup.animate(a, function() {
        var d;
        tabs[pages[index].dir].window.remove(maskView);
        d = pages[nextIndex].dir;
        if (typeof tabs[d] === 'undefined') {
          tabs[d] = Ti.UI.createTab($$.tab);
          tabs[d].window = new (require("" + dir + "/" + pages[nextIndex].dir + "/Window"))(tabs[d]);
          tabs[d].window.refresh(pages[nextIndex].option);
          tabGroup.addTab(tabs[d]);
          _addWindowEvent(nextIndex);
        }
        tabs[d].window.add(maskView);
        tabGroup.setActiveTab(tabs[d]);
        tabGroup.animate(mix($$.animation, {
          left: 0
        }), function() {
          index = nextIndex;
          tabGroup.left = 0;
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
              tabGroup.left = offsetWidth;
            });
          } else {
            tabGroup.animate(mix($$.animation, {
              left: 0
            }), function() {
              maskView.visible = false;
              tabGroup.left = 0;
            });
          }
      }
    };
    _addWindowEvent = function(idx) {
      var w;
      w = tabs[pages[idx].dir].window;
      w.addEventListener('bubble', _catchBubble);
      w.addEventListener('touchstart', _touchHandler);
      w.addEventListener('touchmove', _touchHandler);
      w.addEventListener('touchend', _touchHandler);
    };
    menuWindow.addEventListener('bubble', _catchBubble);
    tabGroup.addEventListener('open', function() {
      menuWindow.refresh(pages);
      menuWindow.visible = true;
    });
    _addWindowEvent(index);
    tabs[pages[index].dir].window.refresh();
    trace("end constructor");
    return tabGroup;
  }
  return TabGroup;
})();
trace("end load");
module.exports = TabGroup;