 /****************************************************************************
 * This file is part of Fluid.
 *
 * Copyright (c) 2012 Pier Luigi Fiorini
 * Copyright (c) 2011 Daker Fernandes Pinheiro
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *    Daker Fernandes Pinheiro <dakerfp@gmail.com>
 *
 * $BEGIN_LICENSE:LGPL-ONLY$
 *
 * This file may be used under the terms of the GNU Lesser General
 * Public License as published by the Free Software Foundation and
 * appearing in the file LICENSE.LGPL included in the packaging of
 * this file, either version 2.1 of the License, or (at your option) any
 * later version.  Please review the following information to ensure the
 * GNU Lesser General Public License version 2.1 requirements
 * will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
 *
 * If you have questions regarding the use of this file, please contact
 * us via http://www.maui-project.org/.
 *
 * $END_LICENSE$
 ***************************************************************************/

/**Documented API
Inherits:
        Item

Imports:
        QtQuick 2.0
        FluidCore

Description:
        Used to highlight an item of a list. to be used only as the "highlight" property of the ListView and GridView primitive QML components (or their derivates)
        Provides built-in animation of Behavior on opacity Easing.OutQuad for a duration of 250. (TODO, make optional? e.g. animate: false)

Properties:
        bool hover:
        true if the user is hovering over the component

        bool pressed:
        true if the mouse button is pressed over the component.
**/

import QtQuick 2.0
import FluidCore 1.0 as FluidCore

Item {
    id: highlight

    property bool hover: false
    property bool pressed: false

    FluidCore.FrameSvgItem {
        id: background
        imagePath: "widgets/viewitem"
        prefix: {
            if (pressed)
                return hover ? "selected+hover" : "selected";

            if (hover)
                return "hover";

            return "normal";
        }

        Behavior on opacity {
            NumberAnimation {
                duration: 250
                easing.type: Easing.OutQuad
            }
        }

        anchors {
            fill: parent
        //FIXME: breaks listviews and highlight item
        //    topMargin: -background.margins.top
        //    leftMargin: -background.margins.left
        //    bottomMargin: -background.margins.bottom
        //    rightMargin: -background.margins.right
        }
    }
}