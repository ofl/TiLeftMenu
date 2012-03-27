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
    
    color = 'red'
    
    # UI

    window = Ti.UI.createWindow $$.window

    tab = Ti.UI.createTab
      window: window    
    tabGroup = Ti.UI.createTabGroup({tabs:[tab]})               

      
    detailView = new (require "#{dir}/Detail")()
    detailView.left = 30
    detailView.refresh()
    window.add detailView
      
    menuView = new (require "#{dir}/Menu")()
    menuView.width = 280
    menuView.refresh()
    window.add menuView
    
    floatWindow = new (require "#{dir}/FloatWindow")()
    window.add floatWindow
        
    # sh.Shadow floatWindow, 
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
          nextColor = 'red'
        else
          nextColor = 'blue'
        if nextColor is color
          _toggleMenu 'left', true
        else
          _switchColor nextColor
      else if e.btype is 'showMenu'
        _toggleMenu 'left', floatWindow.isOpened
      else if e.btype is 'showDetail'
        _toggleMenu 'right', floatWindow.isOpened
          
      if e.bpropagation
        _bubble e.btype, e.boptions, true, e.source
      return
      
    _toggleMenu = (direction, isOpened)->
      if direction is 'left'
        left = !isOpened && 260 || 0
        menuView.width = 280            
      else
        left = !isOpened && -260 || 0
        menuView.width = 30            
      floatWindow.animate mix($$.animation, left: left)
        , ()->
          floatWindow.isOpened = !isOpened
          return
      return
      
    _switchColor = (nextColor)->
      menuView.width = 320            
      animation = 
        left: 320
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT
        duration: 300
        
      floatWindow.animate animation, ()->
        floatWindow.refresh nextColor
        floatWindow.animate mix($$.animation, left: 0), ()->
          color = nextColor
          floatWindow.isOpened = false
          menuView.width = 280            
          return
        return
      return
      
    _touchHandler = (e)->
      switch e.type
        when 'touchstart'
          touchStartX = parseInt e.x, 10
              
        when 'touchmove'
          x = parseInt e.globalPoint.x, 10
          newLeft = x - touchStartX
          if touchStarted
            if newLeft <= 260 && newLeft >= -260
              floatWindow.left = newLeft
          if newLeft > 30 || newLeft < -30 
            touchStarted = true
          if newLeft < 0
            menuView.width = 30
          else
            menuView.width = 280            
                     
        when 'touchend'
          touchStarted = false
          if  floatWindow.left < 0
            if  floatWindow.left <= -140
              floatWindow.animate mix($$.animation, left: -260), ()->
                floatWindow.isOpened = true
            else
              floatWindow.animate mix($$.animation, left: 0), ()->
                floatWindow.isOpened = false 
          else 
            if  floatWindow.left >= 140 
              floatWindow.animate mix($$.animation, left: 260), ()->
                floatWindow.isOpened = true
            else
              floatWindow.animate mix($$.animation, left: 0), ()->
                floatWindow.isOpened = false 
      return


    # Event Listeners      

    floatWindow.addEventListener 'touchstart', _touchHandler
    floatWindow.addEventListener 'touchmove', _touchHandler
    floatWindow.addEventListener 'touchend', _touchHandler
        
    menuView.addEventListener 'bubble', _catchBubble
    detailView.addEventListener 'bubble', _catchBubble
    floatWindow.addEventListener 'bubble', _catchBubble

    # Disclose
    
    trace "end constructor"
    return tabGroup

trace "end load"
    
module.exports = Window

