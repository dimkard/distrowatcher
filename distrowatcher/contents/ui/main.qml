
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
  property bool isVertical: plasmoid.readConfig("isvertical"); // If selected, buttons will be displayed on top
  
  function configChanged() {
    main.refreshEvery = plasmoid.readConfig("refreshevery");
    main.isVertical =  plasmoid.readConfig("isvertical");
  }
  
  smooth: true
  width: Style.width
  height: Style.height
  color: "transparent"
  //state : "hideFavorites" // by default, open in normal mode // TO BE REMOVED, states are using when'

  Component.onCompleted: { // read configuration, in case of change in configuration
    plasmoid.addEventListener('ConfigChanged', configChanged); 
  }
  
//   Rectangle {
//     rotation: 270
//     width: parent.height - (theme.smallestFont.pointSize + 7)
//     height: parent.width
//     anchors.verticalCenter: parent.verticalCenter
//     anchors.horizontalCenter: parent.horizontalCenter
//     color: "transparent"
//     gradient: Gradient {
//       GradientStop { position: 0.1; color: "transparent" }
//       GradientStop { position: 0.15; color: (tabButAndGroup.currentTabName === "Distributions" || tabButAndGroup.currentTabName === "Favorites" ? "white" : "transparent") }
//       GradientStop { position: 0.3; color: "transparent" }
//     }
//   }

//   Image {
//     id: backgroundImage
// 
//     source: ((tabButAndGroup.visible && (tabButAndGroup.item.currentTabName === "Distributions" || tabButAndGroup.item.currentTabName === "Favorites")) ) ?  "./images/distros_bg.png" : "./images/packages_bg.png" // change transparency level in case of packages, since dates fall into the white surface
//     anchors.fill: parent
//     fillMode: Image.Stretch
//   }
  
  

  PlasmaCore.Theme {
    id: theme
  }
  
/*
  Column {
    id: tabButAndGroup

    anchors {
      top: main.top
      topMargin:main.height*Style.marginScreenPercent
      horizontalCenter: parent.horizontalCenter
    }
    
    spacing: 15
    width: parent.width
    height: parent.height - (theme.smallestFont.pointSize + 30) // parent - bottom text - spacing
    
    visible: latestDistrosScreen.dataCount > 0 // to be displayed only if model returns data
    
    PlasmaComponents.TabBar { // select which screen shall be visible (Distros/Packages)
      id: tabBar
      rotation: 0
      height: Style.tabBarHeightProportion*parent.height
      width: Style.tabBarWidthProportion*parent.width
      anchors.horizontalCenter: parent.horizontalCenter;
      
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
       
    PlasmaComponents.TabGroup {   // contains the distros/packages screens
      id: mainTabGroup
      
      height: (1-Style.tabBarHeightProportion)*parent.height
      width:  parent.width
     
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
	visible: true
      }
    }
  }
*/


  Loader {
    id: tabButAndGroup
    
    property int refreshEvery: main.refreshEvery
    
    function reloadModels() {
      if (tabButAndGroup.status == Loader.Ready) {
	item.reloadModels();
      }
    }
	  
    onStatusChanged: if (tabButAndGroup.status == Loader.Ready) { item.refreshEvery = tabButAndGroup.refreshEvery; }
    onRefreshEveryChanged: if (tabButAndGroup.status == Loader.Ready) item.refreshEvery = tabButAndGroup.refreshEvery;
    source: (main.isVertical) ? "VerticalLayout.qml" : "HorizontalLayout.qml"
    anchors.left: main.left
    width: parent.width
    height: parent.height - (theme.smallestFont.pointSize + ( main.isVertical ? 30 : 15 ) )  // parent - bottom text - spacing (30 for vertival, 14 for horizontal
  }
  
//   HorizontalLayout {
//     id: tabButAndGroup
// 
//     visible: dataExists // to be displayed only if model returns data
//     refreshEvery: main.refreshEvery
//     
//     anchors.left: main.left
//     spacing: 15
//     width: parent.width
//     height: parent.height - (theme.smallestFont.pointSize + 15) // parent - bottom text - spacing
//   }

  //TODO: Switch needed
//   VerticalLayout {
//     id: tabButAndGroup
// 
//     visible: dataExists // to be displayed only if model returns data
//     refreshEvery: main.refreshEvery
//     
//     
//     anchors {
//       top: main.top
//       topMargin:main.height*Style.marginScreenPercent
//       horizontalCenter: parent.horizontalCenter
//     }
//     
//     spacing: 15
//     width: parent.width
//     height: parent.height - (theme.smallestFont.pointSize + 30) // parent - bottom text - spacing
//   }

  UnavailableScreen {
    id: offlineScreen
    
    anchors {
      margins: main.height*Style.marginScreenPercent
      horizontalCenter: parent.horizontalCenter
      fill: parent
    }
    //visible: (latestDistrosScreen.dataCount <= 0 || latestDistrosScreen.dataCount == undefined) && main.state == "hideFavorites" // to be displayed if models contain no data and we are not in favorites //TO BE REMOVED
    onReloadClicked: {
      tabButAndGroup.reloadModels();
      tabButAndGroup.reloadModels();
    }
  }
    
  Rectangle { // in the bottom display that the web source (distrowatch)
    id: aboutText
    
    color: "transparent"
    height: theme.smallestFont.pointSize + 15
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
  
 states: [ // control show/hide of favorites screen
    State {
      name: "nonFavAvailable"
      when: tabButAndGroup.item.dataExists
      //20150221 Since tab group and buttons container exists
      PropertyChanges {
	target: tabButAndGroup
	opacity: 1
      }
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
      when: (!tabButAndGroup.item.dataExists)
      //20150221 Since tab group and buttons container exists
      PropertyChanges {
	target: tabButAndGroup
	opacity: 0
      }
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