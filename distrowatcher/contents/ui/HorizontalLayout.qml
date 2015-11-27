/*

    Copyright (C) 2015 Dimitris Kardarakos <dimkard@gmail.com>

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
import "./js/style.js" as Style

Row {
  id: tabButAndGroup

  property int refreshEvery
  property string currentTabName: mainTabGroup.currentTab.tabName
  property bool dataExists: (latestDistrosScreen.dataCount && latestDistrosScreen.dataCount > 0) ? true : false
  
  function reloadModels() { //addded for triggering reload after user has requested so
    latestDistrosScreen.reloadModel();
    latestPackagesScreen.reloadModel();
    newsScreen.reloadModel();
  }
  
  spacing: 15

  Item {
    id: tabBar
    
    width: Style.tabBarHeightProportion*parent.width 
    height: Style.tabBarWidthProportion*parent.height
    anchors.verticalCenter: parent.verticalCenter
    
    PlasmaComponents.TabBar { // select which screen shall be visible (Distros/Packages)
      id: tabBarVertical
      
      rotation: 90
      anchors {
        verticalCenter: parent.verticalCenter
        horizontalCenter: parent.horizontalCenter
      }
      width: parent.height
      height: parent.width
      
      PlasmaComponents.TabButton {
	id: distrosTabButton
	
	tab: latestDistrosScreen
	text:i18n("Distributions")
      }
      
      PlasmaComponents.TabButton {
	id: packagesTabButton
	
	tab: latestPackagesScreen
	text:i18n("Packages")
      }
      
      PlasmaComponents.TabButton {
	id: favoritesTabButton
	
	tab: favoriteDistrosScreen
	text:i18n("Favorites")
      }
      
      PlasmaComponents.TabButton {
	id: newsTabButton
      
	tab: newsScreen
	text:i18n("News")
      }
    }      
  }

  PlasmaComponents.TabGroup {   // contains the distros/packages screens
    id: mainTabGroup
    
    anchors.verticalCenter: tabButAndGroup.verticalCenter
    width: tabButAndGroup.width - Style.tabBarHeightProportion*tabButAndGroup.width - tabButAndGroup.spacing
    height:tabButAndGroup.height
    
    LatestDistrosScreen {
      id: latestDistrosScreen
      
      property string tabName: "Distributions"
    
      anchors.fill: parent
      anchors.topMargin: 5
      refreshEvery: tabButAndGroup.refreshEvery
    }
      
    LatestPackagesScreen {
      id: latestPackagesScreen
      
      property string tabName: "Packages"
      
      anchors.fill: parent
      anchors.topMargin: 5
      refreshEvery: tabButAndGroup.refreshEvery
    }

    SearchableFavorites {
      id: favoriteDistrosScreen
    
      property string tabName: "Favorites"
      anchors.fill: parent
      anchors.topMargin: 5
      visible: true
    }
    
    NewsScreen {
      id: newsScreen
      
      property string tabName: "News" 
      anchors.fill: parent
      anchors.topMargin: 5
      refreshEvery: tabButAndGroup.refreshEvery
    }      
  }
}
