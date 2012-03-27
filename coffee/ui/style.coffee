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
    navBarHidden: true
    barColor: theme.barColor
    backgroundColor: theme.background
    orientationModes:  [Ti.UI.PORTRAIT]  
  
  tableView: 
    backgroundColor: theme.background
  
  tableViewRow: 
    color: theme.blackText
  
  menuBtn: 
    width: 60
    height: 30
    top: 10


        
exports = style: style

  