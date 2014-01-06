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
import org.kde.plasma.core 0.1 as PlasmaCore
import "./js/style.js" as Style

PlasmaExtras.ScrollArea {
  id: scrollArea
  
  property alias refreshEvery: packageView.refreshEvery
  property int dataCount: packageView.model.count // controls visibility
  
  ListView {
    id:packageView
    
    property int refreshEvery
    
    orientation: Qt.Vertical
    clip: true // enabled, since flicking may guide items outside the borders of the listView
    interactive: true //in conjunction with property clip: true, results in the expected result (scrolling on click of middle button)
    currentIndex: -1 //set to -1 to avoid highlighting of 1st record on load
    spacing: 5 //no need for complex calculation here //Style.spacingAsPercentOfRow*(height/Style.numberOfPackages)
    highlight: PlasmaComponents.Highlight {
      hover: true
      width: packageView.width
    }	
    highlightMoveDuration: Style.highlightMoveDuration
    maximumFlickVelocity: Style.maximumFlickVelocity;  // decreased, to avoid stuck  
    
    model: latestPackageListModel.latestPackageModel // set latestPackageModel as the target xml model
    
    delegate: LatestPackage {    //Distro.qml created the layout, putting image and text in the position wanted
      id: latestPackageItem
      
      height: (packageView.height - (Style.numberOfPackages -1)*packageView.spacing)/Style.numberOfPackages
      width: packageView.width
      titleText: model.title
      dateText: model.date
      packageText: model.packageName
      linkText: model.link
      itemIndex: parseInt(model.index)
      
      onPositionChanged: {  //on mouse move, set currentIndex of the ListView to the current item, so as to be highlighted
	if(!packageView.flicking)
	  packageView.currentIndex = itemIndex ; // do not change index during flicking. Otherwise, set currentIndex to follow model index
	}  
    }      
    
    LatestPackageListModel {    //get xml data from LatestPackageListModel.qml. LatestPackageListModel contains XmlListModel: latestPackageModel
      id: latestPackageListModel

      interval: parent.refreshEvery
    }
  }
}
