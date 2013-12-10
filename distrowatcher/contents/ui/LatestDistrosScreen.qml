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
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.plasma.extras 0.1 as PlasmaExtras 
import "./js/style.js" as Style

PlasmaExtras.ScrollArea {
  id: distroScrollArea

  property alias refreshEvery: distroView.refreshEvery
  property int dataCount: distroView.model.count //controls visibility
  
    //added only to test notifications
  function checkForNewDistros() {
    distroView.model.checkForNewDistros();
  }
  
  onDataCountChanged: { //checkForNewDistros when a new list is available
    if (distroScrollArea.dataCount > 0 ) {
      distroView.model.checkForNewDistros();
      // debug only console.log("count:" + distroScrollArea.dataCount);
    }
  }

  ListView {
    id:distroView
    
    property int cnt: 0 //only to add numbering to logs
    property int refreshEvery

    orientation: Qt.Vertical
    //debug only //onCurrentIndexChanged: console.log("currentIndex: " + currentIndex ); 
    interactive: true
    clip: true // enabled, since flicking may guide items outside the borders of the listView
    currentIndex: -1 //set to -1 to avoid highlighting of 1st record on load
    //boundsBehavior: Flickable.StopAtBounds // removed, default is back
    spacing: Style.spacingAsPercentOfRow*(height/Style.numberOfDistros)
    maximumFlickVelocity: Style.maximumFlickVelocity  // this pair avoid plasmoid "stuck"
    highlightMoveDuration: Style.highlightMoveDuration
    
    model: distroListModel.latestModel // set latest as the target xml model
    
    delegate: Distro {    //Distro.qml created the layout, putting image and text in the position wanted
      id: latestDistroItem
      
      height: (distroView.height - (Style.numberOfDistros - 1)*distroView.spacing)/Style.numberOfDistros
      width: distroView.width //- scrollBar.width
      titleText: model.title
      dateText: model.date
      distroText : model.distro
      distroShortText : model.distroShortName
      linkText: model.link
      //itemIndex: parseInt(model.itemIndex)  //item by position, not used
      itemIndex: parseInt(model.index) // index of item
      onPositionChanged: {  //on mouse move, set currentIndex of the ListView to the current item, so as to be highlighted
	distroView.flicking ? distroView.currentIndex = distroView.currentIndex : distroView.currentIndex = itemIndex ; // index change during flicking disabled
	//console.log(distroView.cnt++ + ": Distro index: " + itemIndex);
      }
    }

    highlight: PlasmaComponents.Highlight {
      hover: true
      width: distroView.width //- scrollBar.width
    }
    
    DistroListModel {    //get xml data from DistroListModel.qml. DistroListModel contains XmlListModel: latest
      id: distroListModel
      
      interval: distroView.refreshEvery
    }	
  }
}