/*

    Copyright (C) 2015 Dimitris Kardarakos <dimkard@gmail.com>

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

  property alias latestNewsModel: newsModel
  property string status: newsModel.status
  property string source: "http://distrowatch.com/news/dw.xml"
  property int numOfItems: newsModel.count // count news items
  property int interval

  function reloadModel() {
    newsModel.reload();
  }

  XmlListModel {
    id: newsModel

    source: root.source
    namespaceDeclarations: "declare namespace rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'; declare default element namespace 'http://purl.org/rss/1.0/'; declare namespace dc='http://purl.org/dc/elements/1.1/'; declare namespace slash='http://purl.org/rss/1.0/modules/slash/'; declare namespace taxo='http://purl.org/rss/1.0/modules/taxonomy/'; declare namespace admin='http://webns.net/mvcb/'; declare namespace syn='http://purl.org/rss/1.0/modules/syndication/';"
    query: "/rdf:RDF/item"
    
    XmlRole { name: "title"; query: "title/string()" }
    XmlRole { name: "date"; query: "dc:date/string()" }
    XmlRole { name: "description"; query: "description/string()" }
    XmlRole { name: "link"; query: "link/string()" }
    XmlRole { name: "itemIndex"; query: "position()" }
  }

  Timer {
    id: newsTimer
    
    interval: root.interval*60000
    running: true
    repeat: true
    
    onTriggered: {
      newsModel.reload();
    }
  }
}
