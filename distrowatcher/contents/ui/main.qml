/*

    Copyright (C) 2015 Dimitris Kardarakos <dimkard@gmail.com>

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

import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
//import org.kde.qtextracomponents 2.0 as Extras
import "./js/style.js" as Style

Rectangle {
  id: main

  property int refreshEvery : plasmoid.configuration.refreshevery
  property int minimumWidth: Style.width // enables set of minimums and dock to panel
  property int minimumHeight: Style.height // enables set of minimums and dock to panel
  property bool isVertical: plasmoid.configuration.isvertical
  property string logging

//   function configChanged() { //TODO: Remove
//     main.refreshEvery = plasmoid.readConfig("refreshevery");  //TODO: Remove
//     main.isVertical =  plasmoid.readConfig("isvertical"); //TODO: Remove
//   } //TODO: Remove, not needeed in Plasma5

  smooth: true
  width: Style.width
  height: Style.height
  color: "transparent"

//   Component.onCompleted: { // read configuration, in case of change in configuration //TODO: Remove
//     plasmoid.addEventListener('ConfigChanged', configChanged);  //TODO: Remove
//   } ////TODO: Remove Not needeed in Plasma5

  

  Loader {
    id: tabButAndGroup
    
    property int refreshEvery: main.refreshEvery
    
    function reloadModels() {
      if (tabButAndGroup.status == Loader.Ready) {
	item.reloadModels();
      }
    }
	  
    onStatusChanged: if (tabButAndGroup.status == Loader.Ready) { 
        item.refreshEvery = tabButAndGroup.refreshEvery; 
        main.logging = "Ready" //TODO: remove
        }
        else if (tabButAndGroup.status == Loader.Loading) { //TODO: remove
            main.logging = "Loading" //TODO: remove
        }//TODO: remove
        else if (tabButAndGroup.status == Loader.Error) { //TODO: remove
            main.logging = "Error" //TODO: remove
            console.log("DW: Error Loading tabButAndGroup");
        }//TODO: remove
    onRefreshEveryChanged: if (tabButAndGroup.status == Loader.Ready) item.refreshEvery = tabButAndGroup.refreshEvery;
    source: (main.isVertical) ? "VerticalLayout.qml" : "HorizontalLayout.qml"
    anchors.left: main.left
    width: parent.width
    height: parent.height - (theme.smallestFont.pointSize + ( main.isVertical ? 30 : 15 ) )  // parent - bottom text - spacing (30 for vertival, 14 for horizontal //TODO: recover
  }
  
  UnavailableScreen {
    id: offlineScreen
    
    anchors {
      margins: main.height*Style.marginScreenPercent
      horizontalCenter: parent.horizontalCenter
      fill: parent
    }
    onReloadClicked: {
        tabButAndGroup.reloadModels();
        if (tabButAndGroup.status == Loader.Null) //TODO: Remove
            main.logging = "Null";
        if (tabButAndGroup.status == Loader.Ready)  //TODO: Remove
            main.logging = "Ready"; 
        if (tabButAndGroup.status == Loader.Loading) //TODO: Remove
            main.logging = "Loading";        
        if (tabButAndGroup.status == Loader.Error)  //TODO: Remove
            main.logging = "Error" ;
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
      //text: main.logging //TODO: Remove, debug only
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