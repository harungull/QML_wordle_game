#include "wordleclass.h"
#include <QDebug>
#include <QFile>
#include <QTextStream>
#include <QString>
#include <QRandomGenerator>

WordleClass::WordleClass(QObject *parent)
    : QObject{parent}
{
    words.clear();
    readFromFile();

}

QString WordleClass::getKeyColorString() const
{
    return keyColorString;
}

void WordleClass::setKeyColorString(int indexx)
{

    keyColorString[indexx]='?';
    //emit keyColorStringChanged();
}


QString WordleClass::getForTempString() const
{
    return forTempString;
    //return forTempString[ftsindex];
}


// 5 ADET HARF VE ENTER GIRILDIGINDE EKRANA BASILAN KELIMENIN HANGI RENKLERDE OLACAGINI AYARLAYAN KOD
void WordleClass::defineColorString(const QString &goTempString)
{
    QString forColorString="KKKKK";
    QString testCaseString=getTestCase();
    QString controlGoTempString=goTempString;
    bool myFlag;

    for(int i=0; i<5; ++i) // tam eslesme kontrol
    {
        if(controlGoTempString[i]==testCaseString[i])
        {
            forColorString[i]='Y'; // Y: Green
            testCaseString[i]='0';
            controlGoTempString[i]='0';

        }
    }

    for(int i=0; i<5; ++i)
    {
        myFlag=false;
        if(forColorString[i]!='Y' )
        {
            for(int j=0; j<5; ++j)
            {

                if(testCaseString[j]==controlGoTempString[i])
                {
                    myFlag=  true;
                    testCaseString[j]='?';
                    controlGoTempString[i]='?';
                    break;
                }

            }
             //O: Orange / G:Gray
            forColorString[i]=myFlag ? 'O' :'G'  ;
        }
    }


    this->setColorString(forColorString);
}



// BILGISAYARIN KLAVYESINDEN GELEN DATAYI ANLAMLANDIRIP SISTEMDE KULLANDIRAN KOD
void WordleClass::useInputFromKeyboard(int keynumber)
{
    QString tempp="";
    //qDebug()<<"gelen sey" << number;
    if(65<=keynumber &&keynumber <=90 ) {

        //tempchar=static_cast<char>(number-'a'+'A');
        //qDebug()<<"GIRDI GIRDI";
        tempp.append(static_cast<QChar>(keynumber));
       // tempp = tr("%1").arg(keynumber);

    }
    else if(keynumber==16777220) { //     16777220->enter
        tempp="ENTER";
    }
    else if(keynumber==16777219) { //     16777219->delete
         tempp="DEL";
    }
    else {
        return;
    }
    //qDebug()<<"string tempp:"<<tempp;
    setTempString(tempp);

}

// WORDS.TXTDEN TUM KELIMELERI ALIP ICLERINDEN RASTGELE BIRINI TEHMIN EDILECEK KELIME YAPAN METOT
void WordleClass::readFromFile()
{
    QFile file(":/new/prefix1/words.txt");
    if (!file.open(QIODevice::ReadOnly | QIODevice::Text)) {
        qDebug()<<"The File couldnt be opened";
        return;
    }
    QTextStream in(&file);
    while (!in.atEnd()) {
        QString temp = in.readLine();
        //qDebug()<< "Dosyadan alinan string:" <<temp;
        if(temp.size()==5 && temp != "     ") // dosyadaki yanlislikla olustukan bosluklari veya 5 harfli olmayanları kullanmamak
            words.append(temp.toUpper());
    }
    std::uniform_int_distribution<int> myrange(0,words.size()-1); // random sayının hangi aralıkta olması gerektiğini ayarlama
    int randnum= myrange(*QRandomGenerator::global());  // random sayıyı oluşturma
//    for(int i=0;i<words.size();++i) {
//        qDebug()<<i<<".eleman:"<<words.at(i);
//    }
    //qDebug()<<"randumnum:"<<randnum;
    setTestCase(words.at(randnum));
}

bool WordleClass::getIsGameCompleted() const
{
    return isGameCompleted;
}

//OYUN SONUNU GETIREN METOT
void WordleClass::setIsGameCompleted(bool newIsGameCompleted)
{
    if (isGameCompleted == newIsGameCompleted)
        return;
    isGameCompleted = newIsGameCompleted;
    emit isGameCompletedChanged();
}

bool WordleClass::isValid(const QString &tryword)
{
    return words.contains(tryword);
}



void WordleClass::resetColorString()
{
    setColorString({});
}


QString WordleClass::getColorString() const
{
    return colorString;
}

void WordleClass::setColorString(const QString &newColorString)
{
    if (colorString == newColorString)
        return;
    colorString = newColorString;
    //qDebug()<<"colorString:"<<colorString;
    emit colorStringChanged();

}



int WordleClass::getCurrentIndex() const
{
    return currentIndex;
}


QString WordleClass::getTestCase() const
{
    return testCase;
}

void WordleClass::setTestCase(const QString &newTestCase)
{
    if (testCase == newTestCase)
        return;
    testCase = newTestCase;

}

QString WordleClass::getTempString() const
{
    return tempString;
}

// HER BUTONA BASILDIGINDA BU METODA DALLANIYORUZ. BU KOD EKRANDAKI HARFLERIN BASILMASINI
void WordleClass::setTempString(const QString &newTempString)
{
    //qDebug()<<"Botona basildi:"<<newTempString;
    if(!getIsGameCompleted() && newTempString!="?") {
        if(newTempString=="DEL" && currentIndex>0) {
            forTempString.removeLast();
            currentIndex--;
            emit currentIndexChanged(false);

        }
        else if (newTempString =="ENTER") {

            if(currentIndex==5) {
                if(isValid(forTempString)) {
                    tempString="";
                    tempString=forTempString;
                    currentIndex=0;
                    displayRow++;
                    forTempString="";
                    //qDebug()<<"tempstring:"<<tempString;
                    this->resetColorString();
                    //emit tempStringChanged();
                    this->defineColorString(tempString);
                }
                else {
                    emit wordIsInvalid(true); // KELIME BULUNAMADI
                }

            }
            else { // YETERSIZ HARF
                emit wordIsInvalid(false);    // 5 HARFTEN OLUSMUYOR
            }

        }
        else if(newTempString !="ENTER" && newTempString!="DEL"){
            if(currentIndex<=4) {
                forTempString.append(newTempString);

                emit currentIndexChanged(true);
                currentIndex++;
            }
        }
    }
}

int WordleClass::getDisplayRow() const
{
    return displayRow;
}






