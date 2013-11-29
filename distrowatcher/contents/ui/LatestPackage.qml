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
import "./js/style.js" as Style

Item {
  id: root
  property string titleText: i18n("Title")
  property string linkText: i18n("Link")
  property string dateText: i18n("Date")
  property string packageText: i18n("Package")
  property int itemIndex 
  
  signal entered() //inform parent regarding interaction
  signal exited() //inform parent regarding interaction
  signal positionChanged() //inform parent regarding interaction
  // Current KDE theme
  PlasmaCore.Theme {
      id: theme
  }
 
  MouseArea {
      id: packageRecordMouseArea
      anchors.fill: parent
      onClicked: plasmoid.openUrl(root.linkText);
      onEntered: root.entered();
      onExited: root.exited();
      onPositionChanged: root.positionChanged();
      hoverEnabled: true
  }
    
    Text {
      id: date
      text: root.dateText
      style: Text.Raised  //fix white-white issue
      styleColor: "gray" //fix white-white issue
      anchors {
	leftMargin: parent.width*Style.marginInsideRowPercent
	top: root.top
	left: root.left
	verticalCenter : parent.verticalCenter
      }
      verticalAlignment : Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft
      font.bold: true
      font.pointSize: theme.desktopFont.pointSize
      wrapMode: "WordWrap"
      color: theme.textColor
  }    


  Text {
      id: latest_package
      text: root.packageText       
      anchors {
	leftMargin: parent.width*Style.marginInsideRowPercent
	top: date.top
	left: date.right
	verticalCenter : parent.verticalCenter
      }
      verticalAlignment : Text.AlignVCenter
      horizontalAlignment: Text.AlignLeft        
      font.bold: false
      font.pointSize: theme.desktopFont.pointSize
      wrapMode: "WordWrap"
      color: theme.textColor
  }  
}
