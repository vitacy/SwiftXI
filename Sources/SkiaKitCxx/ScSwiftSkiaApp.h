#pragma once
#include "ScAppEvent.h"
#include "ScTypes.h"
#include "ScRect.h"
#include "ScContext.h"

using SwiftStringRef=void* ;
class ScContext;
#ifdef __cplusplus
extern "C" {
#endif

void SwiftSkiaAppIdle(double time);
void SwiftSkiaAppActivate();

void SwiftSkiaWindowOnClose(void* swift_window);
void SwiftSkiaWindowOnPaint(void* swift_window, ScContext *context);
void SwiftSkiaWindowOnResize(void* swift_window, ScSize size);
void SwiftSkiaWindowOnMouse(void* swift_window, ScPoint point, SC::InputState state, SC::ModifierKey modifier);
bool SwiftSkiaWindowOnKey(void* swift_window, SC::Key key, SC::InputState state, SC::ModifierKey modifier);
bool SwiftSkiaWindowOnChar(void* swift_window, SkUnichar code, SC::ModifierKey modifier);
bool SwiftSkiaWindowOnMouseWheel(void* swift_window, ScPoint point, ScSize delta, SC::ModifierKey modifier);

class ScString;
void SwiftStringArrayAddUtf8StringItem(void *array, ScString &str);
#ifdef __cplusplus
}
#endif

void SwiftStringArrayAddUtf8StringItem(void *array, SkString &str);