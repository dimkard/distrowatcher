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
import org.kde.plasma.extras 2.0 as PlasmaExtras 
import QtQuick.XmlListModel 2.0

Item {
  id: root

  property alias distroModel: distrolist
  property string status: distrolist.status
  property string source: "./distrolist.xml"
  property int interval
  property int numOfItems: distrolist.count // count distro items

  function queryModel(searchString) { //filter favorite distributions by name
    distrolist.query =  "/distrolist/item[contains(lower-case(child::distroname),lower-case('" + searchString + "'))]"
    distrolist.reload();
  }
  
  function reloadModel() {
    distrolist.reload();
  }

  XmlListModel {
    id: distrolist

    source: root.source
    // query: "/rss/channel/item[position() <= 5]" // in case you want to fetch a subset of records
    query: "/distrolist/item"
    XmlRole { name: "distroShortName" ; query: "substring-after(link/string(),'com\/')" }
    XmlRole { name: "link"; query: "link/string()" }
    XmlRole { id: distroname ; name: "distroname"; query: "distroname/string()" }
    XmlRole { name: "latestversion"; query: "latestversion/string()" }
    XmlRole { name: "itemIndex"; query: "position()" } //--------item's position, for highlight ----
  }
}
