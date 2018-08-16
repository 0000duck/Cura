import QtQuick 2.2
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4


import UM 1.3 as UM


Item
{
    property var printJob: null

    function getPrettyTime(time)
    {
        return OutputDevice.formatDuration(time)
    }

    Rectangle
    {
        id: background
        anchors.fill: parent

        Item
        {
            // Content on the left of the infobox
            anchors
            {
                top: parent.top
                bottom: parent.bottom
                left: parent.left
                right: parent.horizontalCenter
                margins:  UM.Theme.getSize("default_margin").width
            }

            Label
            {
                id: printJobName
                text: printJob.name
                font: UM.Theme.getFont("default_bold")
            }

            Label
            {
                id: ownerName
                anchors.top: printJobName.bottom
                text: printJob.owner
            }

            Image
            {
                source: printJob.preview_image_url
                anchors.top: ownerName.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: totalTimeLabel.top
                width: height
            }

            Label
            {
                id: totalTimeLabel

                anchors.bottom: parent.bottom
                anchors.right: parent.right

                text: printJob != null ? getPrettyTime(printJob.timeTotal) : ""
                elide: Text.ElideRight
            }
        }

        Item
        {
            // Content on the right side of the infobox.
            anchors
            {
                top: parent.top
                bottom: parent.bottom
                left: parent.horizontalCenter
                right: parent.right
                margins:  UM.Theme.getSize("default_margin").width
            }

            Label
            {
                id: targetPrinterLabel
                elide: Text.ElideRight
                font: UM.Theme.getFont("default_bold")
                text:
                {
                    if(printJob.assignedPrinter == null)
                    {
                        return "Waiting for: first available"
                    }
                    else
                    {
                        return "Waiting for: " + printJob.assignedPrinter.name
                    }

                }

                anchors
                {
                    left: parent.left
                    right: contextButton.left
                    rightMargin: UM.Theme.getSize("default_margin").width
                }
            }


            function switchPopupState()
            {
                popup.visible ? popup.close() : popup.open()
            }

            Button
            {
                id: contextButton
                text: "..."
                anchors
                {
                    right: parent.right
                    top: parent.top
                }
                onClicked: parent.switchPopupState()
            }


            Popup
            {
                // TODO Change once updating to Qt5.10 - The 'opened' property is in 5.10 but the behavior is now implemented with the visible property
                id: popup
                clip: true
                closePolicy: Popup.CloseOnPressOutsideParent
                x: parent.width - width
                y: contextButton.height
                //y: configurationSelector.height - UM.Theme.getSize("default_lining").height
                //x: configurationSelector.width - width
                width: 200
                height: childrenRect.height
                visible: false
                padding: UM.Theme.getSize("default_lining").width
                transformOrigin: Popup.Top
                contentItem: Item
                {
                    width: popup.width - 2 * popup.padding
                    height: childrenRect.height
                    Button
                    {
                        text: "Send to top"
                        onClicked: OutputDevice.sendJobToTop(printJob.key)
                        width: parent.width
                    }
                }

                background: Rectangle
                {
                    color: UM.Theme.getColor("setting_control")
                    border.color: UM.Theme.getColor("setting_control_border")
                }

                exit: Transition
                {
                    // This applies a default NumberAnimation to any changes a state change makes to x or y properties
                    NumberAnimation { property: "visible"; duration: 75; }
                }
                enter: Transition
                {
                    // This applies a default NumberAnimation to any changes a state change makes to x or y properties
                    NumberAnimation { property: "visible"; duration: 75; }
                }

                onClosed: visible = false
                onOpened: visible = true
            }


            // PrintCore && Material config
            Row
            {
                id: extruderInfo
                anchors.bottom: parent.bottom

                anchors
                {
                    left: parent.left
                    right: parent.right
                }
                height: childrenRect.height

                spacing: UM.Theme.getSize("default_margin").width

                PrintCoreConfiguration
                {
                    id: leftExtruderInfo
                    width: Math.round(parent.width  / 2)
                    printCoreConfiguration: printJob.configuration.extruderConfigurations[0]
                }

                PrintCoreConfiguration
                {
                    id: rightExtruderInfo
                    width: Math.round(parent.width / 2)
                    printCoreConfiguration: printJob.configuration.extruderConfigurations[1]
                }
            }

        }

        Rectangle
        {
            color: "grey"
            width: 1

            anchors.top: parent.top
            anchors.bottom: parent.bottom
            anchors.margins: UM.Theme.getSize("default_margin").height
            anchors.horizontalCenter: parent.horizontalCenter

        }

    }
}