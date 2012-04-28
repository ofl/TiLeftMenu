# Shortcuts

dir =  'ui'
mod =  "#{dir}/menu/BaseWindow"

$$ = (require "#{dir}/style").style
trace = (mes)-> Ti.API.info  "#{mod}:#{mes}"
mix = (require 'helpers/util').mix

# sh = require 'com.infinery.ds'

class BaseWindow        
  constructor: ()->
    trace "start constructor"
    
    # Local Variables
    
    color = 'red'
    
    # UI

    window = Ti.UI.createWindow mix $$.window,
      navBarHidden: false
      zIndex = 1
      visible: false

    tableView = Ti.UI.createTableView mix $$.tableView,
      backgroundColor: '#333'
    window.add tableView

         
    
    # Functions  
    
    refresh = (pages)->
      # window.visible = true
          
      rows = []
      for item in pages
        row = Ti.UI.createTableViewRow
          title: item.title
          color: '#fff'
          height: 40
        
        rows.push row
      
      tableView.setData rows
      return
           
    _bubble = (type, options, propagation, source)->
      window.fireEvent 'bubble',
        btype: type
        boptions: options || {}
        bpropagation: typeof propagation == 'undefined' && true || propagation
        bsource: source || mod
      return
          

    # Event Listeners
      
    tableView.addEventListener 'click', (e)->
      _bubble 'didSelectMenu', {index: e.index}
      return
    
    # Disclose
    
    window.refresh = refresh
    
    trace "end constructor"
    return window

trace "end load"
    
module.exports = BaseWindow

