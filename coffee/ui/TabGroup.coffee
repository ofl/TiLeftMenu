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
    
    pages = [
      {title: 'Red', dir: 'red', option:{}}
      {title: 'Blue(A)', dir: 'blue', option:{name:'A'}}        
      {title: 'Blue(B)', dir: 'blue', option:{name:'B'}}        
      {title: 'Yellow', dir: 'yellow', option:{}}        
    ]    
    
    currentPage = 0
    offsetWidth = 260
    
    isOpen = false
    touchStartX = 0
    touchStarted = false
    
    # UI

    tabGroup = Ti.UI.createTabGroup mix $$.tabGroup,
      tabs: [Ti.UI.createTab $$.tab]
      zIndex: 10         
    tabGroup.tabs[0].window = new (require "#{dir}/#{pages[currentPage].dir}/Window")(tabGroup.tabs[0])
    
    menuWindow = new (require "#{dir}/menu/Window")()
    menuWindow.open()

    maskView = Ti.UI.createView
      width: Ti.UI.FILL
      height: Ti.UI.FILL
      zIndex: 100
      visible: false    

    
    # sh.Shadow tabGroup, 
      # shadowRadius: 2
      # shadowOpacity: 0.6
      # shadowoffsetWidth: {x: -5, y: 5}    


    # Functions  
    
    refresh = ()->
      _addWindow()
      tabGroup.tabs[0].window.refresh()
      return
     
    _catchBubble = (e)->
      switch e.btype        
        when 'showMenu'
          _toggleMenu 'left', isOpen
          maskView.visible = true

        when 'didSelectView'
          nextPage = e.boptions.index
          if nextPage is currentPage
            _toggleMenu 'left', true
          else if pages[nextPage].dir is pages[currentPage].dir
            tabGroup.tabs[0].window.refresh pages[nextPage].option
            _toggleMenu 'left', true          
            currentPage = nextPage
          else
            _switchWindow nextPage
          maskView.visible = false          
      return
      
    _toggleMenu = (direction, isOpen)->
      if direction is 'left'
        left = !isOpen && offsetWidth || 0
      else
        left = !isOpen && -offsetWidth || 0
        
      tabGroup.animate mix($$.animation, left: left)
        , ()->
          isOpen = !isOpen
          return
      return
      
    _switchWindow = (nextPage)->
      animation = 
        left: 320
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT
        duration: 300
        
      tabGroup.animate animation, ()->
        _removeWindow()
        tab = Ti.UI.createTab $$.tab
        tab.window = new (require "#{dir}/#{pages[nextPage].dir}/Window")(tab)
        tab.window.refresh pages[nextPage].option
        tabGroup.setTabs [tab]
        _addWindow()
        tabGroup.setActiveTab tab
        tabGroup.animate mix($$.animation, left: 0), ()->
          currentPage = nextPage
          isOpen = false
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
              if newLeft <= offsetWidth
                tabGroup.left = newLeft
            if newLeft > 30
              touchStarted = true
                     
        when 'touchend'
          touchStarted = false
          if  tabGroup.left >= 140 
            tabGroup.animate mix($$.animation, left: offsetWidth), ()->
              maskView.visible = true
              isOpen = true
          else
            tabGroup.animate mix($$.animation, left: 0), ()->
              isOpen = false 
              maskView.visible = false
      return

    _addWindow = ()->
      w = tabGroup.tabs[0].window
      w.add maskView 
      w.addEventListener 'bubble', _catchBubble
      w.addEventListener 'touchstart', _touchHandler
      w.addEventListener 'touchmove', _touchHandler
      w.addEventListener 'touchend', _touchHandler
      return

    _removeWindow = ()->
      w = tabGroup.tabs[0].window
      w.remove maskView 
      w.removeEventListener 'bubble', _catchBubble
      w.removeEventListener 'touchstart', _touchHandler
      w.removeEventListener 'touchmove', _touchHandler
      w.removeEventListener 'touchend', _touchHandler
      return

    # Event Listeners      

    menuWindow.addEventListener 'bubble', _catchBubble
    
    tabGroup.addEventListener 'open', ()->
      menuWindow.refresh pages
      menuWindow.visible = true #起動時ちらつき防止のため
      return
    

    # Disclose
    
    tabGroup.refresh = refresh
    
    # Load
    _addWindow()
    tabGroup.tabs[0].window.refresh()

    
    trace "end constructor"
    return tabGroup

trace "end load"
    
module.exports = TabGroup
