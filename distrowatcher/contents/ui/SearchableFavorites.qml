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

import QtQuick 2.0
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.extras 2.0 as PlasmaExtras 
import "./js/style.js" as Style


Item {
  id: searchableFavorites
  
  visible: true // visibility is controled by opacity

  FavoriteDistrosScreen {
    id: favoritesScreenItems
    
    anchors {
      bottomMargin: 5
      bottom: searchRow.top
      top: searchableFavorites.top
      left: searchableFavorites.left      
      
    }
    width: parent.width
  }
  
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
      onTextChanged: {
	favoritesScreenItems.filterDistros(text); // when user changes text, filter favorites distro list
      }
    }
  }
}