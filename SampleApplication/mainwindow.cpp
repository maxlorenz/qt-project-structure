#include "mainwindow.h"
#include "ui_mainwindow.h"
#include "samplelibrary.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    SampleLibrary lib;

    ui->setupUi(this);
    ui->label->setText(QString("1 + 2 = %1").arg(lib.add(1, 2)));
}

MainWindow::~MainWindow()
{
    delete ui;
}
