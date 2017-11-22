/*
 * This file is part of Fluid.
 *
 * Copyright (C) 2017 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * $BEGIN_LICENSE:MPL2$
 *
 * This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/.
 *
 * $END_LICENSE$
 */

import QtQml 2.2
import QtQuick 2.3
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.0
import Fluid.Controls 1.0 as FluidControls
import Qt.labs.calendar 1.0

/*!
    \qmltype DatePickerDialog
    \inqmlmodule Fluid.Controls
    \ingroup fluidcontrols

    \brief Ready-made dialog with a picker to select a date.

    A dialog to pick a date.

    \code
    import QtQuick 2.0
    import Fluid.Controls 1.0 as FluidControls

    Item {
        width: 600
        height: 600

        FluidControls.DatePickerDialog {
            id: datepicker
            standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel
            standardButtonsContainer: Button {
                height: parent.height - 5
                anchors.verticalCenter: parent.verticalCenter
                text: "Now"
                Material.theme: Material.Light
                Material.foreground: Material.accent
                flat: true
                onClicked: {
                    datepicker.selectedDate = new Date()
                }
            }
            onAccepted: {
                console.log(date)
            }
        }
    }
    \endcode

    For more information you can read the
    \l{https://material.io/guidelines/components/pickers.html}{Material Design guidelines}.
*/
Dialog {
    id: dialog

    property alias orientation: picker.orientation
    property alias standardButtonsContainer: picker.standardButtonsContainer

    modal: true

    x: (parent.width - width) / 2
    y: (parent.height - height) / 2
    width: picker.width
    height: picker.height

    padding: 0

    header: null
    footer: null

    standardButtons: DialogButtonBox.Ok | DialogButtonBox.Cancel

    FluidControls.DatePicker {
        id: picker

        onAccepted: dialog.accepted()
        onRejected: dialog.reject()

        standardButtons: dialog.standardButtons
        standardButtonsContainer: Button {
            height: parent.height - 5
            anchors.verticalCenter: parent.verticalCenter
            text: qsTr("Now")
            flat: true
            onClicked: picker.selectedDate = new Date()
        }
    }
}
