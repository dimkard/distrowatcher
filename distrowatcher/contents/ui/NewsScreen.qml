/*

    Copyright (C) 2013 Dimitris Kardarakos <dimkard@gmail.com>

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

import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.extras 0.1 as PlasmaExtras
import org.kde.qtextracomponents 0.1 as QtExtras
import org.kde.plasma.core 0.1 as PlasmaCore
import "./js/style.js" as Style
import "../code/logic.js" as Logic
import "./js/globals.js" as Params

//TODO: Currently, it is just a copy of latest newss. Implementation needed.

QtExtras.MouseEventListener {
  id: container
  
  property alias refreshEvery: newsView.refreshEvery
  property int dataCount: newsView.model.count // controls visibility
  property bool isVertical: plasmoid.readConfig("isvertical") // If selected, buttons will be displayed on top
  
  hoverEnabled: true
  function reloadModel() { //addded for triggering reload after user has requested so
    latestNewsListModel.reloadModel();
  }
  
  ListView {
    id:newsView
    
    property int refreshEvery
    property int fontIncreaseFactor
    property bool mouseInsideNews: false
    property bool hoverOnButtons: false
    
    anchors.fill: parent
    height: 100
    snapMode: ListView.SnapToItem
    orientation: ( container.isVertical ) ? Qt.Vertical : Qt.Horizontal
    clip: true // enabled, since flicking may guide items outside the borders of the listView
    interactive: true//in conjunction with property clip: true, results in the expected result (scrolling on click of middle button)
    //currentIndex: -1 //set to -1 to avoid highlighting of 1st record on load
    spacing: 5 //no need for complex calculation here //Style.spacingAsPercentOfRow*(height/Style.numberOfNews)
    highlightMoveDuration: Style.highlightMoveDuration
    maximumFlickVelocity: Style.maximumFlickVelocity;  // decreased, to avoid stuck  
    
    model: latestNewsListModel.latestNewsModel // set latestNewsModel as the target xml model
    
    delegate: News {    //Distro.qml created the layout, putting image and text in the position wanted
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
    
      PlasmaComponents.Button {
	id: goNext

	text: "<"
	width: 35
	height: 35
	font.bold: true
	onClicked: { if ( newsView.currentIndex > 0 )
		      newsView.currentIndex =  newsView.currentIndex - 1;
		  }
	
	}
      
      PlasmaComponents.Button {
	id: goPrevious

	text: ">"
	width: 35
	height: 35
	font.bold: true
	onClicked: { if ( newsView.currentIndex < container.dataCount -1 )
		      newsView.currentIndex =  newsView.currentIndex + 1;	
		  }
      }
    }
    
    Column {
      
      id: fontButtons
      
      //visible: newsView.hoverOnButtons || newsView.mouseInsideNews
      visible: container.containsMouse
      anchors {
	right: parent.right
	verticalCenter: parent.verticalCenter
	rightMargin: 10
      }
      spacing: 5
            
      PlasmaComponents.Button {
	id: incFont

	text: "+"
	width: 35
	height: 35
	font.bold: true
	onClicked: { newsView.fontIncreaseFactor++ ; }	
      }
      
      PlasmaComponents.Button {
	id: decFont

	text: "-"
	width: 35
	height: 35
	font.bold: true
	onClicked: { newsView.fontIncreaseFactor--; }
      }
    }      
    
    NewsListModel {    //get xml data from LatestNewsListModel.qml. LatestNewsListModel contains XmlListModel: latestNewsModel
      id: latestNewsListModel

      interval: parent.refreshEvery
    }
  }
}
