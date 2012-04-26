# Shortcuts

dir =  'ui/red'
mod =  "#{dir}/Window"

$$ = (require "#{dir}/style").style
trace = (mes)-> Ti.API.info  "#{mod}:#{mes}"
mix = (require 'helpers/util').mix

class Window        
  constructor: (tab)->
    trace "start constructor"


    # UI

    window = Ti.UI.createWindow mix $$.window,
      title: "Red"
      backgroundColor: 'red'
      
    menuBtn =  Ti.UI.createButton $$.menuBtn
    window.setLeftNavButton menuBtn

    label = Ti.UI.createLabel
      right: 20
      width: 100
      height: 200 
      font:{fontSize:128}
      text: 1
    window.add label
    
    button =  Ti.UI.createButton 
      left: 0
      width: 150
      height: 50
      title: 'Hello'
    window.add button

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
      
    menuBtn.addEventListener 'click', (e)->
      _bubble 'showMenu'
      # window.touchEnabled = false
      # tab.touchEnabled = false
      return

    button.addEventListener 'click', (e)->
      win = new (require "#{dir}/red2/Window")(tab)
      tab.open win
      return


    # Disclose
      
    window.refresh = refresh
    
    trace "end constructor"
    return window

trace "end load"
    
module.exports = Window

