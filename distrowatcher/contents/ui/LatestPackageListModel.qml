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

Item {
    id: root
    property alias latestPackageModel: latest_package
    property string status: latest_package.status
    property string source: "http://distrowatch.com/news/dwp.xml"
    //property string source: "./dwp.xml" //Only for test
    property int numOfItems: latest_package.count // count package items
    property int interval
    function reload_model() {
      latest_package.reload();
    }
    
    XmlListModel {
        id: latest_package
        source: root.source
        //query: "/rss/channel/item[position() <= 5]" --> in case you want to fetch a subset of records
        query: "/rss/channel/item"
	XmlRole { name: "title"; query: "title/string()" }
        XmlRole { name: "date"; query: "substring(title/string(),1,5)" }
        XmlRole { name: "latest_package"; query: "substring(title/string(),7,string-length(title/string())-5)" }
        XmlRole { name: "link"; query: "link/string()" }
        XmlRole { name: "item_index"; query: "position()" } //--------item's position, for highlight ----
    }
    
    Timer {
        interval: root.interval*60000
        running: true
        repeat: true
        onTriggered: {
	  latest_package.reload();
        }
    }
}
