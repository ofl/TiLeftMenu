# Shortcuts

dir =  'ui'
mod =  "#{dir}/LeftView"

$$ = (require "#{dir}/style").style
trace = (mes)-> Ti.API.info  "#{mod}:#{mes}"
mix = (require 'helpers/util').mix

class Menu        
  constructor: (tab)->
    trace "start constructor"


    # UI

    view = Ti.UI.createView 
      left: 0
      width: 320
      height: 460
      isShow: false
      
    tableView = Ti.UI.createTableView mix $$.tableView,
      backgroundColor: '#666'
    view.add tableView
    

    # Functions  
    
  
    refresh = ()->
      data = [
        {title: 'todo'}
        {title: 'setting'}        
      ]
      rows = []
      for item in data
        row = Ti.UI.createTableViewRow
          title: item.title
        rows.push row
      
      tableView.setData rows
      return
     
    _bubble = (type, options, propagation, source)->
      view.fireEvent 'bubble',
        btype: type
        boptions: options || {}
        bpropagation: propagation || true
        bsource: source || mod
      return


    # Event Listeners
      
    tableView.addEventListener 'click', (e)->
      _bubble 'didSelectView', index: e.index
      return


    # Disclose
      
    view.refresh = refresh
    
    trace "end constructor"
    return view

trace "end load"
    
module.exports = Menu