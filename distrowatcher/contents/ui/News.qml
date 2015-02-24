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
//TODO: Currently, it is just a copy of latest newss. Implementation needed.

import QtQuick 1.1
import org.kde.plasma.components 0.1 as PlasmaComponents
import org.kde.plasma.core 0.1 as PlasmaCore
import org.kde.qtextracomponents 0.1 as QtExtras
import "./js/style.js" as Style
import "../code/logic.js" as Logic

Item {
  id: root
  
  property string titleText
  property string linkText
  property date dateText
  property string newsText
  property int itemIndex 
  property int fontIncreaseFactor
  property int fontSize: ( theme.desktopFont.pointSize + fontIncreaseFactor <= 1 ? 1 : theme.desktopFont.pointSize + fontIncreaseFactor)
  
  signal entered()
  signal exited()

  Image {
    id: backgroundImage

    source: "./images/pkgDelegateBg.png" // change transparency level in case of newss, since dates fall into the white surface
    anchors.fill: parent
    fillMode: Image.Stretch
  }
  
  PlasmaCore.Theme {
    id: theme
  }
 
//   MouseArea {
//     id: newsRecordMouseArea
//     
//     anchors.fill: parent
//     hoverEnabled: true
//     
// //    onClicked: plasmoid.openUrl(root.linkText);
//     onEntered: root.entered();
//     onExited: root.exited();
//   }

  Text {
    id: title
    
    text: root.titleText
    width: parent.width
    wrapMode: Text.WordWrap
    horizontalAlignment: Text.AlignLeft
    anchors {
      top: root.top
      left: root.left
      right: root.right
      leftMargin: 10
      rightMargin: 10
      topMargin: 10
      bottomMargin: 5
    }
    font {
      bold: true
      pointSize: root.fontSize + 2
    }
    style: Text.Raised
    color: theme.textColor
  }
  
  Text {
    id: date
    
    text: Qt.formatDateTime(root.dateText, "dd/MM/yyyy hh:mm")
    width: parent.width
    wrapMode: Text.WordWrap
    horizontalAlignment: Text.AlignJustify
    anchors {
      top: title.bottom
      left: root.left
      right: root.right
      leftMargin: 10
      rightMargin: 10
      topMargin: 5
      bottomMargin: 5
    }
    style: Text.Raised
    font {
      bold: true
      pointSize: root.fontSize
    }
    color: theme.textColor
  }

  Item {
    id:description
    anchors {
      top: date.bottom
      bottom: completeStory.top
      left: root.left
      right: root.right
      leftMargin: 10
      rightMargin: 10
      topMargin: 10
      bottomMargin: 5
    }   

    Flickable {
      id: flickArea
      anchors.fill: parent
      contentWidth: newsDesc.width; contentHeight: newsDesc.height
      flickableDirection: Flickable.VerticalFlick
      
      clip: true

      Text {
	id: newsDesc
    
	text: root.newsText
	width: description.width
	font {
	  bold: false
	  pointSize: root.fontSize
	}
	horizontalAlignment: Text.AlignJustify
	wrapMode: Text.WordWrap
	color: theme.textColor
      }
    }
  }
  
//   MouseArea {
//     id: completeStory
//     
//     anchors {
// 	top: description.bottom
// 	
// 	//bottom: root.bottom
// 	left: root.left
// 	margins: 15
//     }   
//     width: completeStoryText.paintedWidth
//     height: completeStoryText.paintedHeight
//     onClicked: { plasmoid.openUrl(root.linkText); }
//     hoverEnabled: true
//     
//     Text {
//       id: completeStoryText
//       anchors.fill: parent
//       text: i18n("Complete story...")
//   
//       font {
// 	bold: false
// 	pointSize: root.fontSize
// 	underline: true
//       }
//       wrapMode: Text.WordWrap
//       color: theme.textColor
//     }
//   }

    PlasmaComponents.Button {
      id: completeStory

      text: i18n("More...")
      anchors {
	  bottom: root.bottom
	  left: root.left
	  margins: 15
      }   
      width: 80
      height: 30
      //TODO: Fix height, add tooltip
      onClicked: { plasmoid.openUrl(root.linkText); }
    }

}
