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
// import "../code/logic.js" as Logic //TODO: Remove
import "./js/globals.js" as Params
import org.kde.plasma.core 2.0 as PlasmaCore
import QtQuick.XmlListModel 2.0
Item {

  id: root

  property alias latestModel: latest
  property string status: latest.status
//   property string source: "http://distrowatch.com/news/dwd.xml" //TODO: recover
  property string source: "./dwd.xml" //TODO: remove only for debug
  property int interval
  property int numOfItems: latest.count // count distro items
  property string isFavoritePostfix: Params.isFavoritePostfix
  property string latestPostfix: Params.latestPostfix
  
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
// 	if (plasmoid.readConfig(root.enableNotifications) == true && plasmoid.readConfig(distroshort + root.isFavoritePostfix) == true && (plasmoid.readConfig(distroshort + root.latestPostfix) != lastMatchInList)) { //TODO: Remove
// 	  Logic.sendNotification(i18n("Distribution release"), i18n("A new version of %1 is available!",distroshort)) //TODO: Remove
// 	  plasmoid.writeConfig(distroshort + root.latestPostfix, lastMatchInList); //TODO: Remove
// 	} //TODO: Remove
        
        if (plasmoid.configuration.enablenotifications == true && plasmoid.configuration[distroshort + root.isFavoritePostfix] == true && plasmoid.configuration[distroshort + root.latestPostfix] != lastMatchInList) {
	  plasmoid.configuration[distroshort + root.latestPostfix] = lastMatchInList;
//           Logic.sendNotification(i18n("Distribution release"), i18n("A new version of %1 is available!",distroshort)); //TODO: Remove
           notificationsSource.sendNotification("Distro Watcher", i18n("Distribution release"), i18n("A new version of %1 is available!",distroshort));
	} 
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
      //console.log("DW: latest.count" + latest.count); //TODO: Remove
    }
  }
  
  PlasmaCore.DataSource {
    id: notificationsSource

    engine: "notifications"
    connectedSources: "org.freedesktop.Notifications"
    interval: 0
    
    function sendNotification(appRealName, summary, body) {
        var service = notificationsSource.serviceForSource("notification");
        var op = service.operationDescription("createNotification");
        op["appName"] = appRealName;
        op["appIcon"] = "preferences-desktop-notification";
        op["summary"] = summary;
        op["body"] = body;
        op["timeout"] = 6000;
        service.startOperationCall(op);
    }
  }
}
  