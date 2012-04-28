var $$, Window, dir, mix, mod, trace;
dir = 'ui/blue';
mod = "" + dir + "/Window";
$$ = (require("" + dir + "/style")).style;
trace = function(mes) {
  return Ti.API.info("" + mod + ":" + mes);
};
mix = (require('helpers/util')).mix;
Window = (function() {
  function Window(tab) {
    var label, menuBtn, refresh, window, _bubble;
    trace("start constructor");
    window = Ti.UI.createWindow(mix($$.window, {
      title: "Blue",
      backgroundColor: 'blue'
    }));
    menuBtn = Ti.UI.createButton($$.menuBtn);
    window.setLeftNavButton(menuBtn);
    label = Ti.UI.createLabel({
      right: 20,
      width: 100,
      height: 200,
      font: {
        fontSize: 128
      }
    });
    window.add(label);
    refresh = function(option) {
      label.text = option.name;
    };
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
    window.refresh = refresh;
    trace("end constructor");
    return window;
  }
  return Window;
})();
trace("end load");
module.exports = Window;