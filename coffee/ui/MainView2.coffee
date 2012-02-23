# Shortcuts

dir =  'ui'
mod =  "#{dir}/Main2"

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
      backgroundColor: '#000099'
          

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
      

    # Disclose
      
    view.refresh = refresh
    
    trace "end constructor"
    return view

trace "end load"
    
module.exports = Menu