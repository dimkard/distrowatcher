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

Column {  
  id: root
  
  signal reloadClicked() //let parent know that user requested to reload
  spacing: 10

  Image {
    id: netowrkDisconnected

    anchors {
      horizontalCenter : root.horizontalCenter
    }
    fillMode : Image.PreserveAspectFit 
    source: "./images/task-attention-48.png"
  }
      
  PlasmaComponents.Label  {
    id: offlineText
    width: parent.width
    anchors {
      horizontalCenter : root.horizontalCenter
    }
    color: theme.textColor 
    font.pointSize: theme.defaultFont.pointSize
    horizontalAlignment: Text.AlignHCenter
    text: i18n("Network issue. \nPlease check your network connection. If you do not face any network problem, distrowatch.com may be unavailable or facing difficulties.");
    wrapMode: Text.Wrap
  }

  PlasmaComponents.Button {
    id: refreshButton
    anchors {
      horizontalCenter : root.horizontalCenter
    }
    checkable: false
    text: i18n("Reload")
    onClicked: root.reloadClicked()
  }
}