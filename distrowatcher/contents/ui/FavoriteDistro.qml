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
import org.kde.kquickcontrolsaddons 2.0 as KQuickControlsAddons
import "./js/style.js" as Style
import "./js/globals.js" as Params

Item {
  id: root

  property string linkText
  property string distroShortText
  property string distroName
  property string latestVersion
  property bool isFlicking 
  property int itemIndex
  property string isFavoritePostfix: Params.isFavoritePostfix
  property string distroRank
  property bool showRanks: plasmoid.configuration.popularity

  signal entered() //inform parent regarding interaction
  signal exited() //inform parent regarding interaction
  signal positionChanged() //inform parent regarding interaction

  Component.onCompleted: getRank(distroShortText);

  function getRank(distroShortName) {
      if (root.showRanks && plasmoid.configuration[distroShortText + isFavoritePostfix] == true) {
          var doc = new XMLHttpRequest();
          doc.onreadystatechange = function() {
              if (doc.readyState == XMLHttpRequest.DONE) {
                  var rsp = doc.responseText;
                  var reg1263 = /popularity.+12 [^:]+:.+, 6 [^:]+:(.+), 3/;
                  var found1263 = rsp.match(reg1263);
                  if(found1263 && found1263.length > 1) {
                      var distroRankAndHits= found1263[1].trim();
                      var regForRankOnly = />(.+)</;
                      var rankMatch = distroRankAndHits.match(regForRankOnly);
                      if (rankMatch && rankMatch.length >1) {
                          var onlyDigitsReg = /[\d]+/;
                          if (onlyDigitsReg.test(rankMatch[1].trim())) {
                              root.distroRank = rankMatch[1];
                          }
                      }
                  }
              }
          }

        doc.open("GET", "http://distrowatch.com/table.php?distribution=" + distroShortName);
        doc.send();
      }
      else {
          root.distroRank = "";
      }
  }

  Image {
    id: backgroundImage

    source: "./images/distroDelegateBg.png"
    anchors.fill: parent
    fillMode: Image.Stretch
  }
  
  MouseArea {
    id: distroRecordMouseArea

    anchors.fill: parent
    hoverEnabled: true

    onEntered: root.entered();
    onExited: root.exited();
    onClicked: Qt.openUrlExternally(root.linkText);
    onPositionChanged: root.positionChanged();
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
    
    onStatusChanged: if (status == Image.Error) { source = "" }
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
    font.pointSize: theme.defaultFont.pointSize
    horizontalAlignment: Text.AlignLeft
    wrapMode: "WordWrap" 
    color: theme.textColor
  }


  Text {
    id: distroRanker

    anchors {
      top: icon.top
      right: favoritesIcon.left
      rightMargin: parent.width*Style.marginInsideRowPercent
      verticalCenter : parent.verticalCenter
    }
    verticalAlignment : Text.AlignVCenter
    text: root.distroRank
    font.pointSize: theme.defaultFont.pointSize
    horizontalAlignment: Text.AlignLeft
    wrapMode: "WordWrap"
    color: theme.textColor
  }


  KQuickControlsAddons.MouseEventListener { 
    id: favoritesIcon
    
    visible: true
    width: units.iconSizes.smallMedium
    height: units.iconSizes.smallMedium
    hoverEnabled: true
    state: "hidebutton" //by default show image and hide button
    anchors {
	verticalCenter : parent.verticalCenter 
	rightMargin: root.width*Style.rightMarginPercent // icon distance from right
	topMargin : root.height*Style.marginPercent // icon distance from top
	right: parent.right
      }
    
    onPositionChanged: root.positionChanged();
    onContainsMouseChanged: {
      if(!isFlicking)
	if (containsMouse)
	  state = "showButton";
	else
	  state =  "hideButton";
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

    PlasmaComponents.ToolButton {
      id: starButton
      
      anchors.centerIn: parent
      opacity: 0 // by default no button is displayed
      checkable: false
      iconSource: "emblem-favorite-symbolic"
      visible: true
      width: units.iconSizes.medium
      height: units.iconSizes.medium
      
      onClicked: {
        var newFavStatus = (plasmoid.configuration[root.distroShortText + root.isFavoritePostfix] == true) ? false : true;
        star.source = (newFavStatus == true) ? "./icons/favorite.png" : "./icons/non-favorite.png";
        plasmoid.configuration[root.distroShortText + root.isFavoritePostfix] = newFavStatus;
        getRank(root.distroShortText);
      } 
    }

    Image {
      id: star
      
      visible: true
      anchors.centerIn: parent
      width: units.iconSizes.smallMedium
      height: units.iconSizes.smallMedium
      fillMode: Image.PreserveAspectFit
      smooth: true
      source: (plasmoid.configuration[root.distroShortText + root.isFavoritePostfix] == true) ? "./icons/favorite.png" : "./icons/non-favorite.png" ;

      onStatusChanged: if (status == Image.Error) { source = ""; }
    }
  }
}
