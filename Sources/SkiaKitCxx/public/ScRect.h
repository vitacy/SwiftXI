#pragma once

#include "ScTypes.h"
#include "ScValue.h"

// SkPoint
struct ScPoint {
    SkScalar fX; 
    SkScalar fY; 
    static constexpr ScPoint Make(SkScalar x, SkScalar y) {
        return {x, y};
    }
    static ScPoint MakeEmpty() { return {0, 0}; }

    constexpr SkScalar x() const { return fX; }
    constexpr SkScalar y() const { return fY; }
};
// SkSize
struct ScSize {
    SkScalar fWidth;
    SkScalar fHeight;

    static ScSize Make(SkScalar w, SkScalar h) { return {w, h}; }
    static ScSize MakeEmpty() { return {0, 0}; }

    SkScalar width() const { return fWidth; }
    SkScalar height() const { return fHeight; }
};
//SkRect
struct ScRect {
    SkScalar fLeft; 
    SkScalar fTop;    
    SkScalar fRight;  
    SkScalar fBottom;
    static constexpr ScRect MakeEmpty() {
        return ScRect{0, 0, 0, 0};
    }
    static constexpr ScRect MakeXYWH(SkScalar x, SkScalar y, SkScalar w,
                                                           SkScalar h) {
        return ScRect {x, y, x + w, y + h};
    }
    constexpr SkScalar x() const { return fLeft; }
    constexpr SkScalar y() const { return fTop; }
    constexpr SkScalar width() const { return fRight - fLeft; }
    constexpr SkScalar height() const { return fBottom - fTop; }
};
