#ifndef WORDLECLASS_H
#define WORDLECLASS_H

#include <QObject>
#include <QtQml>
#include <string.h>
#include <QTimer>

class WordleClass : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString testCase READ getTestCase WRITE setTestCase NOTIFY testCaseChanged)
    Q_PROPERTY(QString tempString READ getTempString WRITE setTempString NOTIFY tempStringChanged)
    Q_PROPERTY(QString colorString READ getColorString WRITE setColorString RESET resetColorString  NOTIFY colorStringChanged)
    Q_PROPERTY(bool isGameCompleted READ getIsGameCompleted WRITE setIsGameCompleted NOTIFY isGameCompletedChanged)
    QML_ELEMENT


public:
    explicit WordleClass(QObject *parent = nullptr);
    QString forTempString="";
    QString keyColorString="QWERTYUIOPASDFGHJKL??ZXCVBNM?";

    int currentIndex=0;

    Q_INVOKABLE QString getTestCase() const;
    Q_INVOKABLE void setTestCase(const QString &newTestCase);
    Q_INVOKABLE QString getTempString() const;
    Q_INVOKABLE void setTempString(const QString &newTempString);
    Q_INVOKABLE int getDisplayRow() const;

    Q_INVOKABLE int getCurrentIndex() const;

    Q_INVOKABLE QString getForTempString() const;

    Q_INVOKABLE QString getColorString() const;
    void setColorString(const QString &newColorString);





    void resetColorString();

    Q_INVOKABLE QString getKeyColorString() const;
    Q_INVOKABLE void setKeyColorString(int indexx);

    Q_INVOKABLE bool getIsGameCompleted() const;
    Q_INVOKABLE void setIsGameCompleted(bool newIsGameCompleted);

    bool isValid(const QString &tryword);



signals:

    void tempStringChanged();
    void currentIndexChanged(bool negpos);

    void colorStringChanged();

    void keyColorStringChanged();

    void isGameCompletedChanged();

    void wordIsInvalid(bool isFiveWord);

    void testCaseChanged();

public slots:
    void defineColorString(const QString &goTempString);

    Q_INVOKABLE void useInputFromKeyboard(int keynumber);

private:
    QString testCase= "KABAK";
    QString colorString="ggggg";
    QString tempString="";
    int displayRow=0;
    QString silString="";
    bool isGameCompleted=false;

    QList <QString> words;
    void readFromFile();

    QTimer *myTimer2;


};

#endif // WORDLECLASS_H
