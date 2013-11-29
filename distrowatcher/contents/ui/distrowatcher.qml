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
  import org.kde.qtextracomponents 0.1 as Extras
  import "./js/style.js" as Style
  Rectangle {
    id: main
    property int refreshEvery : plasmoid.readConfig("refreshevery") //---- read refreshEvery from config file ----//  
    
    state : "hideFavorites" //be default, open in regular mode
    //Add event listener to read configuration, in case of change
    Component.onCompleted: {
      plasmoid.addEventListener('ConfigChanged', configChanged); 
    }

    function configChanged() {
      main.refreshEvery = plasmoid.readConfig("refreshevery");
      //console.log ("refreshevery: " + refreshEvery); //-------------- Only for debug ---------------//
      //------experimental-------//
      //main.curTabMode  = plasmoid.readConfig("tabmode"); --------------- experimental, icon in tab button  -----------------
      //console.log ("curTabMode : " + tabModes[curTabMode]); //--------------- experimental, icon in tab button  ----------------- //-------------- Only for debug ---------------//
      //---------experimental----------//
    }

    smooth: true
    width: Style.width	
    height: Style.height
    property int minimumWidth: Style.width //applicable only for kde plasmoids, enables set of minimums and dock to panel
    property int minimumHeight: Style.height //applicable only for kde plasmoids, enables set of minimums and dock to panel
    
    Image {
      source: ((tabBar.visible && mainTabGroup.currentTab == latestDistrosScreen) || state == "showFavorites") ?  "./images/distros_bg.png" : "./images/packages_bg.png" // change transparency level in case of packages, since dates fall into the white surface
      anchors.fill: parent
      fillMode: Image.Stretch
    }
    
    color: "transparent"
    // Current KDE theme
    PlasmaCore.Theme {
	id: theme
    }

    //Tab bar, so as to select which screen shall be visible (Distros/Packages)
    PlasmaComponents.TabBar {
      id: tabBar
      height: Style.tabBarHeightProportion*main.height
      width: Style.tabBarWidthProportion*parent.width
      anchors {
	top: main.top
	topMargin: main.height*Style.marginScreenPercent
	horizontalCenter: parent.horizontalCenter
      }
      visible: latestDistrosScreen.dataCount > 0

      PlasmaComponents.TabButton {
	tab: latestDistrosScreen
	text: i18n("Distributions")
	//---------experimental----------//
	//iconSource: (tabModes[curTabMode] == i18n("Text and Icons")) ? "distrowatcher" : undefined // Icon displayed in tab button  // ---------------  icons in tab button  -----------------
      }
      PlasmaComponents.TabButton {
	tab: latestPackagesScreen
	text:i18n("Packages")
	//---------experimental----------//
	//iconSource: (tabModes[curTabMode] == i18n("Text and Icons")) ? "distropackage" : undefined // Icon displayed in tab button // ---------------  icons in tab button  -----------------
      }
    }
    
    // Tab group, that contains the distros/packages screens.
    PlasmaComponents.TabGroup {
      id: mainTabGroup
      anchors {
	top: tabBar.visible ? tabBar.bottom : tabBar.top
	left: main.left
	right: main.right
	bottom: aboutText.top
	margins: main.height*Style.marginScreenPercent
      }
      visible: latestDistrosScreen.dataCount > 0	  

      //Latest Distros Screen
      LatestDistrosScreen {
	id: latestDistrosScreen
	anchors.fill: parent
	refreshEvery: main.refreshEvery
      }
	
      //Latest Packages Screen
      LatestPackagesScreen {
	id: latestPackagesScreen
	anchors.fill: parent
	refreshEvery: main.refreshEvery
	// onLoad: {
	// console.log("latestPackagesScreen.visible: " + latestPackagesScreen.visible);
	// console.log("latestDistrosScreen.visible: " + latestDistrosScreen.visible);
	//}
      } 
    }

    UnavailableScreen {
      id: offlineScreen
      anchors {
	margins: main.height*Style.marginScreenPercent
	horizontalCenter: parent.horizontalCenter
	fill: parent
      }
      visible: (latestDistrosScreen.dataCount <= 0 || latestDistrosScreen.dataCount == undefined) && main.state == "hideFavorites"
    }
      
    // Label informing where data come from
    Text {
      id: aboutText
      anchors {
	bottom: main.bottom
	horizontalCenter: main.horizontalCenter
      }
      verticalAlignment: Text.AlignBottom
      font.pointSize: theme.smallestFont.pointSize
      color: theme.textColor
      text: i18n("Data from distrowatch.com")
    }
    
    Extras.MouseEventListener { 
      id: favoritesIcon	
      visible: (latestDistrosScreen.visible || favoriteDistrosScreen.visible )
      width: theme.smallMediumIconSize
      height: theme.smallMediumIconSize
      hoverEnabled: true
      state: "hideFavoriteButton" //by default do not display button
      anchors {
	bottom: main.bottom
	right: main.right
      }
      onContainsMouseChanged: {
	if (containsMouse) {
	  state = "showFavoriteButton" 
	  //iconButton.opacity = 1; //display button
	  //noButtonIconItem.opacity =  0; // hide icon
	}
	else {
	  state = "hideFavoriteButton"
	  //iconButton.opacity = 0; // hide button
	  //noButtonIconItem.opacity =  1; //display icon
        }
      }
      states: [ //button states
	State {
	  name: "showFavoriteButton"
	  PropertyChanges {
	    target: iconButton
	    opacity: 1
	    }
	    PropertyChanges {
	    target: noButtonIconItem
	    opacity: 0
	    }
	},
	State {
	  name: "hideFavoriteButton"
          PropertyChanges {
	    target: iconButton
	    opacity: 0
	  }
	  PropertyChanges {
	    target: noButtonIconItem
	    opacity: 1
	  }
	}
    ]
    transitions: [
      Transition {
	NumberAnimation {
	  properties: "opacity"
	  easing.type: Easing.InOutQuad
	  duration: 300
	}
      }
    ]	
      PlasmaComponents.Button {
	id: iconButton
	anchors.fill: parent
	opacity: 0 // by default no button is displayed
	checkable: false
	iconSource: (main.state == "showFavorites") ? QIcon("draw-arrow-back") : QIcon("bookmarks")
	visible: (latestDistrosScreen.visible || favoriteDistrosScreen.opacity == 1)
	width: theme.smallMediumIconSize
	height: theme.smallMediumIconSize
	minimumWidth: theme.smallIconSize
	minimumHeight: theme.smallIconSize
	onClicked: {
	  //latestDistrosScreen.check_new_distros(); //added only for testing notifications
	  if (favoriteDistrosScreen.opacity == 0) {//open favorites
	    main.state = "showFavorites"
	  }
	  else {
	    main.state = "hideFavorites"
	  }
	}
      }

      Extras.QIconItem {
	id: noButtonIconItem
        icon: (main.state == "showFavorites") ? QIcon("draw-arrow-back") : QIcon("bookmarks")
	smooth: true
	visible: (latestDistrosScreen.visible || favoriteDistrosScreen.opacity == 1)  // be in bacground when distros or favorires are being displayed
	anchors.centerIn: parent
	width: theme.smallIconSize
	height: theme.smallIconSize
      }
    }

    Item {
      id: favoriteDistrosScreen
      //property alias distroFilter: searchItem.text
      visible: true //visibility is controled by opacity
      anchors {
	top: parent.top
	left: parent.left	
	right: parent.right
	bottom: aboutText.top
	margins: main.height*Style.marginScreenPercent
      }

      PlasmaComponents.TextArea { 
	id: searchItem
	verticalAlignment: TextEdit.AlignVCenter 
	//wrapMode: TextEdit.NoWrap
	interactive: false
	anchors{
	  top: parent.top
	  left: parent.left
	}
	height: theme.defaultFont.mSize.height*1.5
	width: parent.width/2
	placeholderText: i18n("Enter distribution name...")
	onTextChanged: {
	  favoritesScreenItems.filter_distros(text);
	}
	  // when user changes text, filter favorites distro list
      }
      FavoriteDistrosScreen {
	id: favoritesScreenItems
	anchors {
	  top: searchItem.bottom
	  bottom: parent.bottom
	  left: parent.left
	//  bottomMargin: 5
	}
	width: parent.width
	//height: (parent.height - searchItem.height) - anchors.bottomMargin//-  2*(Style.marginPercent)*(theme.defaultFont.mSize.height)*1.5
	//2*(Style.marginPercent)*(theme.defaultFont.mSize.height)*1.5
	
      }
    }
    PlasmaCore.ToolTip {
      id: favoriteTooltip
      target: favoritesIcon
      mainText: (iconButton.checked) ? i18n("Return to latest distributions") : i18n("Select your favorite distributions")
    }
    states: [ // favorites states
      State {
	name: "showFavorites"
	PropertyChanges {
	  target: mainTabGroup
	  opacity: 0
	}
	PropertyChanges {
	  target: tabBar
	  opacity: 0
	}
	PropertyChanges {
	  target: favoriteDistrosScreen 
	  opacity: 1
	}
      },
      State {
	name: "hideFavorites"
	PropertyChanges {
	  target: mainTabGroup
	  opacity: 1
	}
	PropertyChanges {
	  target: tabBar
	  opacity: 1
	}
	PropertyChanges {
	  target: favoriteDistrosScreen 
	  opacity: 0
	}	
      }
    ]
    
    transitions: [ //trnasition between show favorites
      Transition {
	NumberAnimation {
	  properties: "opacity"
	  easing.type: Easing.InOutQuad
	  duration: 500
	}
      }
    ]
    
  }
  