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

import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import "./js/style.js" as Style

Item {
  id: root

  property string titleText
  property string linkText
  property string dateText
  property string distroText
  property string distroShortText
  property int itemIndex
  
  signal entered() //inform parent regarding interaction
  signal exited() //inform parent regarding interaction
  signal positionChanged() //inform parent regarding interaction
  
  Image {
    id: backgroundImage

    source: "./images/distroDelegateBg.png" // change transparency level in case of packages, since dates fall into the white surface
    anchors.fill: parent
    fillMode: Image.Stretch
  }
  

  MouseArea {
    id: distroRecordMouseArea
  
    anchors.fill: parent
    hoverEnabled: true
    
    onClicked: { 
      //debug only // console.log("click" + root.linkText); 
      //plasmoid.openUrl(root.linkText); //not working in Plasma5
      Qt.openUrlExternally(root.linkText);
    }
    onEntered: root.entered();
    onExited: root.exited();
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
    source: "http://distrowatch.com/images/yvzhuwbpy/" +  distroShortText + ".png"
    
    onStatusChanged: if (status == Image.Error) {
			  // we set the icon to an empty image if we failed to find one
			  source = ""
    }
  }
    
  Text {
    id: date
    
    anchors {
      top: icon.top
      left: icon.right	
      verticalCenter : parent.verticalCenter
    }
    verticalAlignment : Text.AlignVCenter
    text: root.dateText
    font {
      bold: true
      pointSize: theme.desktopFont.pointSize
    }
    horizontalAlignment: Text.AlignLeft
    style: Text.Raised  //fix white-white issue
    styleColor: "gray" //fix white-white issue
    wrapMode: "WordWrap" 
    color: theme.textColor
  }    

  Text {
    id: distro

    anchors {
      top: date.top
      left: date.right
      leftMargin: parent.width*Style.marginInsideRowPercent
      verticalCenter : parent.verticalCenter
    }
    verticalAlignment : Text.AlignVCenter
    text: root.distroText
    font {
      bold: false
      pointSize: theme.desktopFont.pointSize
    }
    horizontalAlignment: Text.AlignLeft
    wrapMode: "WordWrap" 
    color: theme.textColor    
  }  
}
