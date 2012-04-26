mix = (require 'helpers/util').mix

theme = 
  blackText: '#333333'
  lightBlackText: '#666666'
  barColor: '#808080'
  buttonBackground: '#777777'
  background: '#eee'
  darkBackground: '#333333'
  blueText: '#336699'
  darkBlue: '#93caed'
  lightGrayBackground: '#eee'
  white: '#fff'
  fontFamily: 'Helvetica Neue'
  

    
style = 
  theme: theme
    
  window: 
    tabBarHidden: true
    navBarHidden: false
    barColor: theme.barColor
    backgroundColor: theme.background
    orientationModes:  [Ti.UI.PORTRAIT]  
    width: 320
    height: Ti.UI.FILL
    
  tab:
    width: 320
    height: Ti.UI.FILL
    
  tabGroup:
    width: 320
    height: Ti.UI.FILL
  
  tableView: 
    backgroundColor: theme.background
  
  tableViewRow: 
    color: theme.blackText
  
  menuBtn: 
    style: Ti.UI.iPhone.SystemButtonStyle.BORDERED
    title: 'Menu'
    
  animation:
    curve: Ti.UI.iOS.ANIMATION_CURVE_EASE_OUT
    duration: 500
    


        
exports = style: style


  