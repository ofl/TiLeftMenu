# Shortcuts

dir =  'ui'
mod =  "#{dir}/Detail"

$$ = (require "#{dir}/style").style
trace = (mes)-> Ti.API.info  "#{mod}:#{mes}"
mix = (require 'helpers/util').mix

class Detail        
  constructor: (tab)->
    trace "start constructor"


    # UI

    view = Ti.UI.createView 
      left: 30
      width: 290
      height: 460
      isShow: false
      
    tableView = Ti.UI.createTableView mix $$.tableView,
      backgroundColor: '#ffc'
    view.add tableView
    

    # Functions  
    
  
    refresh = ()->
      data = [
        {title: 'gagaga'}
        {title: 'gogogog'}        
      ]
      rows = []
      for item in data
        row = Ti.UI.createTableViewRow
          title: item.title
          indentionLevel: 3
        rows.push row
      
      tableView.setData rows
      return
     
    _bubble = (type, options, propagation, source)->
      view.fireEvent 'bubble',
        btype: type
        boptions: options || {}
        bpropagation: typeof propagation == 'undefined' && true || propagation
        bsource: source || mod
      return


    # Event Listeners
      
    # tableView.addEventListener 'click', (e)->
      # _bubble 'didSelectView', index: e.index
      # return


    # Disclose
      
    view.refresh = refresh
    
    trace "end constructor"
    return view

trace "end load"
    
module.exports = Detail
