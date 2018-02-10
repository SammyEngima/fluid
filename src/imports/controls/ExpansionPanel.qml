/*
 * This file is part of Fluid.
 *
 * Copyright (C) 2018 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 * Copyright (C) 2018 Michael Spencer <sonrisesoftware@gmail.com>
 *
 * $BEGIN_LICENSE:MPL2$
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * $END_LICENSE$
 */

import QtQuick 2.0
import QtQuick.Controls 1.4
import Fluid.Controls 1.0 as FluidControls

/*!
    \qmltype ExpansionPanel
    \inqmlmodule Fluid.Controls
    \ingroup fluidcontrols

    \brief An expansion panel is a lightweight container that may either stand alone or be connected to a larger surface, such as a card.

    Expansion panels are best used for lightweight editing of an element, such as selecting a value for a setting.

    Expansion panels may be displayed in a sequence to form creation flows.

    The state of the panel could be controlled by the \l checked property.

    This component support \l ExlusiveGroup.

    For more information you can read the
    \l{https://material.io/guidelines/components/expansion-panels.html}{Material Design guidelines}.
*/
Item {
    id: root

    height: checked ? summaryRow.height + spacing*4 + contentLoader.height : summaryRow.height

    /*!
        \qmlproperty int paddingLeft

        Left padding.
    */
    property int paddingLeft : 24

    /*!
        \qmlproperty int paddingRight

        Right padding.
    */
    property int paddingRight : paddingLeft

    /*!
        \qmlproperty int paddingTop

        Top padding.
    */
    property int paddingTop : spacing

    /*!
        \qmlproperty int paddingBottom

        Bottom padding.
    */
    property int paddingBottom : paddingTop

    /*!
        \qmlproperty int spacing

        Spacing between internal elements.
    */
    property int spacing : 16

    /*!
        \qmlproperty Component summaryDelegate

        Delegate of the summary row. By default it contains two labels, one for the \l summaryTitle, one for the \l summarySubtitle
    */
    property alias summaryDelegate : summaryLoader.sourceComponent

    /*!
        \qmlproperty Component expandedPanelDelegate

        Expanded panel content's delegate. By default is null
    */
    property alias expandedPanelDelegate : contentLoader.sourceComponent

    /*!
        \qmlproperty Component expandedPanelDelegate

        Delegate used to draw the background of the summary row
    */
    property alias backgroundDelegate : backgroundLoader.sourceComponent

    /*!
        \qmlproperty string summaryTitle

        Title of the panel, used only if the \l summaryDelegate is the default one
    */
    property string summaryTitle

    /*!
        \qmlproperty string summarySubtitle

        Subtitle of the panel, used only if the \l summaryDelegate is the default one
    */
    property string summarySubtitle

    /*!
        \qmlproperty bool checked

        This property is true if the control is expanded.
    */
    property bool checked : false

    /*!
        \qmlproperty ExclusiveGroup exclusiveGroup

        This property stores the \l ExclusiveGroup that the control belongs to.
    */
    property ExclusiveGroup exclusiveGroup : null

    onExclusiveGroupChanged: if (exclusiveGroup) exclusiveGroup.bindCheckable(root)

    /*!
        \internal
    */
    property int animationDuration : 100

    Card {
        id: card

        anchors.fill         : parent
        anchors.topMargin    : root.checked ? root.spacing : 0
        anchors.bottomMargin : anchors.topMargin
        anchors.leftMargin   : 10
        anchors.rightMargin  : 10
    }

    MouseArea {
        id: mouseArea

        width       : parent.width
        height      : summaryRow.height

        anchors.top : summaryRow.top

        onClicked   : root.checked = !root.checked
    }

    Loader {
        id: backgroundLoader

        width        : card.width
        height       : summaryRow.height

        anchors.top  : summaryRow.top
        anchors.left : card.left

        sourceComponent: Rectangle {
            color : mouseArea.pressed && !root.checked ? "#C8C8C8" : "white"

            Behavior on color { ColorAnimation { duration: root.animationDuration } }
        }
    }

    Row {
        id: summaryRow

        anchors.top         : parent.top
        anchors.topMargin   : root.checked ? spacing : 0

        height              : root.checked ? 64 : 48

        spacing             : root.spacing

        anchors.left        : parent.left
        anchors.leftMargin  : root.paddingLeft
        anchors.right       : parent.right
        anchors.rightMargin : root.paddingRight

        Behavior on height { NumberAnimation { duration: root.animationDuration } }

        Loader {
            id: summaryLoader

            width  : parent.width - expandedIndicatorIcon.width - parent.spacing
            height : parent.height

            sourceComponent: Row {

                spacing: summaryRow.spacing

                BodyLabel {
                    id: titleLabel

                    width             : parent.width * 0.3
                    height            : parent.height

                    verticalAlignment : "AlignVCenter"

                    opacity           : 0.87

                    text              : root.summaryTitle
                }

                BodyLabel {
                    width             : parent.width - parent.spacing - titleLabel.width
                    height            : parent.height

                    verticalAlignment : "AlignVCenter"

                    opacity           : 0.54

                    text              : root.summarySubtitle
                }
            }
        }

        Icon {
            id: expandedIndicatorIcon

            anchors.top       : parent.top
            anchors.topMargin : 12

            opacity           : 0.54

            name              : FluidControls.Utils.iconUrl(root.checked ? "hardware/keyboard_arrow_up" : "hardware/keyboard_arrow_down")
        }
    }

    Item {
        height              : visible ? contentLoader.height : 0

        anchors.top         : summaryRow.bottom
        anchors.topMargin   : root.checked ? root.paddingTop : 0
        anchors.left        : parent.left
        anchors.leftMargin  : root.paddingLeft
        anchors.right       : parent.right
        anchors.rightMargin : root.paddingRight

        visible             : root.checked
        clip                : true

        Behavior on height { NumberAnimation { duration: root.animationDuration } }

        Loader {
            id: contentLoader

            width : parent.width
        }
    }
}
