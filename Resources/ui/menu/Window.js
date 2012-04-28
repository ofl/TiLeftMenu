var $$, BaseWindow, dir, mix, mod, trace;
dir = 'ui';
mod = "" + dir + "/menu/BaseWindow";
$$ = (require("" + dir + "/style")).style;
trace = function(mes) {
  return Ti.API.info("" + mod + ":" + mes);
};
mix = (require('helpers/util')).mix;
BaseWindow = (function() {
  function BaseWindow() {
    var color, refresh, tableView, window, zIndex, _bubble;
    trace("start constructor");
    color = 'red';
    window = Ti.UI.createWindow(mix($$.window, {
      navBarHidden: false
    }, zIndex = 1, {
      visible: false
    }));
    tableView = Ti.UI.createTableView(mix($$.tableView, {
      backgroundColor: '#333'
    }));
    window.add(tableView);
    refresh = function(pages) {
      var item, row, rows, _i, _len;
      rows = [];
      for (_i = 0, _len = pages.length; _i < _len; _i++) {
        item = pages[_i];
        row = Ti.UI.createTableViewRow({
          title: item.title,
          color: '#fff',
          height: 40
        });
        rows.push(row);
      }
      tableView.setData(rows);
    };
    _bubble = function(type, options, propagation, source) {
      window.fireEvent('bubble', {
        btype: type,
        boptions: options || {},
        bpropagation: typeof propagation === 'undefined' && true || propagation,
        bsource: source || mod
      });
    };
    tableView.addEventListener('click', function(e) {
      _bubble('didSelectMenu', {
        index: e.index
      });
    });
    window.refresh = refresh;
    trace("end constructor");
    return window;
  }
  return BaseWindow;
})();
trace("end load");
module.exports = BaseWindow;