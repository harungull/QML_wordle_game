import QtQuick 2.12
import QtQuick.Window 2.12
//import QtQuick.Controls 2.0
import QtQuick.Controls.Basic
import module.wordleclass 1.0
import QtQml 2.12

//"QWERTYUIOPASDFGHJKL?<ZXCVBNM>"
ApplicationWindow {
    //property string keyColor: "QWERTYUIOPASDFGHJKL??ZXCVBNM?"
    id: root
    property string keyColor: ""
    property string kcStr: ""
    property int correctColorNumber: 0
    property string screentext: "asadada"
    property string colorStr: ""
    property int i: 0
    property int j: 0
    property int currentIndex: 0
    property bool myFlag: false
    property bool timerFlag: true
    property int loopCounter: 0
    property int myIndex: 0

    width: 800
    height: 1400
    visible: true
    color: "black"
    title: qsTr("WORDLE")

    WordleClass {   // Class ve QML Entegrasyonu
        id: wordleApp
    }

    MyKeyboard {
        id: mykeyboard
    }

    MyScreen {
        id: myscreen
    }

    MyResultWindow {
        id: myrwindow
    }
    //KEYBOARD KULLANIMI : HER KEYI ALIP KULLANMAK UZERE GONDEREN KOD
    Item {
        id: forkeyboard
        focus: true

        Keys.onPressed: event => {
            wordleApp.useInputFromKeyboard(event.key)
            //console.log(event.key)
        }
    }
    // KELIMENIN LISTEDE OLMADIGINI SOYLEYEN YAZININ 1SN BOYUNCA EKRANDA KALMASINI SAGLAYAN TIMER
    Timer {
        id: myTimer1
        interval: 1000
        running: false
        repeat: false
        onTriggered: myscreen.myInvalidScreen.visible = false
    }
    // KELIME GIRILDIGINDA HER HARFIN ANIMASYONUNUN 300MS ARALIKLA OLMASINI SAGLAYAN KOD
    Timer {
        id: myTimer2
        interval: 300
        running: false
        repeat: true
        onTriggered: {
            keyColor = wordleApp.getKeyColorString()
            kcStr = wordleApp.getTempString()
            myIndex = 4 - loopCounter
            // EKRANDAKI HARFLERIN RENGININ BELIRLENMESI
            colorStr = wordleApp.getColorString()
            colorStr[myIndex] === 'Y' ? myscreen.myrep1.itemAt(myIndex + ((wordleApp.getDisplayRow() - 1) * 5)).color = "green" :
            colorStr[myIndex] === 'G' ? myscreen.myrep1.itemAt(myIndex + ((wordleApp.getDisplayRow() - 1) * 5)).color = "red" :
                                        myscreen.myrep1.itemAt(myIndex + ((wordleApp.getDisplayRow() - 1) * 5)).color = "orange"

            // O AN BELIRLENEN HARF YESIL RENKTEYSE ILGILI BUTONU OLUP RENGININ YESIL OLMASININ SAGLANMASI
            if (colorStr[myIndex] === 'Y') {
                correctColorNumber++
                for (j = 0; j < 29; ++j) {
                    if (kcStr[myIndex] === keyColor[j]) {
                        mykeyboard.myrep2.itemAt(j).background.color = "green"
                        keyColor = wordleApp.getKeyColorString()
                        wordleApp.setKeyColorString(j)
                        break
                    }
                }
            }

            // TURUNCU TAHMIN VARSA VE O TAHMIN EDILEN HARFIN DAHA ONCE DOGRU YERI BULUNMAMISSA
            // KLAVYEDEKI ILGILI YERINI TURUNCU YAPAN KOD
            for (i = 0; i < 5; ++i) {
                for (j = 0; keyColor[j]; ++j) {
                    if (kcStr[myIndex] === keyColor[j] && colorStr[myIndex] === 'O') {
                        // "#008000" -> "green"
                        if (mykeyboard.myrep2.itemAt(j).background.color != "#008000") {
                            mykeyboard.myrep2.itemAt(j).background.color = "orange"
                            break
                        }
                    }
                }
            }

            // RED TAHMININ KLAVYEDEKI RENGININ RED YAPILMASINI SAGLAYAN KOD (YESIL VEYA TURUNCU OLMAYACAK OLAN)
            for (i = 0; i < 5; ++i) {
                for (j = 0; keyColor[j]; ++j) {
                    if (kcStr[myIndex] === keyColor[j]) {
                        // "#008000" -> "green" "#ffa500"->orange
                        if (mykeyboard.myrep2.itemAt(j).background.color != "#008000" &&
                            mykeyboard.myrep2.itemAt(j).background.color != "#ffa500") {
                            mykeyboard.myrep2.itemAt(j).background.color = "red"
                            break
                        }
                    }
                }
            }
            if (loopCounter == 0) {
                // OYUNUN KAZANILIP KAZANILMAMASINA GORE YAPILACAK ISLEMLERIN BELIRLENDIGI VE OYUNUN DURDURULDUGU YER
                if (correctColorNumber == 5) {
                    myFlag = true
                    wordleApp.setIsGameCompleted(true)
                } else if (wordleApp.getDisplayRow() === 6 && !myFlag) {
                    wordleApp.setIsGameCompleted(true)
                }

                myTimer2.stop()
            }

            loopCounter--
        }
    }

    // C++ TARAFINDAKI NOTIFY ISLEMLERI SONRASI YAPILMASI GEREKENLERIN YAPILDIGI YER
    Connections {
        target: wordleApp

        //KELIME EGER WORDS.TXT ICERISINDE YOKSA EKRANDA UYARI YAZISINI KONTROL EDEN KOD
        onWordIsInvalid: {//function onWordIsInvalid(isFiveWord) {
            myscreen.enoughFlag = isFiveWord ? true: false // true: kelime bulunamadi false: yetersiz harf
            myscreen.myInvalidScreen.visible = true
            myTimer1.running = true
            for (var k = 0; k < 5; ++k) {
                myscreen.myrep1.itemAt(k + (wordleApp.getDisplayRow() * 5)).animstart1 = false
                myscreen.myrep1.itemAt(k + (wordleApp.getDisplayRow() * 5)).animstart1 = true
            }
            // BUTON ILE ISLEM YAPILDIGI ZAMAN KEYEVENT FOCUSUNU KAYBEDIYOR ONUN COZUMU
            forkeyboard.focus = true
        }

        // 5 ADET HARFI GIRDIKTEN SONRA ENTERE BASILDIGINDA EKRAN VE KLAVYENIN RENKLERINI AYARLAYAN TIMERIN BASLATILMASI
        onColorStringChanged: {//function onColorStringChanged() {
            if (wordleApp.getColorString() != "") {
                correctColorNumber = 0
                myTimer2.stop()
                if (!myTimer2.running) {
                    loopCounter = 4
                    myTimer2.start()
                }
            }
            // BUTON ILE ISLEM YAPILDIGI ZAMAN KEYEVENT FOCUSUNU KAYBEDIYOR ONUN COZUMU
            forkeyboard.focus = true
        }

        // GELEN İSLEME VE FOZISYONA GORE EKRANA HARFLERIN GONDERILMESI
        onCurrentIndexChanged: {//function onCurrentIndexChanged(negpos) {//
            screentext = wordleApp.getForTempString()
            currentIndex = wordleApp.getCurrentIndex()
            negpos ? myscreen.myrep1.itemAt(currentIndex + (wordleApp.getDisplayRow() * 5)).recText = screentext[currentIndex]
                   : myscreen.myrep1.itemAt(currentIndex + (wordleApp.getDisplayRow() * 5)).recText = ""

            //HER HARF GIRILDIGINDE OYNATILAN ANIMASYONUN SADECE HARF GIRERKEN GOSTERILMESININ SAGLANMASI
            if (negpos) {
                myscreen.myrep1.itemAt(currentIndex + (wordleApp.getDisplayRow() * 5)).animstart2 = false
                myscreen.myrep1.itemAt(currentIndex + (wordleApp.getDisplayRow() * 5)).animstart2 = true
            }

            // BUTON ILE ISLEM YAPILDIGI ZAMAN KEYEVENT FOCUSUNU KAYBEDIYOR ONUN COZUMU
            forkeyboard.focus = true
        }
        //KELIME DOGRU GIRILDIGINDE VEYA DENEME HAKKI KALMADIGINDA BURADA SON EKRANLARI KONTROL EDIYORUM
        onIsGameCompletedChanged: {//function onIsGameCompletedChanged() {
            myscreen.myResultRect.visible = true
            if (myFlag) {
                myscreen.myFlag1 = true
                var component = Qt.createComponent("MyResultWindow.qml")
                var window = component.createObject(root)
                window.show()
            }
        }
    }
}
