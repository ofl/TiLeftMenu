var $$, Window, dir, mix, mod, trace;
dir = 'ui/red';
mod = "" + dir + "/Window";
$$ = (require("" + dir + "/style")).style;
trace = function(mes) {
  return Ti.API.info("" + mod + ":" + mes);
};
mix = (require('helpers/util')).mix;
Window = (function() {
  function Window(tab) {
    var button, label, menuBtn, refresh, window, _bubble;
    trace("start constructor");
    window = Ti.UI.createWindow(mix($$.window, {
      title: "Red",
      backgroundColor: 'red'
    }));
    menuBtn = Ti.UI.createButton($$.menuBtn);
    window.setLeftNavButton(menuBtn);
    label = Ti.UI.createLabel({
      right: 20,
      width: 100,
      height: 200,
      font: {
        fontSize: 128
      },
      text: 1
    });
    window.add(label);
    button = Ti.UI.createButton({
      left: 0,
      width: 150,
      height: 50,
      title: 'Hello'
    });
    window.add(button);
    refresh = function() {};
    _bubble = function(type, options, propagation, source) {
      window.fireEvent('bubble', {
        btype: type,
        boptions: options || {},
        bpropagation: typeof propagation === 'undefined' && true || propagation,
        bsource: source || mod
      });
    };
    menuBtn.addEventListener('click', function(e) {
      _bubble('showMenu');
    });
    button.addEventListener('click', function(e) {
      var win;
      win = new (require("" + dir + "/red2/Window"))(tab);
      tab.open(win);
    });
    window.refresh = refresh;
    trace("end constructor");
    return window;
  }
  return Window;
})();
trace("end load");
module.exports = Window;