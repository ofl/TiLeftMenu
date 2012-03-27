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
    
    offset = null

        
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

    scrollView = Ti.UI.createScrollView
      canCancelEvents: false
      scrollType: "vertical"
      contentWidth:880
      contentHeight:'auto'
      contentOffset:{x:-250, y:0} #この要素が作用しない
      showVerticalScrollIndicator:false
      showHorizontalScrollIndicator:false        
      width: 'auto'
      height: 'auto'
      top: 0
      left: 0    
    window.add scrollView
    
    blueView = new (require "#{dir}/Blue")()
    blueView.left = 260 #scrollViewにおけるoffset
    blueView.visible = false
    scrollView.add blueView
    
    redView = new (require "#{dir}/Red")()
    redView.left = 260
    scrollView.add redView
    
    setTimeout ()->
      scrollView.scrollTo 260, 0 #contentOffsetが作用しないため起動時にスクロール
    , 50


#左側のmenuが表示されているときにscrollViewのtouchEnableをfalseしないとmenuを押すことができない。
#しかし逆にscrollViewをタッチできなくすると今度はそちらを操作したい時に反応してくれない。
#そのためmenuが表示された時にダミーのviewをaddしてviewに対してtouchmoveされるとscrollViewのtouchEnableをtrueという無理やりな実装
#当然ながら、あまりうまくいっていない。

    dummyView = Ti.UI.createView 
      width: 40
      height: 460
      left: 280
      zIndex:20
    
    # sh.Shadow redView, 
      # shadowRadius: 2
      # shadowOpacity: 0.6
      # shadowOffset: {x: -5, y: 5}    

    currentView = redView  #現在のview。Red or Blue


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
          _hideMenu()
        else
          _switchView nextView
      else if e.btype is 'showMenu'
        if offset > 200
          _showMenu()
        else      
          _hideMenu()
      else if e.btype is 'showDetail'
        if offset < 500
          _showDetail()
        else
          _hideDetail()
          
      if e.bpropagation
        _bubble e.btype, e.boptions, true, e.source
      return
      
    _showMenu = ()->
      scrollView.scrollTo 0,0
      window.add dummyView
      scrollView.touchEnabled = false     
      return
      
    _hideMenu = ()->
      window.remove dummyView
      scrollView.touchEnabled = true
      scrollView.fireEvent 'dragStart'
      scrollView.scrollTo 260,0
      return
      
    _switchView = (nextView)->
      scrollView.scrollTo -60,0
      setTimeout ()->
        currentView.visible = false
        nextView.visible = true
        _hideMenu()
        currentView = nextView
      , 200
      return
      
    _showDetail = ()->
      scrollView.scrollTo 520,0
      setTimeout ()->
        scrollView.width = 60
      , 300
      return      
      
    _hideDetail = ()->
      scrollView.width = 320
      scrollView.scrollTo 260,0
      return      

    # Event Listeners
      
    scrollView.addEventListener 'dragStart', (e)->
      scrollView.left = 0
      scrollView.width = 320
      return
      
    scrollView.addEventListener 'dragEnd', (e)->
      if offset <200
        scrollView.scrollTo 0,0
        window.add dummyView
        scrollView.touchEnabled = false
      else if offset < 500
        scrollView.scrollTo 260,0
      else
        scrollView.scrollTo 520,0
        scrollView.width = 60
      return
      
    scrollView.addEventListener 'scroll', (e)->
      offset = e.x
      if offset < 280
        menuView.width = 280
      else
        menuView.width = 30
      return
      
    dummyView.addEventListener 'touchmove', (e)->
      window.remove dummyView
      scrollView.touchEnabled = true
      scrollView.fireEvent 'dragStart'
      return

      
    menuView.addEventListener 'bubble', _catchBubble
    detailView.addEventListener 'bubble', _catchBubble
    redView.addEventListener 'bubble', _catchBubble
    blueView.addEventListener 'bubble', _catchBubble

    # Disclose
    
    trace "end constructor"
    return tabGroup


trace "end load"
    
module.exports = Window
