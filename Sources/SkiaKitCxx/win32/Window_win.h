/*
* Copyright 2016 Google Inc.
*
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*/

#ifndef Window_win_DEFINED
#define Window_win_DEFINED

#include "SkWindow.h"

#include <windows.h>

namespace SC {

class Window_win : public Window {
public:
    Window_win() : Window() {}
    ~Window_win() override;

    bool init(HINSTANCE instance);

    void setTitle(const char*) override;
    void show() override;
    void close() override;

    virtual SkISize getSize() const override;
    virtual void resize(int width, int height) override;
    virtual void setPosition(int posX, int posY) override;
    virtual SkIPoint getPosition() const override;
    virtual SkIRect getContentRect() const override;

    void setInputMethodStatus(bool enable) override;

    bool attach(BackendType) override;

    void onInval() override;

    void setRequestedDisplayParams(const DisplayParams&, bool allowReattach) override;

private:
    void closeWindow();

    HINSTANCE   fHInstance;
    HWND        fHWnd;
    BackendType fBackend;
    bool        fInitializedBackend = false;

    using INHERITED = Window;
};

}   // namespace sk_app

#endif
