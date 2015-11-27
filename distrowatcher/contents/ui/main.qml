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
import "./js/style.js" as Style

Rectangle {
  id: main

  property int refreshEvery : plasmoid.configuration.refreshevery
  property int minimumWidth: Style.width // enables set of minimums and dock to panel
  property int minimumHeight: Style.height // enables set of minimums and dock to panel
  property bool isVertical: plasmoid.configuration.isvertical

  smooth: true
  width: Style.width
  height: Style.height
  color: "transparent"  

  Loader {
    id: tabButAndGroup
    
    property int refreshEvery: main.refreshEvery
    
    function reloadModels() {
      if (tabButAndGroup.status == Loader.Ready) {
	item.reloadModels();
      }
    }

    source: (main.isVertical) ? "VerticalLayout.qml" : "HorizontalLayout.qml"
    anchors.left: main.left
    width: parent.width
    height: parent.height - (theme.smallestFont.pointSize + ( main.isVertical ? 30 : 15 ) )
    
    onStatusChanged: if (tabButAndGroup.status == Loader.Ready) { 
        item.refreshEvery = tabButAndGroup.refreshEvery;
        offlineScreen.technicalError = "";
        }
        else if (tabButAndGroup.status == Loader.Error) {
            console.log("DW: Error Loading tabButAndGroup");
            offlineScreen.technicalError = i18n("An error has occurred initializing the widget. Check documentation and ensure that all the required packages have been installed.");
        }
    onRefreshEveryChanged: if (tabButAndGroup.status == Loader.Ready) { 
        item.refreshEvery = tabButAndGroup.refreshEvery;
    }
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
  
 states: [ // control show/hide of main layout
    State {
      name: "dataAvailable"
      when: tabButAndGroup.item.dataExists

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
    },
    State {
      name: "dataNotAvailable"
      when: (!tabButAndGroup.item.dataExists)

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
    }    
  ]
  
  transitions: [
    Transition {
      NumberAnimation {
	properties: "opacity"
	easing.type: Easing.InOutQuad
	duration: 500
      }
    }
  ]
}