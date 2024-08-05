import QtQuick 2.12
//import QtQuick.Controls 2.0
import QtQuick.Controls.Basic
import QtQuick.Layouts 1.12
Item {
    property alias myrep2:rep2
    Item {
        id: keyboardchars
        property variant chars: ["Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P", "A", "S",
        "D", "F", "G", "H", "J", "K", "L", "?", "ENTER", "Z", "X", "C", "V", "B", "N", "M", "DEL"]
    }

    // EKRANI KONTROL EDEN BUTONLARIN TASARIMI
    Grid {
        id: grid2
        x: 170
        y: 350
        spacing: 10
        columns: 10
        rows: 3
        Repeater {

            id: rep2
            model: 29
            Button {
                id: button2
                property bool flag1: index === 19 ? true : false
                Text {
                    id:buttontext
                    anchors.centerIn: parent
                    font.family:"Arial"
                    font.pointSize: index===20 || index===28 ? 10 :15
                    color:  flag1? "black":"white"
                    font.bold: true

                    text: keyboardchars.chars[index]
                }

                background :Rectangle {
                    id: backgra
                    implicitWidth:  45//index===20 || index===28 ? 65 :45
                    implicitHeight: 55
                    color: flag1 ? "black" : "gray"
                    radius:3
                }
                onClicked: wordleApp.setTempString(buttontext.text)
            }
        }
    }

}
