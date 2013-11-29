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
import org.kde.qtextracomponents 0.1 as Extras
import "./js/style.js" as Style
import "./js/globals.js" as Params

Item {
  id: root
  property string linkText: i18n("Link")
  //property string distroText: i18n("Distro")
  property string distroShortText: i18n("Distro Short Name")
  property string distroName: i18n("Distro Name")
  property string latestVersion: i18n("Distro Latest Version")
  property bool isFlicking 
  property int itemIndex
  
  property string isFavoritePostfix: Params.isFavoritePostfix
  signal entered() //inform parent regarding interaction
  signal exited() //inform parent regarding interaction
  signal positionChanged() //inform parent regarding interaction

  // Current KDE theme
  PlasmaCore.Theme {
    id: theme
  } 
  
  MouseArea {
    id: distroRecordMouseArea
    anchors.fill: parent
    onEntered: root.entered();
    onExited: root.exited();
    onClicked: { 
      //debug only // console.log("click" + root.linkText); 
      plasmoid.openUrl(root.linkText);
      //Qt.openUrlExternally(root.linkText);
    }
    onPositionChanged: root.positionChanged();
    hoverEnabled: true
  }
  
  Image {
    id: icon
    anchors {
      verticalCenter : parent.verticalCenter 
      topMargin : root.height*Style.marginPercent // icon distance from row edges
      left : root.left
    }
    width: (root.width - root.width*Style.marginPercent)*Style.iconWidthAsRowPercent
    height: (root.height - root.height*Style.marginPercent)*Style.iconHeightAsRowPercent
    fillMode: Image.PreserveAspectFit
    smooth: true
    source: "./icons/distros/" +  distroShortText + ".png"
    onStatusChanged: if (status == Image.Error) {
			  // we set the icon to an empty image if we failed to find one
			  source = ""
    }
  }

  Text {
      id: distro
      anchors {
	top: icon.top
	left: icon.right
	leftMargin: parent.width*Style.marginInsideRowPercent
	verticalCenter : parent.verticalCenter
      }
      verticalAlignment : Text.AlignVCenter
      text: root.distroName
      font.bold: false
      font.pointSize: theme.desktopFont.pointSize
      horizontalAlignment: Text.AlignLeft
      wrapMode: "WordWrap" 
      color: theme.textColor    
  }  
    //--------------------
    /*
    Image {
      id: star
      visible: root.isCurrentItem || (plasmoid.readConfig(root.distroShortText + root.isFavoritePostfix))
      anchors {
	verticalCenter : parent.verticalCenter 
	rightMargin : root.width*Style.rightMarginPercent // icon distance from right
	topMargin : root.height*Style.marginPercent // icon distance from top
	right: parent.right
      }
      width: (root.width - root.width*Style.marginPercent)*Style.favIconWidthAsRowPercent
      height: (root.height - root.height*Style.marginPercent)*Style.favIconHeightAsRowPercent
      fillMode: Image.PreserveAspectFit
      smooth: true
      onStatusChanged: if (status == Image.Error) {
			    // we set the icon to an empty image if we failed to find one
			    source = ""
      }
      source: (plasmoid.readConfig(root.distroShortText + root.isFavoritePostfix) == true) ? "./icons/favorite.png" : "./icons/non-favorite.png" ;

      MouseArea {
	id: starArea
	anchors.fill: parent
	onClicked: { 	  
	  //console.log("Before set: " + distroShortText + isFavoritePostfix + ": " +  plasmoid.readConfig(root.distroShortText + root.isFavoritePostfix)); //debug only
	  var newFavStatus = (plasmoid.readConfig(root.distroShortText + root.isFavoritePostfix) == true) ? false : true;
	  plasmoid.writeConfig(root.distroShortText + root.isFavoritePostfix, newFavStatus);
	  star.source = (newFavStatus == true) ? "./icons/favorite.png" : "./icons/non-favorite.png" 	  
	  //console.log("After set: " + distroShortText + isFavoritePostfix + ": " + plasmoid.readConfig(root.distroShortText + root.isFavoritePostfix));	//debug only 
	}	
      }
      */
      //----------------
  Extras.MouseEventListener { 
    id: favoritesIcon	
    visible: true
    width: theme.smallMediumIconSize
    height: theme.smallMediumIconSize
    hoverEnabled: true
    state: "hidebutton" //by default show image and hide button
    anchors {
	verticalCenter : parent.verticalCenter 
	rightMargin : root.width*Style.rightMarginPercent // icon distance from right
	topMargin : root.height*Style.marginPercent // icon distance from top
	right: parent.right
      }
    onPositionChanged: root.positionChanged();	
    onContainsMouseChanged: {
      if(!isFlicking) {
	if (containsMouse) {
	  state = "showButton";
	  //starButton.opacity = 1; //display button
	  //star.opacity = 0;
	}
	else {
	  state =  "hideButton";
	  //starButton.opacity = 0; // hide button
	  //star.opacity = 1;
	}
      }
    }
    states: [ //button states
      State {
	name: "showButton"
	PropertyChanges {
	  target: starButton
	  opacity: 1
	  }
	  PropertyChanges {
	  target: star
	  opacity: 0
	  }
      },
      State {
	name: "hideButton"
	PropertyChanges {
	  target: starButton
	  opacity: 0
	}
	PropertyChanges {
	  target: star
	  opacity: 1
	}
      }
    ]
    transitions: [
      Transition {
	NumberAnimation {
	  properties: "opacity"
	  easing.type: Easing.InOutQuad
	  duration: Style.highlightMoveDuration
	}
      }
    ]	

    PlasmaComponents.Button {
      id: starButton
      anchors.fill: parent
      opacity: 0 // by default no button is displayed
      checkable: false
      iconSource: "bookmarks"
      visible: true
      width: theme.smallIconSize
      height: theme.smallIconSize
      minimumWidth: theme.smallIconSize
      minimumHeight: theme.smallIconSize
      onClicked: {
	var newFavStatus = (plasmoid.readConfig(root.distroShortText + root.isFavoritePostfix) == true) ? false : true;
	star.source = (newFavStatus == true) ? "./icons/favorite.png" : "./icons/non-favorite.png" 	  
	plasmoid.writeConfig(root.distroShortText + root.isFavoritePostfix, newFavStatus);
      }
    }

    Image {
      id: star
      visible: true//(plasmoid.readConfig(root.distroShortText + root.isFavoritePostfix))
      anchors.centerIn: parent
      width: theme.smallMediumIconSize
      height: theme.smallMediumIconSize
      fillMode: Image.PreserveAspectFit
      smooth: true
      onStatusChanged: if (status == Image.Error) {
			    // we set the icon to an empty image if we failed to find one
			    source = ""
      }
      source: (plasmoid.readConfig(root.distroShortText + root.isFavoritePostfix) == true) ? "./icons/favorite.png" : "./icons/non-favorite.png" ;
    }
  }
}
 