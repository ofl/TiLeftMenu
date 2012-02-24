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
    
    currentView = null
    Z_INDEX_TOP = 3
    Z_INDEX_BOTTOM = 0
    
    offset = null

        
    # UI

    window = Ti.UI.createWindow $$.window

    tab = Ti.UI.createTab
      window: window    
    tabGroup = Ti.UI.createTabGroup({tabs:[tab]})               


      
    rightView = new (require "#{dir}/RightView")()
    window.add rightView
      
    leftView = new (require "#{dir}/LeftView")()
    window.add leftView

    scrollView = Ti.UI.createScrollView
      scrollType: "vertical"
      contentWidth:880
      contentHeight:'auto'
      contentOffset:{x:-250, y:0}
      showVerticalScrollIndicator:false
      showHorizontalScrollIndicator:false        
      width: 'auto'
      height: 'auto'
      top: 0
      left: 0    
    window.add scrollView
    
    mainView2 = new (require "#{dir}/MainView2")()
    mainView2.zIndex = Z_INDEX_BOTTOM
    mainView2.left = 260
    mainView2.visible = false
    scrollView.add mainView2
    
    mainView1 = new (require "#{dir}/MainView1")()
    mainView1.zIndex = Z_INDEX_BOTTOM
    mainView1.left = 260
    scrollView.add mainView1

    dummyView = Ti.UI.createView
      width: 40
      height: 460
      left: 280
      zIndex:20
    
    # sh.Shadow mainView1, 
      # shadowRadius: 2
      # shadowOpacity: 0.6
      # shadowOffset: {x: -5, y: 5}    

    currentView = mainView1    


    # Functions  
    
    _catchBubble = (e)->
      if e.btype is 'didSelect'
        _createTodo e.boptions.created
      if e.btype is 'closeNavGroup' or e.btype is 'closePallet'
        isOpenCamer = true
      if e.btype is 'openPallet'
        isOpenCamer = false
      if e.btype is 'didClickAddBtn'
        _add()
      if e.btype is 'didClickMenuBtn'
        _showMenu()
      if e.btype is 'didSelectTodo'
        window = new (require "#{dir}/tags/Window")()
        window.refresh e.boptions.id
        tab.open window
      if e.btype is 'didSelectView'
        if e.boptions.index is 0
          nextView = mainTable
        else
          nextView = settingView
        if nextView is currentView
          _hideMenu()
        else
          _switchView nextView
      if e.bpropagation
        _bubble e.btype, e.boptions, true, e.source
      return
    


      
    _showMenu = ()->
      menuView.refresh()
      menuView.isShow = ! menuView.isShow
      left = if menuView.isShow then 280 else 0
      animation = Ti.UI.createAnimation left: left, duration: 350
      currentView.animate animation
      return
      
    _hideMenu = ()->
      menuView.isShow = ! menuView.isShow
      left = if menuView.isShow then 280 else 0
      animation = Ti.UI.createAnimation left: left, duration: 350
      currentView.animate animation
      return
      
    _switchView = (nextView)->
      menuView.isShow = false;
      beHidden = Ti.UI.createAnimation left: 320, duration: 300
      beHidden.addEventListener "complete", ()->
        currentView.hide()
        currentView.zIndex = Z_INDEX_BOTTOM
        nextView.show()
        nextView.zIndex = Z_INDEX_TOP
        beShown =  Ti.UI.createAnimation left: 0, duration: 350
        nextView.animate beShown
        currentView = nextView
      currentView.animate beHidden
      return
      

    # Event Listeners
      
    scrollView.addEventListener 'dragStart', (e)->
      trace 'ahooo'
      # scrollView.contentWidth = 860
      # mainView1.left = 250
      # rightView.zIndex = 3
      # rightView.width = 320
      scrollView.left = 0
      scrollView.width = 320
      return
      
    scrollView.addEventListener 'dragEnd', (e)->
      # scrollView.contentWidth -=  offset
      # mainView1.left = 0
      
      if offset <200
        scrollView.scrollTo 0,0
        window.add dummyView
        scrollView.canCancelEvents = false
        scrollView.touchEnabled = false
        # setTimeout ()->
          # rightView.width = 250
          # rightView.zIndex = 15
        # , 400
      else if offset < 500
        scrollView.scrollTo 260,0
      else
        scrollView.scrollTo 520,0
        scrollView.width = 60
      return
      
    dummyView.addEventListener 'touchmove', (e)->
      trace 'koko'
      window.remove dummyView
      scrollView.touchEnabled = true
      scrollView.fireEvent 'dragStart'
      return

    mainView1.addEventListener 'singletap', (e)->
      trace 'koko'
      return

      
    scrollView.addEventListener 'scroll', (e)->
      offset = e.x
      trace offset
      if offset < 150
        # leftView.visible = true
        # rightView.visible = false
        # leftView.width = 320 - offset
        leftView.visible = true
      else if offset < 280
        leftView.width = 280
        leftView.visible = true
      else
        leftView.width = 30
        leftView.visible = true
        # leftView.visible = false
        # rightView.visible = true
        # leftView.visible = false
      return
      
    leftView.addEventListener 'bubble', _catchBubble
    rightView.addEventListener 'bubble', _catchBubble
    mainView1.addEventListener 'bubble', _catchBubble
    mainView2.addEventListener 'bubble', _catchBubble

    # Disclose
    
    trace "end constructor"
    return tabGroup


trace "end load"
    
module.exports = Window
