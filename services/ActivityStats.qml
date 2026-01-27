pragma Singleton

import Quickshell
import Quickshell.Io
import QtQuick

Singleton {
    id: root

    readonly property string cachePath: "/home/blackinone/.cache/caelestia_stats.json"

    FileView {
        id: statsFile
        path: root.cachePath
        watchChanges: true
    }

    property var fullData: null

    Connections {
        target: statsFile
        function onTextChanged() {
            var content = statsFile.text();
            if (content === "") return;
            try {
                var obj = JSON.parse(content);
                root.fullData = obj;
                console.log("ActivityStats: Parsed success. Total time: " + obj.total_time);
            } catch (e) {
            }
        }
    }

    Component.onCompleted: {
        var content = statsFile.text();
        if (content !== "") {
            try {
                root.fullData = JSON.parse(content);
            } catch (e) {}
        }
    }

    readonly property var dailyStats: fullData?.daily_stats ?? {}
    
    property string selectedDate: Qt.formatDateTime(new Date(), "yyyy-MM-dd")
    
    readonly property var selectedStats: dailyStats[selectedDate] ?? { "ui_data": [], "total_time": "0h 0m" }
    
    readonly property string totalTime: selectedStats.total_time
    readonly property var apps: selectedStats.ui_data
    
    function getDateObj(dateStr) {
        var d = Date.fromLocaleString(Qt.locale(), dateStr, "yyyy-MM-dd");
        if (isNaN(d.getTime())) return new Date();
        return d;
    }

    readonly property bool canGoForward: selectedDate !== Qt.formatDateTime(new Date(), "yyyy-MM-dd")
    readonly property bool canGoBack: {
         var d = getDateObj(selectedDate);
         var today = new Date();
         var diffTime = Math.abs(today - d);
         var diffDays = Math.ceil(diffTime / (1000 * 60 * 60 * 24));
         return diffDays < 6;
    }

    function changeDay(offset) {
        if (offset > 0 && !canGoForward) return;
        if (offset < 0 && !canGoBack) return;

        var d = getDateObj(selectedDate);
        var newDate = new Date(d);
        newDate.setDate(d.getDate() + offset);
        
        selectedDate = Qt.formatDateTime(newDate, "yyyy-MM-dd");
    }
    
    function isToday(dateStr) {
        return dateStr === Qt.formatDateTime(new Date(), "yyyy-MM-dd");
    }

    readonly property string currentApp: fullData?.history?.[Qt.formatDateTime(new Date(), "yyyy-MM-dd")]?.current_app ?? "Unknown"

    Timer {
         interval: 2000
         running: true
         repeat: true
         onTriggered: {
             var p = root.cachePath;
             statsFile.path = "";
             statsFile.path = p;
         }
    }
}