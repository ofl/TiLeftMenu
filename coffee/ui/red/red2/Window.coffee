# Shortcuts

dir =  'ui/red/red2'
mod =  "#{dir}/Window"

$$ = (require "#{dir}/style").style
trace = (mes)-> Ti.API.info  "#{mod}:#{mes}"
mix = (require 'helpers/util').mix

class Window        
  constructor: (tab)->
    trace "start constructor"


    # UI

    window = Ti.UI.createWindow mix $$.window,
      title: "Red2"
      backgroundColor: 'red'
      

    label = Ti.UI.createLabel
      right: 20
      width: 100
      height: 200 
      font:{fontSize:128}
      text: 2
    window.add label

    # Functions  
    
  
    refresh = ()->
      return
     
    _bubble = (type, options, propagation, source)->
      window.fireEvent 'bubble',
        btype: type
        boptions: options || {}
        bpropagation: typeof propagation == 'undefined' && true || propagation
        bsource: source || mod
      return


    # Event Listeners
      


    # Disclose
      
    window.refresh = refresh
    
    trace "end constructor"
    return window

trace "end load"
    
module.exports = Window

