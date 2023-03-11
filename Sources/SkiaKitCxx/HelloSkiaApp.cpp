/*
* Copyright 2017 Google Inc.
*
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*/

#include "HelloSkiaApp.h"
#include "ScSwiftSkiaApp.h"
#include "SkiaCxxPrivate.h"

#include "include/core/SkCanvas.h"
#include "include/core/SkColor.h"
#include "include/core/SkFont.h"
#include "include/core/SkFontTypes.h"
#include "include/core/SkGraphics.h"
#include "include/core/SkPaint.h"
#include "include/core/SkPoint.h"
#include "include/core/SkRect.h"
#include "include/core/SkShader.h"
#include "include/core/SkString.h"
#include "include/core/SkSurface.h"
#include "include/core/SkTileMode.h"
#include "include/effects/SkGradientShader.h"

#include <string.h>

#include <SkiaKit/SkiaKit.h>

using namespace SC;

// static Application* s_app=nullptr;
// Application* Application::Create(int argc, char** argv, void* platformData) {
//     s_app = new HelloSkiaApp(argc, argv, platformData);
//     return shared();
// }
Application* Application::shared(){
    static HelloSkiaApp s_app;
    return &s_app;
}
extern void* g_AppPlatformData;
HelloSkiaApp::HelloSkiaApp()
{
    SkGraphics::Init();
}
HelloSkiaApp::~HelloSkiaApp() {
}
void HelloSkiaApp::launchApp(){
    SwiftSkiaAppActivate();
}
void HelloSkiaApp::onIdle() {
    SwiftSkiaAppIdle(0);
}
void HelloSkiaApp::onTimer(){
    SwiftSkiaAppIdle(0.001);
}



