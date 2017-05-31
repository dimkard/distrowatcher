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
import QtQuick.Controls 1.0 as QtControls
import QtQuick.Layouts 1.0 as QtLayouts

Item {
    id: generalPage
    width: childrenRect.width
    height: childrenRect.height
    
    property alias cfg_isvertical: isvertical.checked
    property alias cfg_popularity: popularity.checked

    QtControls.GroupBox {
        QtLayouts.Layout.fillWidth: true
        //title: i18n("Layout")
        flat: true

        QtLayouts.ColumnLayout {
            QtControls.CheckBox {
                id: isvertical

                text: i18n("Use vertical layout")
            }
            QtControls.CheckBox {
                id: popularity

                text: i18n("Show popularity of favorite distributions")
            }

        }
    }
}
