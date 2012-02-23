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
  
  addBtn: 
    # systemButton: Ti.UI.iPhone.SystemButton.ADD
    title: '+'
    style: Ti.UI.iPhone.SystemButtonStyle.BORDERED

  menuBtn: 
    # systemButton: Ti.UI.iPhone.SystemButton.ADD
    width:44
    style: Ti.UI.iPhone.SystemButtonStyle.BORDERED
  editBtn: 
    systemButton: Ti.UI.iPhone.SystemButton.EDIT
  cancelBtn: 
    systemButton: Ti.UI.iPhone.SystemButton.CANCEL
  cameraBtn: 
    systemButton: Ti.UI.iPhone.SystemButton.CAMERA
  doneBtn: 
    systemButton: Ti.UI.iPhone.SystemButton.DONE
  trashBtn: 
    systemButton: Ti.UI.iPhone.SystemButton.TRASH
  fs:
    systemButton: Titanium.UI.iPhone.SystemButton.FLEXIBLE_SPACE

        
exports = style: style

  