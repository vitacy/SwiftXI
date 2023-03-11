#include "ScWindow.h"
#include <memory>
#include <string>
#include <iostream>
#include "SkiaCxxPrivate.h"

#include "include/core/SkScalar.h"
#include "include/core/SkTypes.h"
#include "include/core/SkCanvas.h"
#include "include/core/SkSurface.h"

#include "SkWindow.h"
#include "SkWindowContext.h"
#include "ScSwiftSkiaApp.h"

using namespace SC;

struct ScWindowLayer: public SC::Window::Layer{
std::shared_ptr<SC::Window> window;
void *swiftWindow = nullptr;
bool disable_callback = false;

void doSafeWindowAction(std::function<void(std::shared_ptr<SC::Window>)> f){
    disable_callback = true;
    if (window){
        f(window);
    }
    disable_callback = false;
}
void doSafeSwiftWindowAction(std::function<void(void *)> f){
    if (swiftWindow && !disable_callback){
        f(swiftWindow);
    }
}
void onBackendCreated() override{
}
void onPaint(SkSurface*surface) override{
    auto canvas = surface->getCanvas();
    canvas->clear(SkColor4f{0.9, 0.9, 0.9, 1});

    if (!swiftWindow){
        return;
    }
    ScContext context(canvas);
    SwiftSkiaWindowOnPaint(swiftWindow, &context);
}
bool onMouse(int x, int y, SC::InputState state, SC::ModifierKey modifier) override{
    if (!swiftWindow){
        return false;
    }
    SwiftSkiaWindowOnMouse(swiftWindow, ScPoint::Make(x, y), state, modifier);
    return true;
}
bool onChar(SkUnichar c, SC::ModifierKey modifiers) override{
    return true;
}
bool onKey(SC::Key key, SC::InputState state, SC::ModifierKey modifiers) override{
    return true;
}
bool onMouseWheel(int x, int y, float deltax, float deltay, SC::ModifierKey) override{
    return true;
}
void onClose() override{
    printf("swiftWindow %p\n", swiftWindow);
    if (!swiftWindow || disable_callback){
        return;
    }
    SwiftSkiaWindowOnClose(swiftWindow);
}
void onResize(int width, int height) override{
    if (!swiftWindow || disable_callback){
        return;
    }
    SwiftSkiaWindowOnResize(swiftWindow, ScSize::Make(width, height));
}
};
struct ScWindow::ScWindowInternal{
std::shared_ptr<ScWindowLayer> layer;
};
using namespace SC;
extern void* g_AppPlatformData;
ScWindow::ScWindow(){
    internal = new ScWindow::ScWindowInternal();
    internal->layer = std::make_shared<ScWindowLayer>();
    auto &window = internal->layer->window;
    window = std::shared_ptr<SC::Window>(Window::CreateNativeWindow(g_AppPlatformData));

    window->setRequestedDisplayParams(DisplayParams());
    window->pushLayer(&*internal->layer);
    // window->attach(Window::kNativeGL_BackendType);
    window->attach(Window::kRaster_BackendType);
}
ScWindow::ScWindow(const ScWindow& w){
    internal = new ScWindow::ScWindowInternal();
    internal->layer = w.internal->layer;
}
ScWindow ScWindow::operator=(const ScWindow& w){
    internal->layer = w.internal->layer;
    return *this;
}
ScWindow::~ScWindow(){
    delete internal;
}
void ScWindow::setSwiftWindow(void *swiftWindow){
    internal->layer->swiftWindow = swiftWindow;
}
void ScWindow::getSize(ScSize &value) const{
    auto &window = internal->layer->window;
    auto size = window->getSize();
    value = ScSize::Make(size.fWidth, size.fHeight);
}
void ScWindow::setSize(const ScSize& value){
    internal->layer->doSafeWindowAction([&](auto window){
        window->resize(value.width(), value.height());
    });
}

void ScWindow::getTitle(ScString& value) const{
    auto &window = internal->layer->window;
}
void ScWindow::setTitle(const ScString& value){
    auto &window = internal->layer->window;
    auto title = value.data();
    if (title == nullptr){
        return;
    }
    internal->layer->doSafeWindowAction([&](auto window){
        window->setTitle(title);
    });
}
void ScWindow::setPosition(const ScPoint& p){
    auto &window = internal->layer->window;
    window->setPosition(p.x(), p.y());
}
void ScWindow::getPosition(ScPoint& value){
    auto &window = internal->layer->window;
    auto p = window->getPosition();
    value = ScPoint::Make(p.fX, p.fY);
}
void ScWindow::getContentRect(ScRect &value) const{
    auto &window = internal->layer->window;
    auto rect = window->getContentRect();
    value = ScRect::MakeXYWH(rect.x(), rect.y(), rect.width(), rect.height());
}
void ScWindow::inval(){
    internal->layer->doSafeWindowAction([&](auto window){
        window->inval();
    });
}
void ScWindow::show(){
    internal->layer->doSafeWindowAction([&](auto window){
        window->show();
    });
}
void ScWindow::close(){
    internal->layer->doSafeWindowAction([&](auto window){
        internal->layer->swiftWindow = nullptr;
        internal->layer = nullptr;
    });
}