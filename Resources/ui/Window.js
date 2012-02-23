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
    var Z_INDEX_BOTTOM, Z_INDEX_TOP, currentView, leftView, mainView1, mainView2, offset, rightView, scrollView, tab, tabGroup, window, _catchBubble, _hideMenu, _showMenu, _switchView;
    trace("start constructor");
    currentView = null;
    Z_INDEX_TOP = 3;
    Z_INDEX_BOTTOM = 0;
    offset = null;
    window = Ti.UI.createWindow($$.window);
    tab = Ti.UI.createTab({
      window: window
    });
    tabGroup = Ti.UI.createTabGroup({
      tabs: [tab]
    });
    leftView = new (require("" + dir + "/LeftView"))();
    window.add(leftView);
    rightView = new (require("" + dir + "/RightView"))();
    window.add(rightView);
    scrollView = Ti.UI.createScrollView({
      scrollType: "vertical",
      contentWidth: 860,
      contentHeight: 'auto',
      contentOffset: {
        x: -250,
        y: 0
      },
      showVerticalScrollIndicator: false,
      showHorizontalScrollIndicator: false,
      width: 320,
      height: 'auto',
      top: 0,
      left: 0
    });
    window.add(scrollView);
    mainView2 = new (require("" + dir + "/MainView2"))();
    mainView2.zIndex = Z_INDEX_BOTTOM;
    mainView2.left = 250;
    mainView2.visible = false;
    scrollView.add(mainView2);
    mainView1 = new (require("" + dir + "/MainView1"))();
    mainView1.zIndex = Z_INDEX_BOTTOM;
    mainView1.left = 250;
    scrollView.add(mainView1);
    currentView = mainView1;
    _catchBubble = function(e) {
      var isOpenCamer, nextView;
      if (e.btype === 'didSelect') {
        _createTodo(e.boptions.created);
      }
      if (e.btype === 'closeNavGroup' || e.btype === 'closePallet') {
        isOpenCamer = true;
      }
      if (e.btype === 'openPallet') {
        isOpenCamer = false;
      }
      if (e.btype === 'didClickAddBtn') {
        _add();
      }
      if (e.btype === 'didClickMenuBtn') {
        _showMenu();
      }
      if (e.btype === 'didSelectTodo') {
        window = new (require("" + dir + "/tags/Window"))();
        window.refresh(e.boptions.id);
        tab.open(window);
      }
      if (e.btype === 'didSelectView') {
        if (e.boptions.index === 0) {
          nextView = mainTable;
        } else {
          nextView = settingView;
        }
        if (nextView === currentView) {
          _hideMenu();
        } else {
          _switchView(nextView);
        }
      }
      if (e.bpropagation) {
        _bubble(e.btype, e.boptions, true, e.source);
      }
    };
    _showMenu = function() {
      var animation, left;
      menuView.refresh();
      menuView.isShow = !menuView.isShow;
      left = menuView.isShow ? 290 : 0;
      animation = Ti.UI.createAnimation({
        left: left,
        duration: 350
      });
      currentView.animate(animation);
    };
    _hideMenu = function() {
      var animation, left;
      menuView.isShow = !menuView.isShow;
      left = menuView.isShow ? 290 : 0;
      animation = Ti.UI.createAnimation({
        left: left,
        duration: 350
      });
      currentView.animate(animation);
    };
    _switchView = function(nextView) {
      var beHidden;
      menuView.isShow = false;
      beHidden = Ti.UI.createAnimation({
        left: 320,
        duration: 300
      });
      beHidden.addEventListener("complete", function() {
        var beShown;
        currentView.hide();
        currentView.zIndex = Z_INDEX_BOTTOM;
        nextView.show();
        nextView.zIndex = Z_INDEX_TOP;
        beShown = Ti.UI.createAnimation({
          left: 0,
          duration: 350
        });
        nextView.animate(beShown);
        return currentView = nextView;
      });
      currentView.animate(beHidden);
    };
    scrollView.addEventListener('dragStart', function(e) {
      trace('ahooo');
      scrollView.contentWidth = 860;
      mainView1.left = 250;
    });
    scrollView.addEventListener('dragEnd', function(e) {
      if (offset < 200) {
        scrollView.scrollTo(0, 0);
      } else if (offset < 500) {
        scrollView.scrollTo(250, 0);
      } else {
        scrollView.scrollTo(500, 0);
      }
    });
    scrollView.addEventListener('scroll', function(e) {
      offset = e.x;
      trace(e.x);
    });
    leftView.addEventListener('bubble', _catchBubble);
    rightView.addEventListener('bubble', _catchBubble);
    mainView1.addEventListener('bubble', _catchBubble);
    mainView2.addEventListener('bubble', _catchBubble);
    trace("end constructor");
    return tabGroup;
  }
  return Window;
})();
trace("end load");
module.exports = Window;