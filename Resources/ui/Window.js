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
    var blueView, currentView, detailView, dummyView, menuView, offset, redView, scrollView, tab, tabGroup, window, _bubble, _catchBubble, _hideDetail, _hideMenu, _showDetail, _showMenu, _switchView;
    trace("start constructor");
    currentView = null;
    offset = null;
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
    scrollView = Ti.UI.createScrollView({
      canCancelEvents: false,
      scrollType: "vertical",
      contentWidth: 880,
      contentHeight: 'auto',
      contentOffset: {
        x: -250,
        y: 0
      },
      showVerticalScrollIndicator: false,
      showHorizontalScrollIndicator: false,
      width: 'auto',
      height: 'auto',
      top: 0,
      left: 0
    });
    window.add(scrollView);
    blueView = new (require("" + dir + "/Blue"))();
    blueView.left = 260;
    blueView.visible = false;
    scrollView.add(blueView);
    redView = new (require("" + dir + "/Red"))();
    redView.left = 260;
    scrollView.add(redView);
    setTimeout(function() {
      return scrollView.scrollTo(260, 0);
    }, 50);
    dummyView = Ti.UI.createView({
      width: 40,
      height: 460,
      left: 280,
      zIndex: 20
    });
    currentView = redView;
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
          _hideMenu();
        } else {
          _switchView(nextView);
        }
      } else if (e.btype === 'showMenu') {
        if (offset > 200) {
          _showMenu();
        } else {
          _hideMenu();
        }
      } else if (e.btype === 'showDetail') {
        if (offset < 500) {
          _showDetail();
        } else {
          _hideDetail();
        }
      }
      if (e.bpropagation) {
        _bubble(e.btype, e.boptions, true, e.source);
      }
    };
    _showMenu = function() {
      scrollView.scrollTo(0, 0);
      window.add(dummyView);
      scrollView.touchEnabled = false;
    };
    _hideMenu = function() {
      window.remove(dummyView);
      scrollView.touchEnabled = true;
      scrollView.fireEvent('dragStart');
      scrollView.scrollTo(260, 0);
    };
    _switchView = function(nextView) {
      scrollView.scrollTo(-60, 0);
      setTimeout(function() {
        currentView.visible = false;
        nextView.visible = true;
        _hideMenu();
        return currentView = nextView;
      }, 200);
    };
    _showDetail = function() {
      scrollView.scrollTo(520, 0);
      setTimeout(function() {
        return scrollView.width = 60;
      }, 300);
    };
    _hideDetail = function() {
      scrollView.width = 320;
      scrollView.scrollTo(260, 0);
    };
    scrollView.addEventListener('dragStart', function(e) {
      scrollView.left = 0;
      scrollView.width = 320;
    });
    scrollView.addEventListener('dragEnd', function(e) {
      if (offset < 200) {
        scrollView.scrollTo(0, 0);
        window.add(dummyView);
        scrollView.touchEnabled = false;
      } else if (offset < 500) {
        scrollView.scrollTo(260, 0);
      } else {
        scrollView.scrollTo(520, 0);
        scrollView.width = 60;
      }
    });
    scrollView.addEventListener('scroll', function(e) {
      offset = e.x;
      if (offset < 280) {
        menuView.width = 280;
      } else {
        menuView.width = 30;
      }
    });
    dummyView.addEventListener('touchmove', function(e) {
      window.remove(dummyView);
      scrollView.touchEnabled = true;
      scrollView.fireEvent('dragStart');
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