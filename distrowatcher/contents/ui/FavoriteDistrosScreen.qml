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
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras 
import "./js/style.js" as Style

PlasmaExtras.ScrollArea {
  id: distroScrollArea

  property int dataCount: distroView.model.count //controls visibility
  property bool showRanks: plasmoid.configuration.popularity

  function filterDistros (distroFilter) {  //call function to filter distros
    distroListModel.queryModel(distroFilter);
  }
  
  onShowRanksChanged: distroListModel.reloadModel();
  ListView {
    id:distroView
    
    orientation: Qt.Vertical
    interactive: true
    clip: true // enabled, since flicking may guide items outside the borders of the listView
    currentIndex: -1 //set to -1 to avoid highlighting of 1st record on load
    spacing: 5
    maximumFlickVelocity: Style.maximumFlickVelocity;  // this pair avoid plasmoid "freeze"
    highlightMoveDuration: Style.highlightMoveDuration
    
    model: distroListModel.distroModel // set distroModel as the target xml model
    
    delegate: FavoriteDistro {    //FavoriteDistro.qml created the layout, putting image and text in the position wanted
      id: favoriteDistroItem
        
      height: units.iconSizes.large // avoid rendering issues //changed for plasma5
      width: distroView.width //- scrollBar.width
      latestVersion: model.latestversion
      distroName: model.distroname
      distroShortText : model.distroShortName
      linkText: model.link
      itemIndex: parseInt(model.index) // index of item
      isFlicking: distroView.flicking

      onPositionChanged: {  //on mouse move, set currentIndex of the ListView to the current item, so as to be highlighted
        distroView.flicking ? distroView.currentIndex = distroView.currentIndex : distroView.currentIndex = itemIndex ; 
      }
    }
      
    highlight: PlasmaComponents.Highlight {
      hover: true
      width: distroView.width
    }
    
    FavoriteDistroListModel {  // Get xml data
      id: distroListModel
    }
  }
}
