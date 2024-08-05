import QtQuick 2.12
import QtQuick.Controls 2.12
import module.wordleclass 1.0

ApplicationWindow {
    id: result
        width: 200
        height: 100
        color:"black"
        title:"Result"
        // DOGRU KELIME TAHMININDE GOSTERILEN PENCERE
        Text {
            id: name
            anchors.centerIn: parent
            x:10
            y:10
            font.family: "Arial"
            font.pointSize: 15
            color:"green"
            font.bold:true
            text:qsTr("Congratulations!")
        }
}

