# Shortcuts

dir =  'ui'
mod =  "#{dir}/FloatWindow"

$$ = (require "#{dir}/style").style
trace = (mes)-> Ti.API.info  "#{mod}:#{mes}"
mix = (require 'helpers/util').mix


class Window        
  constructor: ()->
    trace "start constructor"
    
    # Local Variables
    
    # UI

    window = Ti.UI.createWindow mix $$.window,
      left: 0
      width: 320
      height: 460
      backgroundColor: '#990000'

    leftBtn =  Ti.UI.createButton mix $$.menuBtn,
      left: 10
      title: 'Left'
    window.add leftBtn
    
    rightBtn =  Ti.UI.createButton mix $$.menuBtn,
      right: 10
      title: 'Right'
    window.add rightBtn


    # Functions  

  
    refresh = (color)->
      if color is 'red'
        window.backgroundColor = '#990000'      
      else
        window.backgroundColor = '#000099'
      return
          
    _bubble = (type, options, propagation, source)->
      window.fireEvent 'bubble',
        btype: type
        boptions: options || {}
        bpropagation: propagation || true
        bsource: source || mod
      return
    
    _catchBubble = (e)->
      return
      
    leftBtn.addEventListener 'click', ()->
      _bubble 'showMenu'
      return
      
    rightBtn.addEventListener 'click', ()->
      _bubble 'showDetail'
      return
      

    # Disclose
      
    window.refresh = refresh
    
    trace "end constructor"
    return window

trace "end load"
    
module.exports = Window