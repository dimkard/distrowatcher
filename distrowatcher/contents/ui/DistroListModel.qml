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
import "../code/logic.js" as Logic
import "./js/globals.js" as Params

Item {

  id: root

  property alias latestModel: latest
  property string status: latest.status
  property string source: "http://distrowatch.com/news/dwd.xml"
  //property string source: "./dwd.xml" //only for debug
  property int interval
  property int numOfItems: latest.count // count distro items
  property string isFavoritePostfix: Params.isFavoritePostfix
  property string latestPostfix: Params.latestPostfix
  property string enableNotifications: Params.enableNotifications  
  
  function reloadModel() {
    latest.reload()
    latest.checkForNewDistros()
  }
    
  function checkInList(latestDistro) { // find number occurences of a distro in the list
    var matches = 0;
    for (var i=0; i< latest.count;i++) {
      if (latest.get(i).distroShortName == latestDistro)
	matches++;  //to check multiples
    }
    return matches;
  }
  
  function getLastInList(latestDistro)  { //get the distro name of the last occurence of a distro
    var latestInList = "";
    for (var i=0; i < latest.count;i++) {
      if (latest.get(i).distroShortName == latestDistro)
	latestInList = latest.get(i).distro // so as to return the last found distro
    }
    return latestInList;
  }
  
  XmlListModel {
    id: latest

    function checkForNewDistros() { //checks new distro list, reads config and triggers notification if new favorite distro has been found
      for (var i=0; i< latest.count;i++) {
	var distroshort = latest.get(i).distroShortName;
	var latestdistro = latest.get(i).distro;
	var lastMatchInList = getLastInList(distroshort); //get the full distro name, in case that > 1 exist in the list
	//console.log(lastMatchInList); //debug only: show the last in list of latest distros
	//console.log("distroshort: "  + distroshort) ; //debug only: show distro name
// 	if (plasmoid.readConfig(root.enableNotifications) == true && plasmoid.readConfig(distroshort + root.isFavoritePostfix) == true && (plasmoid.readConfig(distroshort + root.latestPostfix) != lastMatchInList)) { 
// 	  //console.log(i18n("A new version of %1 is available!",distroshort)) ; //here goes notification
// 	  Logic.sendNotification(i18n("Distribution release"), i18n("A new version of %1 is available!",distroshort))
// 	  plasmoid.writeConfig(distroshort + root.latestPostfix, lastMatchInList);
// 	  //console.log(plasmoid.readConfig(distroshort + root.latestPostfix, latestdistro)); //debug only: show that config has been changed
// 	} //TODO: Recover as last part of porting to Plasma5
      }
    }
    
    source: root.source
    //query: "/rss/channel/item[position() <= 5]" --> in case you want to fetch a subset of records
    query: "/rss/channel/item"
    
    XmlRole { name: "title"; query: "title/string()" }
    XmlRole { name: "date"; query: "substring(title/string(),1,5)" }
    XmlRole { name: "distro"; query: "substring(title/string(),7,string-length(title/string())-5)" }
    XmlRole { name: "distroShortName" ; query: "substring-after(link/string(),'com\/')" }
    XmlRole { name: "link"; query: "link/string()" }
    XmlRole { name: "itemIndex"; query: "position()" } //--------item's position, for highlight ----
    
    
  } 
   
  Timer {
    id: distroTimer

    interval: root.interval*60000
    running: true
    repeat: true
    
    onTriggered: {
      latest.reload();
      latest.checkForNewDistros();
    }
  }
}
  