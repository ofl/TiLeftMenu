var $$, View, dir, mix, mod, trace;
dir = 'ui';
mod = "" + dir + "/Blue";
$$ = (require("" + dir + "/style")).style;
trace = function(mes) {
  return Ti.API.info("" + mod + ":" + mes);
};
mix = (require('helpers/util')).mix;
View = (function() {
  function View(tab) {
    var leftBtn, refresh, rightBtn, view, _bubble;
    trace("start constructor");
    view = Ti.UI.createView({
      left: 0,
      width: 320,
      height: 460,
      isShow: false,
      backgroundColor: '#000099'
    });
    leftBtn = Ti.UI.createButton(mix($$.menuBtn, {
      left: 10,
      title: 'Left'
    }));
    view.add(leftBtn);
    rightBtn = Ti.UI.createButton(mix($$.menuBtn, {
      right: 10,
      title: 'Right'
    }));
    view.add(rightBtn);
    refresh = function() {};
    _bubble = function(type, options, propagation, source) {
      view.fireEvent('bubble', {
        btype: type,
        boptions: options || {},
        bpropagation: propagation || true,
        bsource: source || mod
      });
    };
    leftBtn.addEventListener('click', function() {
      _bubble('showMenu');
    });
    rightBtn.addEventListener('click', function() {
      _bubble('showDetail');
    });
    view.refresh = refresh;
    trace("end constructor");
    return view;
  }
  return View;
})();
trace("end load");
module.exports = View;