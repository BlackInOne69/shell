import qs.components
import qs.utils
import qs.services
import qs.config
import Quickshell.Widgets
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
        StyledRect {
            Layout.fillWidth: true
            implicitHeight: 100
            radius: Appearance.rounding.large * 2
            color: Colours.tPalette.m3surfaceContainer

            MouseArea {
                anchors.fill: parent
                onWheel: (wheel) => {
                    if (wheel.angleDelta.y < 0) {
                        ActivityStats.changeDay(-1) 
                    } else if (wheel.angleDelta.y > 0) {
                        ActivityStats.changeDay(1)
                    }
                }
            }

            Item {
                anchors.fill: parent

                RowLayout {
                    id: controls
                    anchors.right: parent.horizontalCenter
                    anchors.rightMargin: Appearance.spacing.large / 2
                    anchors.verticalCenter: parent.verticalCenter
                    spacing: Appearance.spacing.large

                    MaterialIcon {
                        text: "chevron_left"
                        font.pointSize: 32
                        color: ActivityStats.canGoBack ? Colours.palette.m3onSurfaceVariant : Colours.palette.m3outline
                        enabled: ActivityStats.canGoBack
                        
                        MouseArea {
                             anchors.fill: parent
                             onClicked: ActivityStats.changeDay(-1)
                        }
                    }

                    MaterialIcon {
                        text: Icons.activity
                        font.pointSize: 42
                        color: Colours.palette.m3primary
                    }
                    
                    MaterialIcon {
                        text: "chevron_right"
                        font.pointSize: 32
                        color: ActivityStats.canGoForward ? Colours.palette.m3onSurfaceVariant : Colours.palette.m3outline
                        enabled: ActivityStats.canGoForward
                        
                        MouseArea {
                             anchors.fill: parent
                             onClicked: ActivityStats.changeDay(1)
                        }
                    }
                }

                ColumnLayout {
                    anchors.left: parent.horizontalCenter
                    anchors.leftMargin: Appearance.spacing.large / 2
                    anchors.verticalCenter: controls.verticalCenter
                    spacing: 0

                    StyledText {
                        text: ActivityStats.isToday(ActivityStats.selectedDate) ? "Today's Activity" : Qt.formatDateTime(ActivityStats.getDateObj(ActivityStats.selectedDate), "dddd, MMMM d")
                        font.pointSize: Appearance.font.size.small
                        color: Colours.palette.m3onSurfaceVariant
                    }
                    StyledText {
                        text: ActivityStats.totalTime 
                        font.pointSize: 28
                        font.weight: 700
                        color: Colours.palette.m3onSurface
                    }
                }
            }
        }

        StyledRect {
            Layout.fillWidth: true
            Layout.fillHeight: true
            implicitHeight: 400
            radius: Appearance.rounding.large
            color: Colours.tPalette.m3surfaceContainer
            clip: true

            ListView {
                id: appList
                anchors.fill: parent
                anchors.margins: Appearance.padding.large
                spacing: Appearance.spacing.normal
                
                model: ListModel { id: appModel }
                
                function updateModel() {
                    var source = ActivityStats.apps;
                    
                    for (var i = 0; i < source.length; i++) {
                        var item = source[i];
                        if (i < appModel.count) {
                            appModel.set(i, item);
                        } else {
                            appModel.append(item);
                        }
                    }
                    
                    if (appModel.count > source.length) {
                        appModel.remove(source.length, appModel.count - source.length);
                    }
                }
                
                Connections {
                    target: ActivityStats
                    function onAppsChanged() {
                        appList.updateModel();
                    }
                }
                
                Component.onCompleted: appList.updateModel()

                Connections {
                    target: ActivityStats
                    function onSelectedDateChanged() {
                         appList.positionViewAtBeginning()
                    }
                }

                delegate: RowLayout {
                    width: ListView.view.width
                    height: 45
                    spacing: Appearance.spacing.normal

                    IconImage {
                        source: Icons.getAppIcon(name)
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
                                text: name
                                font.capitalization: Font.Capitalize
                                font.weight: 600
                                color: Colours.palette.m3onSurface
                            }
                            Item { Layout.fillWidth: true }
                            StyledText {
                                text: pretty_time
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
                                width: parent.width * percent
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