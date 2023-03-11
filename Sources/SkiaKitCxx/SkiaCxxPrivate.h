#pragma once

#include "ScTypes.h"
#include "ScRect.h"
#include "ScContext.h"
#include "ScFont.h"
#include "ScImage.h"
#include "ScApplication.h"
#include "ScAppEvent.h"
#include "ScWindow.h"

#include "ScSwiftSkiaApp.h"

#include "SkiaCxxSkiaPublic.h"

struct ScSkConvertible{
};
extern ScSkConvertible ScSK;
inline SkPoint operator|(ScPoint p, ScSkConvertible){
    return SkPoint::Make(p.x(), p.y());
}

inline SkRect operator|(ScRect rect, ScSkConvertible){
    return SkRect::MakeXYWH(rect.x(), rect.y(), rect.width(), rect.height());
}

