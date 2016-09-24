#include <QString>
#include <QtTest>
#include "samplelibrary.h"

class SampleTest : public QObject
{
    Q_OBJECT

public:
    SampleTest();

private Q_SLOTS:
    void additionWithZero();
    void additionWithNegative();
    void shouldFail();
};

SampleTest::SampleTest()
{
}

void SampleTest::additionWithZero()
{
    SampleLibrary lib;
    int testNumber = 42;

    QVERIFY2(lib.add(0, testNumber) == testNumber, "addition of 0 doesn't change the result");
}

void SampleTest::additionWithNegative()
{
    SampleLibrary lib;
    int testNumber = 42;

    QVERIFY2(lib.add(-5, testNumber) == testNumber - 5, "addition with a negative number should "
                                                        "yield the same result as a subtraction");
}

void SampleTest::shouldFail()
{
    QVERIFY(false);
}

QTEST_APPLESS_MAIN(SampleTest)

#include "tst_sampletest.moc"
