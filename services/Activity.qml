import qs.components
import qs.utils
import qs.services  // <--- Import your new Service
import qs.widgets 
import Quickshell
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    
    implicitWidth: layout.implicitWidth > 800 ? layout.implicitWidth : 840
    implicitHeight: layout.implicitHeight

    ColumnLayout {
        id: layout
        anchors.fill: parent
        anchors.margins: Appearance.padding.large
        spacing: Appearance.spacing.large

        // --- HEADER CARD ---
        StyledRect {
            Layout.fillWidth: true
            implicitHeight: 100
            radius: Appearance.rounding.large
            color: Colours.palette.m3surfaceContainer

            RowLayout {
                anchors.centerIn: parent
                spacing: Appearance.spacing.large

                MaterialIcon {
                    text: Icons.activity
                    font.pointSize: 42
                    color: Colours.palette.m3primary
                }

                ColumnLayout {
                    spacing: 0
                    StyledText {
                        text: "Today's Activity"
                        font.pointSize: Appearance.font.size.small
                        color: Colours.palette.m3onSurfaceVariant
                    }
                    StyledText {
                        // BINDING TO THE SERVICE HERE:
                        text: Activity.totalTime 
                        font.pointSize: 28
                        font.weight: 700
                        color: Colours.palette.m3onSurface
                    }
                }
            }
        }

        // --- APP LIST CARD ---
        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitHeight: 400
            radius: Appearance.rounding.large
            color: Colours.palette.m3surfaceContainer
            clip: true

            ListView {
                anchors.fill: parent
                anchors.margins: Appearance.padding.large
                spacing: Appearance.spacing.normal
                
                // BINDING TO THE SERVICE HERE:
                model: Activity.apps 
                clip: true

                delegate: RowLayout {
                    width: ListView.view.width
                    height: 45
                    spacing: Appearance.spacing.normal

                    IconImage {
                        source: modelData.name
                        implicitWidth: 32
                        implicitHeight: 32
                        Layout.alignment: Qt.AlignVCenter
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 6

                        RowLayout {
                            Layout.fillWidth: true
                            StyledText {
                                text: modelData.name
                                font.capitalization: Font.Capitalize
                                font.weight: 600
                                color: Colours.palette.m3onSurface
                            }
                            Item { Layout.fillWidth: true }
                            StyledText {
                                text: modelData.pretty_time
                                color: Colours.palette.m3secondary
                                font.weight: 500
                            }
                        }

                        Rectangle {
                            Layout.fillWidth: true
                            height: 6
                            radius: 3
                            color: Colours.tPalette.m3surfaceContainerHigh

                            Rectangle {
                                width: parent.width * modelData.percent
                                height: parent.height
                                radius: 3
                                color: Colours.palette.m3primary
                                Behavior on width { 
                                    NumberAnimation { duration: 500; easing.type: Easing.OutCubic } 
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
