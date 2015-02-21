
/*

    Copyright (C) 2013 Dimitris Kardarakos <dimkard@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
  ` (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.

*/

import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1 as Extras
import "./js/style.js" as Style

Rectangle {
  id: main

  property int refreshEvery : plasmoid.readConfig("refreshevery") // how often plasmoid will fetch data from the web  
  property int minimumWidth: Style.width // enables set of minimums and dock to panel
  property int minimumHeight: Style.height // enables set of minimums and dock to panel
  property bool verticalLayout: true //TODO: replace with read config
  
  function configChanged() {
    main.refreshEvery = plasmoid.readConfig("refreshevery");
  }
  
  smooth: true
  //width: Style.width
  //height: Style.height
  color: "transparent"
  //state : "hideFavorites" // by default, open in normal mode // TO BE REMOVED, states are using when'

  Component.onCompleted: { // read configuration, in case of change in configuration
    plasmoid.addEventListener('ConfigChanged', configChanged); 
  }
  
  Image {
    id: backgroundImage

    source: ((tabBar.visible && mainTabGroup.currentTab == latestDistrosScreen) /*TODO: Remove, no such a stage exists|| state == "showFavorites" */ ) ?  "./images/distros_bg.png" : "./images/packages_bg.png" // change transparency level in case of packages, since dates fall into the white surface
    anchors.fill: parent
    fillMode: Image.Stretch
  }

  PlasmaCore.Theme {
    id: theme
  }

  PlasmaComponents.TabBar { // select which screen shall be visible (Distros/Packages)
    id: tabBar
    rotation: 0
    height: Style.tabBarHeightProportion*main.height
    width: Style.tabBarWidthProportion*parent.width
    anchors {
      top: main.top
      topMargin:main.height*Style.marginScreenPercent
      horizontalCenter: parent.horizontalCenter
    }
    
    visible: latestDistrosScreen.dataCount > 0 // to be displayed only if model returns data

    PlasmaComponents.TabButton {
      id: distrosTabButton
      
      tab: latestDistrosScreen
      text: i18n("Distributions")
    }
    PlasmaComponents.TabButton {
      id: packagesTabButton
      
      tab: latestPackagesScreen
      text:i18n("Packages")
    }
    PlasmaComponents.TabButton {
      id: favoritesTabButton
      
      tab: favoriteDistrosScreen
      text:i18n("Favorites")
    }
    
  }

  
// temporarily disable

  PlasmaComponents.TabGroup {   // contains the distros/packages screens
    id: mainTabGroup
    
    anchors {
      top: (tabBar.visible ? tabBar.bottom : tabBar.top) // if tab bar is not visible, fill the whole screen
      left: main.left
      right: main.right
      bottom: aboutText.top
      margins: main.height*Style.marginScreenPercent
    }
     visible: latestDistrosScreen.dataCount > 0 // to be displayed only if model returns data
    
    
    LatestDistrosScreen {
      id: latestDistrosScreen
      
      anchors.fill: parent
      refreshEvery: main.refreshEvery
    }
      
    LatestPackagesScreen {
      id: latestPackagesScreen
      
      anchors.fill: parent
      refreshEvery: main.refreshEvery
    }
    SearchableFavorites {
      id: favoriteDistrosScreen
    
      anchors.fill: parent
      visible: true // visibility is controled by opacity 
    }
  }

  UnavailableScreen {
    id: offlineScreen
    
    anchors {
      margins: main.height*Style.marginScreenPercent
      horizontalCenter: parent.horizontalCenter
      fill: parent
    }
    //visible: (latestDistrosScreen.dataCount <= 0 || latestDistrosScreen.dataCount == undefined) && main.state == "hideFavorites" // to be displayed if models contain no data and we are not in favorites //TO BE REMOVED
    onReloadClicked: {
      latestDistrosScreen.reloadModel();
      latestPackagesScreen.reloadModel();
    }
  }
    
  Rectangle { // in the bottom display that the web source (distrowatch)
    id: aboutText
    
    color: "transparent"
    height: theme.smallMediumIconSize  // to ensure that icon fits to the text size
    width: main.width
    anchors {
      bottom: main.bottom
      horizontalCenter: main.horizontalCenter
    }
    Text {
      id: aboutTextLabel
     
      anchors.fill: parent
      verticalAlignment: Text.AlignBottom
      horizontalAlignment: Text.AlignHCenter
      font.pointSize: theme.smallestFont.pointSize
      color: theme.textColor
      text: i18n("Data from distrowatch.com")
    }
  }
  
  //20150221: Remove favorites button
//   Extras.MouseEventListener { // catch action in the 'favorites' button/image
//     id: favoritesIcon	
//     
//     visible: (main.state == "showFavorites" || (main.state == "nonFavAvailable" && mainTabGroup.currentTab == latestDistrosScreen)) //to be displayed only in distros and favorites views
//     width: theme.smallMediumIconSize
//     height: theme.smallMediumIconSize
//     hoverEnabled: true
//     state: "hideFavoriteButton" //by default do not display button (thus, display image)
//     anchors {
//       bottom: main.bottom
//       right: main.right
//     }
// 
//     PlasmaComponents.Button {
//       id: iconButton
//       
//       property int buttonState: -1 // -1: Non-favorite mode, 1: Favorite mode
//       
//       anchors.fill: parent
//       checkable: false
//       iconSource: (buttonState == 1) ? QIcon("draw-arrow-back") : QIcon("bookmarks")
//       visible: (main.state == "showFavorites" || (main.state == "nonFavAvailable" && mainTabGroup.currentTab == latestDistrosScreen)) //to be displayed only in distros and favorites views
//       width: theme.smallMediumIconSize
//       height: theme.smallMediumIconSize
//       minimumWidth: theme.smallIconSize
//       minimumHeight: theme.smallIconSize
//       
//       onClicked: {
// 	buttonState *= -1 //toggle state
//       }
//     }
// 
//     Extras.QIconItem {
//       id: noButtonIconItem
//       
//       icon: (main.state == "showFavorites") ? QIcon("draw-arrow-back") : QIcon("bookmarks")
//       smooth: true
//       visible: (main.state == "showFavorites" || (main.state == "nonFavAvailable" && mainTabGroup.currentTab == latestDistrosScreen)) //to be displayed only in distros and favorites views
//       anchors.centerIn: parent
//       width: theme.smallIconSize
//       height: theme.smallIconSize
//     }
//     
//     onVisibleChanged: { 
//       if (!visible) 
// 	state = "hideFavoriteButton"
//     }
//     onContainsMouseChanged: {
//       if(containsMouse)
// 	state = "showFavoriteButton"
//       else
// 	state = "hideFavoriteButton"
//     }
//       
//     states: [ //button states
//       State {
// 	name: "showFavoriteButton"
// 	
// 	PropertyChanges {
// 	  target: iconButton
// 	  opacity: 1
// 	}
// 	PropertyChanges {
// 	  target: noButtonIconItem
// 	  opacity: 0
// 	}
//       //StateChangeScript { script: console.log("button state = showFavoriteButton") } //DEBUG ONLY
//       },
//       State {
// 	name: "hideFavoriteButton"
// //	when: !favoritesIcon.containsMouse || !favoritesIcon.visible
// 	PropertyChanges {
// 	  target: iconButton
// 	  opacity: 0
// 	}
// 	PropertyChanges {
// 	  target: noButtonIconItem
// 	  opacity: 1
// 	}
//       //StateChangeScript { script: console.log("button state = hideFavoriteButton") } //DEBUG ONLY
//       }
//   ]
//   
//   transitions: [
//     Transition {
//       NumberAnimation {
// 	properties: "opacity"
// 	easing.type: Easing.InOutQuad
// 	duration: 300
//       }
//     }
//   ]	
//   }


  //20150221: Not needed since favorites are added to layout
//   PlasmaCore.ToolTip {
//     id: favoriteTooltip
//     
//     target: favoritesIcon
//     mainText: (main.state == "showFavorites") ? i18n("Return to latest distributions") : i18n("Select your favorite distributions")
//   }
//   


 states: [ // control show/hide of favorites screen
//     State {
//       name: "showFavorites"
//       when: iconButton.buttonState == 1 // -1: Non-favorite mode, 1: Favorite mode
//       
//       PropertyChanges {
// 	target: mainTabGroup
// 	opacity: 0
//       }
//       PropertyChanges {
// 	target: tabBar
// 	opacity: 0
//       }
//       PropertyChanges {
// 	target: favoriteDistrosScreen 
// 	opacity: 1
//       }
//       PropertyChanges {
// 	target: offlineScreen
// 	opacity: 0
//       }
//       PropertyChanges {
// 	target: aboutText
// 	opacity: 1
//       }
//      // StateChangeScript { script: console.log("state = showFavorites") } //DEBUG ONLY
// 
//     },
    State {
      name: "nonFavAvailable"
      when: latestDistrosScreen.dataCount > 0 
      PropertyChanges {
	target: mainTabGroup
	opacity: 1
      }
      PropertyChanges {
	target: tabBar
	opacity: 1
      }
//       PropertyChanges {
// 	target: favoriteDistrosScreen 
// 	opacity: 0
//       }	
      PropertyChanges {
	target: offlineScreen
	opacity: 0
      }
      PropertyChanges {
	target: aboutText
	opacity: 1
      }
      //StateChangeScript { script: console.log("state = nonFavAvailable") } //DEBUG ONLY
    },
    State {
      name: "nonFavUnavailable"
      when: (latestDistrosScreen.dataCount <= 0 || latestDistrosScreen.dataCount == undefined)
      PropertyChanges {
	target: mainTabGroup
	opacity: 0
      }
      PropertyChanges {
	target: tabBar
	opacity: 0
      }
//       PropertyChanges {
// 	target: favoriteDistrosScreen 
// 	opacity: 0
//       }	
      PropertyChanges {
	target: offlineScreen
	opacity: 1
      }
      PropertyChanges {
	target: aboutText
	opacity: 0
      }      
      //StateChangeScript { script: console.log("state = nonFavUnavailable") } //DEBUG ONLY
    }    
  ]
  
  transitions: [ // transition between states
    Transition {
      NumberAnimation {
	properties: "opacity"
	easing.type: Easing.InOutQuad
	duration: 500
      }
    }
  ]
}