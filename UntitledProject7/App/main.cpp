// Copyright (C) 2024 The Qt Company Ltd.
// SPDX-License-Identifier: LicenseRef-Qt-Commercial OR GPL-3.0-only

#include <QApplication>
#include <QQmlApplicationEngine>

#include "autogen/environment.h"

int main(int argc, char *argv[])
{
    set_qt_environment();
    QApplication app(argc, argv);
    return app.exec();
}
