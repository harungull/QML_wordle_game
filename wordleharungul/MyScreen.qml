import QtQuick 2.12

Item {

    property alias myrep1:rep1
    property alias myResultRectLose:resultRect
    property alias myResultRect:resultRect
    property alias myInvalidScreen:invalidscreen
    property bool myFlag1:false
    property bool enoughFlag:false

    // 6 DENEME 5 KELİMEYI GOSTEREN EKRAN TASARIMI
    Grid {
        id: grid1
        x:300
        //anchors.horizontalCenter: parent.horizontalCenter
        y: 40
        spacing: 10
        columns: 5
        rows: 6
        Repeater {
            id: rep1
            model: 30
            Rectangle {
                id: rect1
                width: 40
                height: 40
                color: "black"
                border.width: 0.5
                border.color: "gray"
                property string recText: ""
                property bool rectRotAnim1 :false
                property bool animstart1:false
                property bool animstart2:false
                onColorChanged: {
                    rectRotAnim1=true
                }
                // KELIMENIN LISTEDE OLDUGU ONAYLANDIKTAN SONRA RENKLERINI BELIRLERKEN DONMESINI SAGLAYAN KISIM
                transform: Rotation {
                    axis.x:1 ;axis.y:0 ; axis.z:0
                    origin.x: 20
                    origin.y: 20
                    angle: rectRotAnim1? -180 :0
                        Behavior on angle {
                            NumberAnimation{
                                duration:400
                            }
                        }
                }
                // LISTEDE OLMAYAN BIR KELIME GIRILIP ENTERE BASILDIGINDA OYNATILAN ANIMASYON
                SequentialAnimation {
                    running: animstart1 ? true:false
                    NumberAnimation { target: rect1 ;  property:"x" ;from:rect1.x;    to:rect1.x+10; duration:50  }
                    NumberAnimation { target: rect1 ;  property:"x" ;from:rect1.x+10; to:rect1.x;    duration:50  }
                    NumberAnimation { target: rect1 ;  property:"x" ;from:rect1.x;    to:rect1.x-10; duration:50  }
                    NumberAnimation { target: rect1 ;  property:"x" ;from:rect1.x-10; to:rect1.x;    duration:50  }
                    NumberAnimation { target: rect1 ;  property:"x" ;from:rect1.x;    to:rect1.x+10; duration:50  }
                    NumberAnimation { target: rect1 ;  property:"x" ;from:rect1.x+10; to:rect1.x;    duration:50  }
                }

                //HER HARF GIRILDIGINDE OYNATILAN ANIMASYON
                SequentialAnimation {
                    running:animstart2 ? true:false
                    NumberAnimation { target:rect1; property:"scale"; from:0;   to:1.2 ;duration:50 }
                    NumberAnimation { target:rect1; property:"scale"; from:1.2; to:1   ;duration:50 }
                }

                Text {
                    id:text1
                    anchors.centerIn: parent
                    font.family: "Arial"
                    font.pointSize: 20
                    color: "white"
                    text: recText
                    // RECT ROTATE EDILDIGINDE HARF TERS KALIYOR. BUNA COZUM OLARAK O ANIMASYON SIRASINDA HARFI DE ROTATE ETTIM
                    transform: Rotation {
                        axis.x:1 ;axis.y:0 ; axis.z:0
                        origin.x: 15
                        origin.y: 15
                        angle: rectRotAnim1? 180 :0
                            Behavior on angle {
                                NumberAnimation {
                                    duration:400
                                }
                            }
                    }

                }
            }
        }
    }

    // BULMAYA CALISILAN KELIMENIN OYUN SONUNDA EKRANDA GOSTERILMESI
    Rectangle {

        id: resultRect
        x:380
        y: 25
        width: 80
        height: 40
        visible: false
        color: "white"
        radius: 30
        Text {
            id: resultText
            anchors.centerIn: parent
            font.family: "Arial"
            font.pointSize: 15
            color: "black"
            text: myFlag1 ? qsTr("splendid"):wordleApp.getTestCase()
        }

    }

    // GIRILEN KELIME EGER WORDS.TXTDE YOKSA VEYA YETERLI SAYIDA HARF GIRILMEDIYSE EKRANDA GOSTERILECEK RECTANGLE
    Rectangle {

        id: invalidscreen
        //x:380
        anchors.horizontalCenter: resultRect.horizontalCenter
        y: 25
        width: 150
        height: 30
        visible: false
        color: "white"
        radius: 30
        Text {
            id: invalidscreenText
            anchors.centerIn: parent
            font.family: "Arial"
            font.pointSize: 13
            color: "black"
            text: enoughFlag ?qsTr("Not in word list") : qsTr("Not enough letters")
        }

    }
}
