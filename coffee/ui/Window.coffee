# Shortcuts

dir =  'ui'
mod =  "#{dir}/Window"

$$ = (require "#{dir}/style").style
trace = (mes)-> Ti.API.info  "#{mod}:#{mes}"
mix = (require 'helpers/util').mix

# sh = require 'com.infinery.ds'


class Window        
  constructor: ()->
    trace "start constructor"
    
    # Local Variables
    
    touchStartX = 0
    touchStarted = false
    
    # UI

    window = Ti.UI.createWindow $$.window

    tab = Ti.UI.createTab
      window: window    
    tabGroup = Ti.UI.createTabGroup({tabs:[tab]})               

      
    detailView = new (require "#{dir}/Detail")()
    detailView.refresh()
    window.add detailView
      
    menuView = new (require "#{dir}/Menu")()
    menuView.refresh()
    window.add menuView
    
    blueView = new (require "#{dir}/Blue")()
    blueView.visible = false
    window.add blueView
    
    redView = new (require "#{dir}/Red")()
    window.add redView

    currentView = redView  #現在のview。Red or Blue
    currentView.isOpened = false
        
    # sh.Shadow redView, 
      # shadowRadius: 2
      # shadowOpacity: 0.6
      # shadowOffset: {x: -5, y: 5}    


    # Functions  
     
    _bubble = (type, options, propagation, source)->
      window.fireEvent 'bubble',
        btype: type
        boptions: options || {}
        bpropagation: propagation || true
        bsource: source || mod
      return
    
    _catchBubble = (e)->
      if e.btype is 'didSelectView'
        if e.boptions.index is 0
          nextView = redView
        else
          nextView = blueView
        if nextView is currentView
          _toggleMenu 'left', true
        else
          _switchView nextView
      else if e.btype is 'showMenu'
        _toggleMenu 'left', currentView.isOpened
      else if e.btype is 'showDetail'
        _toggleMenu 'right', currentView.isOpened
          
      if e.bpropagation
        _bubble e.btype, e.boptions, true, e.source
      return
      
    _toggleMenu = (direction, isOpened)->
      if direction is 'left'
        left = !isOpened && 260 || 0
      else
        left = !isOpened && -260 || 0
      trace isOpened        
      currentView.animate mix($$.animation, left: left)
        , ()->
          currentView.isOpened = !isOpened
          return
      return
      
    _switchView = (nextView)->
      animation = 
        left: 320
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT
        duration: 300
        
      currentView.animate animation, ()->
        nextView.visible = true
        currentView.visible = false
        nextView.animate mix($$.animation, left: 0)
          , ()->
            currentView = nextView
            currentView.isOpened = false
            return
        return
      return


    # Event Listeners      

    currentView.addEventListener 'touchstart', (e)->
      touchStartX = parseInt e.x,10
      return

    currentView.addEventListener 'touchend', (e)->
      touchStarted = false
      if  currentView.left < 0
        if  currentView.left <= -140
          currentView.animate mix($$.animation, left: -260)
          currentView.isOpened = true
        else
          currentView.animate mix($$.animation, left: 0)
          isToggled = false
      else 
        if  currentView.left >= 140 
          currentView.animate mix($$.animation, left: 260)
          currentView.isOpened = true
        else
          currentView.animate mix($$.animation, left: 0)
          currentView.isOpened = false

    currentView.addEventListener 'touchmove',(e)->
      x = parseInt e.globalPoint.x, 10
      newLeft = x - touchStartX
      if touchStarted
        if newLeft <= 150 && newLeft >= -150
          currentView.left = newLeft
      if newLeft > 30 || newLeft < -30 
        touchStarted = true
        
    menuView.addEventListener 'bubble', _catchBubble
    detailView.addEventListener 'bubble', _catchBubble
    redView.addEventListener 'bubble', _catchBubble
    blueView.addEventListener 'bubble', _catchBubble

    # Disclose
    
    trace "end constructor"
    return tabGroup

trace "end load"
    
module.exports = Window
