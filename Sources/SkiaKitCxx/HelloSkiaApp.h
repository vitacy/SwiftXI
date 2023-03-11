/*
* Copyright 2017 Google Inc.
*
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*/

#ifndef HelloWorld_DEFINED
#define HelloWorld_DEFINED

#include <string>
#include "include/core/SkScalar.h"
#include "include/core/SkTypes.h"

#include "ScDisplayParams.h"
#include "ScModifierKey.h"

#include "ScApplication.h"

using namespace SC;

class HelloSkiaApp: public SC::Application{
public:
    HelloSkiaApp();
    ~HelloSkiaApp() override;

    void onTimer() override;
    void launchApp() override;
    void onIdle() override;
};

#endif
