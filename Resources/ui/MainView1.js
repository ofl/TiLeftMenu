var $$, Menu, dir, mix, mod, trace;
dir = 'ui';
mod = "" + dir + "/Main1";
$$ = (require("" + dir + "/style")).style;
trace = function(mes) {
  return Ti.API.info("" + mod + ":" + mes);
};
mix = (require('helpers/util')).mix;
Menu = (function() {
  function Menu(tab) {
    var refresh, view, _bubble;
    trace("start constructor");
    view = Ti.UI.createView({
      left: 0,
      width: 320,
      height: 460,
      isShow: false,
      backgroundColor: '#990000'
    });
    refresh = function() {};
    _bubble = function(type, options, propagation, source) {
      view.fireEvent('bubble', {
        btype: type,
        boptions: options || {},
        bpropagation: propagation || true,
        bsource: source || mod
      });
    };
    view.refresh = refresh;
    trace("end constructor");
    return view;
  }
  return Menu;
})();
trace("end load");
module.exports = Menu;