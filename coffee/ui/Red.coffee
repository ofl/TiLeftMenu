# Shortcuts

dir =  'ui'
mod =  "#{dir}/Main1"

$$ = (require "#{dir}/style").style
trace = (mes)-> Ti.API.info  "#{mod}:#{mes}"
mix = (require 'helpers/util').mix

class View        
  constructor: (tab)->
    trace "start constructor"


    # UI

    view = Ti.UI.createView 
      left: 0
      width: 320
      height: 460
      isShow: false
      backgroundColor: '#990000'
          
    
    leftBtn =  Ti.UI.createButton mix $$.menuBtn,
      left: 10
      title: 'Left'
    view.add leftBtn
    
    rightBtn =  Ti.UI.createButton mix $$.menuBtn,
      right: 10
      title: 'Right'
    view.add rightBtn

    # Functions  
    
  
    refresh = ()->
      return
     
    _bubble = (type, options, propagation, source)->
      view.fireEvent 'bubble',
        btype: type
        boptions: options || {}
        bpropagation: propagation || true
        bsource: source || mod
      return


    # Event Listeners
      
    leftBtn.addEventListener 'click', ()->
      _bubble 'showMenu'
      return
      
    rightBtn.addEventListener 'click', ()->
      _bubble 'showDetail'
      return

    # Disclose
      
    view.refresh = refresh
    
    trace "end constructor"
    return view

trace "end load"
    
module.exports = View