/*
* Copyright 2016 Google Inc.
*
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*/

#ifndef Application_DEFINED
#define Application_DEFINED

namespace SC {

class Application {
protected:
    Application(){};
public:
    Application(const Application&);//not defined, only to avoid swift not import this type
    Application(Application&&) = delete;
    Application &operator=(const Application&) = delete;
    Application &operator=(Application&&) = delete;

    static Application* Create(int argc, char** argv, void* platformData);
    static Application* shared();

    virtual ~Application() {}

    virtual void launchApp() = 0;
    virtual void onIdle() = 0;
    virtual void onTimer() = 0;

    virtual void run();
    virtual void quit();
};

}   // namespace sk_app

#endif
