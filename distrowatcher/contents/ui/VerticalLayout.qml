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

Column {
  id: tabButAndGroup
  
  property int refreshEvery
  property string currentTabName: mainTabGroup.currentTab.tabName
  property bool dataExists: (latestDistrosScreen.dataCount && latestDistrosScreen.dataCount > 0) ? true : false

  function reloadModels() { //added for triggering reload after user has requested so
    latestDistrosScreen.reloadModel();
    latestPackagesScreen.reloadModel();
    newsScreen.reloadModel();
  }
  
  spacing: 15
  
  PlasmaComponents.TabBar { // select which screen shall be visible (Distros/Packages)
    id: tabBar
    
    rotation: 0
    height: Style.tabBarHeightProportion*parent.height
    width: Style.tabBarWidthProportion*parent.width
    anchors.horizontalCenter: parent.horizontalCenter

    PlasmaComponents.TabButton {
      id: distrosTabButton
      
      tab: latestDistrosScreen
      text: i18n("Distributions")
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
      
  PlasmaComponents.TabGroup {
    id: mainTabGroup
    
    height: (1-Style.tabBarHeightProportion)*parent.height
    width:  parent.width
    
    LatestDistrosScreen {
      id: latestDistrosScreen
      
      property string tabName: "Distributions"
      anchors.fill: parent
      refreshEvery: tabButAndGroup.refreshEvery
    }
     
    LatestPackagesScreen {
      id: latestPackagesScreen
      
      property string tabName: "Packages"
      
      anchors.fill: parent
      refreshEvery: tabButAndGroup.refreshEvery
    }
    
    SearchableFavorites {
      id: favoriteDistrosScreen
    
      property string tabName: "Favorites"
      
      anchors.fill: parent
      visible: true
    }
    
    NewsScreen {
      id: newsScreen
      
      property string tabName: "News" 
      
      anchors {
        fill: parent
        topMargin: 5
      }
      refreshEvery: tabButAndGroup.refreshEvery
    }    
  }
}
