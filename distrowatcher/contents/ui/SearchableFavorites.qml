/*

    Copyright (C) 2013 Dimitris Kardarakos <dimkard@gmail.com>

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 3 of the License, or
  ` (at your option) any later version.

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


Item {
  id: favoriteDistrosScreen
  
  visible: true // visibility is controled by opacity
  
  Row {
    id: searchRow
    
    spacing: 5
    anchors {
      bottom: parent.bottom
      left: parent.left
    }
    height: theme.defaultFont.mSize.height*1.6
    width: parent.width
    
    Text {
      id: filterText
 
      height: parent.height
      verticalAlignment: Text.AlignVCenter
//      font.pointSize: theme.desktopFont.pointSize
      color: theme.textColor
      text: i18n("Filter:")
    } 
    
    PlasmaComponents.TextField { 
      id: searchItem
     
      placeholderText: i18n("Enter distribution name...")
      clearButtonShown: true
      height:parent.height
      width: (parent.width-filterText.width)-Style.scrollWidth
//      font.pointSize: theme.desktopFont.pointSize
      onTextChanged: {
	favoritesScreenItems.filterDistros(text); // when user changes text, filter favorites distro list
      }
    }
  }
  
  FavoriteDistrosScreen {
    id: favoritesScreenItems
    
    anchors {
//       top: searchItem.bottom
//       bottom: parent.bottom
//       left: parent.left      
      bottom: searchRow.top
      top: parent.top
      left: parent.left      
      
    }
    width: parent.width
  }
}