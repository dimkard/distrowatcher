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

Column {
  
  id: root
    // Current KDE theme
  PlasmaCore.Theme {
      id: theme
  }
  Image {
    id: netowrkDisconnected
    anchors {
      horizontalCenter : root.horizontalCenter
      topMargin : root.height*Style.marginPercent // icon distance from row edges
      left : root.left
    }
    fillMode : Image.PreserveAspectFit 
    source: "./images/task-attention-48.png"
  }
      
  Text {
    id: offlineText
    anchors {
      horizontalCenter : root.horizontalCenter
      topMargin : root.height*Style.marginPercent // icon distance from row edges
      left : root.left
    }
    color: theme.textColor 
    font.pointSize: theme.desktopFont.pointSize
    horizontalAlignment: Text.AlignHCenter
    text: i18n("Network issue. \nPlease check your network connection. If you do not face any network problem, distrowatch.com may be unavailable or facing difficulties.");
    wrapMode: Text.Wrap
  }
} 
