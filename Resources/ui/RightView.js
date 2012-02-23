var $$, Menu, dir, mix, mod, trace;
dir = 'ui';
mod = "" + dir + "/RightView";
$$ = (require("" + dir + "/style")).style;
trace = function(mes) {
  return Ti.API.info("" + mod + ":" + mes);
};
mix = (require('helpers/util')).mix;
Menu = (function() {
  function Menu(tab) {
    var refresh, tableView, view, _bubble;
    trace("start constructor");
    view = Ti.UI.createView({
      left: 0,
      width: 320,
      height: 460,
      isShow: false
    });
    tableView = Ti.UI.createTableView(mix($$.tableView, {
      backgroundColor: '#fff'
    }));
    view.add(tableView);
    refresh = function() {
      var data, item, row, rows, _i, _len;
      data = [
        {
          title: 'todo'
        }, {
          title: 'setting'
        }
      ];
      rows = [];
      for (_i = 0, _len = data.length; _i < _len; _i++) {
        item = data[_i];
        row = Ti.UI.createTableViewRow({
          title: item.title
        });
        rows.push(row);
      }
      tableView.setData(rows);
    };
    _bubble = function(type, options, propagation, source) {
      view.fireEvent('bubble', {
        btype: type,
        boptions: options || {},
        bpropagation: propagation || true,
        bsource: source || mod
      });
    };
    tableView.addEventListener('click', function(e) {
      _bubble('didSelectView', {
        index: e.index
      });
    });
    view.refresh = refresh;
    trace("end constructor");
    return view;
  }
  return Menu;
})();
trace("end load");
module.exports = Menu;