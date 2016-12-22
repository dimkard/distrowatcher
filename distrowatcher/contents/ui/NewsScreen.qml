/*

    Copyright (C) 2015 Dimitris Kardarakos <dimkard@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, see <http://www.gnu.org/licenses/>.

*/

import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddons
import org.kde.plasma.core 2.0 as PlasmaCore
import "./js/style.js" as Style
import "../code/logic.js" as Logic
import "./js/globals.js" as Params

KQuickControlsAddons.MouseEventListener {
  id: container
  
  property alias refreshEvery: newsView.refreshEvery
  property int dataCount: newsView.model.count // controls visibility
  property bool isVertical: plasmoid.configuration.isvertical 
  hoverEnabled: true
  function reloadModel() { //addded for triggering reload after user has requested so
    latestNewsListModel.reloadModel();
  }
  
  ListView {
    id:newsView
    
    property int refreshEvery
    property int fontIncreaseFactor:0
    property bool mouseInsideNews: false
    property bool hoverOnButtons: false
    
    anchors.fill: parent
    height: 100
    snapMode: ListView.SnapToItem
    orientation: ( container.isVertical ) ? Qt.Vertical : Qt.Horizontal
    clip: true 
    interactive: false
    spacing: 5 
    highlightMoveDuration: Style.highlightMoveDuration
    maximumFlickVelocity: Style.maximumFlickVelocity
    
    model: latestNewsListModel.latestNewsModel // set latestNewsModel as the target xml model
    
    delegate: News {
      id: latestNewsItem
      
      height: (newsView.height - (Style.numberOfNews -1)*newsView.spacing)/Style.numberOfNews
      width: newsView.width
      titleText: model.title
      dateText: model.date
      newsText: Logic.trimSpace(model.description)
      linkText: model.link
      fontIncreaseFactor: newsView.fontIncreaseFactor
     }

    Row {
      id: navigButtons
      
      visible: container.containsMouse
      anchors {
	bottom: parent.bottom
	horizontalCenter : parent.horizontalCenter
	bottomMargin: 5
      }
      spacing: 5
    
      PlasmaComponents.ToolButton {
	id: goNext

	iconSource: "go-previous"
	width: 30
	height: 30
	font.bold: true
	onClicked: { if ( newsView.currentIndex > 0 )
		      newsView.currentIndex =  newsView.currentIndex - 1;
	}
      }
      
      PlasmaComponents.ToolButton {
	id: goPrevious

	iconSource: "go-next"
	width: 30
	height: 30
	font.bold: true
	onClicked: { if ( newsView.currentIndex < container.dataCount -1 )
		      newsView.currentIndex =  newsView.currentIndex + 1;	
		  }
      }
    }
    
    Column {
      
      id: fontButtons
      
      visible: container.containsMouse
      anchors {
        right: parent.right
        bottom: parent.bottom
        rightMargin: 10
      }
      spacing: 5
            
      PlasmaComponents.ToolButton {
	id: incFont

//    iconSource: "zoom-in"
    text: "+"
    width: 30
//	height: 30
	font.bold: true
	onClicked: { newsView.fontIncreaseFactor++ ; }	
      }
      
      PlasmaComponents.ToolButton {
	id: decFont

//    iconSource: "zoom-out"
    text: "-"
    width: 30
//	height: 30
	font.bold: true
	onClicked: { newsView.fontIncreaseFactor--; }
      }
    }      
    
    NewsListModel {
      id: latestNewsListModel

      interval: parent.refreshEvery
    }
  }
}
