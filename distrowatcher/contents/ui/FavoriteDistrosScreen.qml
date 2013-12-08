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

//Latest Distros Screen
PlasmaExtras.ScrollArea {
  id: distroScrollArea
  property int dataCount: distroView.model.count //controls visibility
    
  function filter_distros (distroFilter) {  //call function to filter distros
    distroListModel.query_model(distroFilter);
  }
  
  flickableItem: 
    ListView {
      id:distroView
      /* header:  //Seems to just add cluttering
	  Text { 
	    id: mytitle 
	    font.bold: true
	    font.pointSize: theme.desktopFont.pointSize
	    color: theme.buttonTextColor
	    anchors.left: distroView.left
	    width: distroView.width
	    horizontalAlignment:Text.AlignHCenter
	    text: i18n("Select your favorite distributions")      
	  }
      */
      //property int cnt: 0 //only to add numbering to logs /debug only
      orientation: Qt.Vertical
      interactive: true
      clip: true // enabled, since flicking may guide items outside the borders of the listView
      currentIndex: -1 //set to -1 to avoid highlighting of 1st record on load
      model: distroListModel.distroModel // set distroModel as the target xml model
      delegate: FavoriteDistro {    //FavoriteDistro.qml created the layout, putting image and text in the position wanted
	id: favoriteDistroItem
	height: theme.largeIconSize // avoid rendering issues
	//(distroView.height - (Style.numberOfFavoriteDistros - 1)*distroView.spacing)/Style.numberOfFavoriteDistros
	width: distroView.width //- scrollBar.width
	//titleText: model.title
	latestVersion: model.latestversion
	distroName: model.distroname
	distroShortText : model.distro_short
	linkText: model.link
//	color: (parseInt(model.index) % 2 == 0) ? "transparent" : theme.backgroundColor
	//color: (parseInt(model.index) % 2 == 0) ? Qt.darker(theme.backgroundColor,1.05) : theme.backgroundColor // we opted for transparency
	itemIndex: parseInt(model.index) // index of item
	isFlicking: distroView.flicking
	onPositionChanged: {  //on mouse move, set currentIndex of the ListView to the current item, so as to be highlighted
	      distroView.flicking ? distroView.currentIndex = distroView.currentIndex : distroView.currentIndex = itemIndex ; // -1 is not needed, since index (not position) is used. Also, index change during flicking disabled.
	}
      }
      spacing: Style.favSpacingAsPercentOfRow*(height/Style.numberOfFavoriteDistros)
      //KDE native highlight
      highlight: PlasmaComponents.Highlight {
	      hover: true
	      width: distroView.width //- scrollBar.width
      }
      maximumFlickVelocity: Style.maximumFlickVelocity;  // this pair avoid plasmoid "stuck"
      //highlightMoveSpeed: 2000;    // ...
      highlightMoveDuration: Style.highlightMoveDuration
      FavoriteDistroListModel {    //get xml data from FavoriteDistroListModel.qml. DistroListModel contains XmlListModel: latest
	id: distroListModel
      }	
    }
}