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
    
    #configuration
    pages = [
      {title: 'Red', dir: 'red', option:{}}
      {title: 'Blue(A)', dir: 'blue', option:{name:'A'}}        
      {title: 'Blue(B)', dir: 'blue', option:{name:'B'}}        
      {title: 'Yellow', dir: 'yellow', option:{}}        
    ]    
    offsetWidth = 260
    
    # Local Variables
    
    tabs = {}   #tabs['red'], tabs['blue']
    index = 0    
    touchStartX = 0
    touchStarted = false
    
    # UI
    
    tabs[pages[index].dir] = Ti.UI.createTab $$.tab
    tabGroup = Ti.UI.createTabGroup mix $$.tabGroup,
      tabs: [tabs[pages[index].dir]]
      zIndex: 10         
      left: 0
    tabs[pages[index].dir].window = new (require "#{dir}/#{pages[index].dir}/Window")(tabs[pages[index].dir])
    
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
    
    _catchBubble = (e)->
      switch e.btype        
        when 'showMenu'
          _toggleOpenMenu()
          maskView.visible = true

        when 'didSelectMenu'
          nextIndex = e.boptions.index
          if nextIndex is index
            _toggleOpenMenu true
          else if pages[nextIndex].dir is pages[index].dir
            tabs[pages[nextIndex].dir].window.refresh pages[nextIndex].option
            _toggleOpenMenu true          
            index = nextIndex
          else
            _switchWindow nextIndex
          maskView.visible = false          
      return
      
    _toggleOpenMenu = ()->
      left = if tabGroup.left < 100 then offsetWidth else 0
      tabGroup.animate mix($$.animation, left: left), ()->
        tabGroup.left = left        
        return
      return
      
    _switchWindow = (nextIndex)->
      a = 
        left: 320
        curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT
        duration: 300
        
      tabGroup.animate a, ()->
        tabs[pages[index].dir].window.remove maskView
        d = pages[nextIndex].dir
        if typeof tabs[d] is 'undefined'        
          tabs[d] = Ti.UI.createTab $$.tab
          tabs[d].window = new (require "#{dir}/#{pages[nextIndex].dir}/Window")(tabs[d])
          tabs[d].window.refresh pages[nextIndex].option
          tabGroup.addTab tabs[d]
          _addWindowEvent nextIndex
        tabs[d].window.add maskView           
        tabGroup.setActiveTab tabs[d]
        tabGroup.animate mix($$.animation, left: 0), ()->
          index = nextIndex
          tabGroup.left = 0
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
              tabGroup.left = offsetWidth
              return
          else
            tabGroup.animate mix($$.animation, left: 0), ()->
              maskView.visible = false
              tabGroup.left = 0
              return
      return

    _addWindowEvent = (idx)->
      w = tabs[pages[idx].dir].window
      w.addEventListener 'bubble', _catchBubble
      w.addEventListener 'touchstart', _touchHandler
      w.addEventListener 'touchmove', _touchHandler
      w.addEventListener 'touchend', _touchHandler
      return

    # Event Listeners      

    menuWindow.addEventListener 'bubble', _catchBubble
    
    tabGroup.addEventListener 'open', ()->
      menuWindow.refresh pages
      menuWindow.visible = true #起動時ちらつき防止のため
      return
    

    # Disclose
    
    # Load
    _addWindowEvent index
    tabs[pages[index].dir].window.refresh()

    
    trace "end constructor"
    return tabGroup

trace "end load"
    
module.exports = TabGroup
