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
  
  signal entered()
  signal exited()

  Image {
    id: backgroundImage

    source: "./images/newsDelegateBg.png"
    anchors.fill: parent
    fillMode: Image.Stretch
  }
  

 
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
      topMargin: 5
      bottomMargin: 5
    }
    font {
      bold: true
      pointSize: theme.defaultFont.pointSize + root.fontIncreaseFactor + 2
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
      pointSize: theme.defaultFont.pointSize + root.fontIncreaseFactor
    }
    color: theme.textColor
  }

  Item {
    id:description
    anchors {
      top: date.bottom
      bottom: root.bottom
      left: root.left
      right: root.right
      leftMargin: 10
      rightMargin: 10
      topMargin: 10
      bottomMargin: 35
    }   

    Flickable {
      id: flickArea

      anchors.fill: parent
      contentWidth: newsDesc.width
      contentHeight: newsDesc.height + completeStoryButton.height + newsAndMore.spacing
      flickableDirection: Flickable.VerticalFlick
      clip: true

      Column {
	id: newsAndMore
	
	spacing: 5
	  Text {
	  id: newsDesc
      
	  text: root.newsText
	  width: description.width
	  font {
	    bold: false
	    pointSize: theme.defaultFont.pointSize + root.fontIncreaseFactor
	  }
	  horizontalAlignment: Text.AlignJustify
	  wrapMode: Text.WordWrap
	  color: theme.textColor
	}
	
	PlasmaComponents.Button {
	  id: completeStoryButton

	  text: moreTextButton.text
	  
	  Text {
	      id: moreTextButton
	      
	      visible: false
	      text: i18n("More...")
	  }
	  width: moreTextButton.paintedWidth + 10 
	  height: moreTextButton.paintedHeight + 10 
	  onClicked: { Qt.openUrlExternally(root.linkText); }
	}
      }
    }
  }
}
