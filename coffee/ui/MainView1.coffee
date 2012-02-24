# Shortcuts

dir =  'ui'
mod =  "#{dir}/Main1"

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
      backgroundColor: '#990000'
          

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
      

    # Disclose
      
    view.refresh = refresh
    
    trace "end constructor"
    return view

trace "end load"
    
module.exports = Menu