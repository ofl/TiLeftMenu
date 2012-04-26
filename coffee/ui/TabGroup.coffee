# Shortcuts

dir =  'ui'
mod =  "#{dir}/TabGroup"

$$ = (require "#{dir}/style").style
trace = (mes)-> Ti.API.info  "#{mod}:#{mes}"
mix = (require 'helpers/util').mix

# sh = require 'com.infinery.ds'

class TabGroup        
  constructor: ()->
    trace "start constructor"
    
    # Local Variables
    
    windowDir = ['red', 'blue']
    
    tabs = []
    currentTabIndex = 0
    nextTabIndex = 0
    offset = 260
    
    isOpened = false
    touchStartX = 0
    touchStarted = false
    isOpendMenu  = false
    
    # UI
    menuWindow = new (require "#{dir}/menu/Window")()
    menuWindow.open()
    
    for win, i_ in windowDir
      tabs.push Ti.UI.createTab $$.tab
      tabs[i_].window = new (require "#{dir}/#{win}/Window")(tabs[i_])
      tabs[i_].maskView = Ti.UI.createView
        width: Ti.UI.FILL
        height: Ti.UI.FILL
        zIndex: 100
        visible: false
      tabs[i_].window.add tabs[i_].maskView 
      if i_ is 0
        tabs[0].window.refresh()

    tabGroup = Ti.UI.createTabGroup mix $$.tabGroup,
      tabs: tabs
      zIndex: 10         
    
    # sh.Shadow tabGroup, 
      # shadowRadius: 2
      # shadowOpacity: 0.6
      # shadowOffset: {x: -5, y: 5}    


    # Functions  
     
    _catchBubble = (e)->
      if e.btype is 'didSelectView'
        nextTabIndex = e.boptions.index
        if nextTabIndex is currentTabIndex
          _toggleMenu 'left', true
        else
          _switchTab nextTabIndex
        tabs[currentTabIndex].maskView.visible = false
      else if e.btype is 'showMenu'
        _toggleMenu 'left', isOpendMenu
        tabs[currentTabIndex].maskView.visible = true
      return
      
    _toggleMenu = (direction, isOpened)->
      if direction is 'left'
        left = !isOpened && offset || 0
      else
        left = !isOpened && -offset || 0
        
      tabGroup.animate mix($$.animation, left: left)
        , ()->
          isOpendMenu = !isOpened
          return
      return
      
    _switchTab = (nextTabIndex)->
      animation = 
        left: 320
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT
        duration: 300
        
      tabGroup.animate animation, ()->
        tabs[nextTabIndex].window.refresh()
        tabGroup.setActiveTab nextTabIndex
        tabGroup.animate mix($$.animation, left: 0), ()->
          currentTabIndex = nextTabIndex
          isOpendMenu = false
          return
        return
      return
      
    _touchHandler = (e)->
      switch e.type
        when 'touchstart'
          touchStartX = parseInt e.x, 10
              
        when 'touchmove'
          if typeof e.globalPoint isnt 'undefined'
            x = parseInt e.globalPoint.x, 10
            newLeft = x - touchStartX
            if touchStarted
              if newLeft <= offset
                tabGroup.left = newLeft
            if newLeft > 30
              touchStarted = true
                     
        when 'touchend'
          touchStarted = false
          if  tabGroup.left >= 140 
            tabGroup.animate mix($$.animation, left: offset), ()->
              tabs[currentTabIndex].maskView.visible = true
              isOpendMenu = true
          else
            tabGroup.animate mix($$.animation, left: 0), ()->
              isOpendMenu = false 
              tabs[currentTabIndex].maskView.visible = false
      return


    # Event Listeners      

    menuWindow.addEventListener 'bubble', _catchBubble
    
    for tab in tabs
      win = tab.window
      win.addEventListener 'bubble', _catchBubble
      win.addEventListener 'touchstart', _touchHandler
      win.addEventListener 'touchmove', _touchHandler
      win.addEventListener 'touchend', _touchHandler

    tabGroup.addEventListener 'open', ()->
      menuWindow.refresh()
      menuWindow.visible = true #起動時ちらつき防止のため
      return

    
    trace "end constructor"
    return tabGroup

trace "end load"
    
module.exports = TabGroup

