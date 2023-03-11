#pragma once

#include "ScTypes.h"
#include "ScValue.h"
#include "ScImage.h"
#include "ScFont.h"
#include "ScRect.h"

class SkCanvas;
class SkString;
class SkPaint;
class SkPath;
class SkFont;


class ScPaint: public ScValue<SkPaint>{
public:
    void setColor(ScFloat, ScFloat, ScFloat, ScFloat);
    void setStroke(bool );
    void setAntiAlias(bool );
};
class ScPath: public ScValue<SkPath>{
public:
    void moveTo(SkScalar x, SkScalar y);
    void lineTo(SkScalar x, SkScalar y);
    void quadTo(const ScPoint& p1, const ScPoint& to);
    void cubicTo(const ScPoint& p1, const ScPoint& p2, const ScPoint& to);
    void close();
};

class ScCanvas {
public:
    ScCanvas(SkCanvas *c);
    void save() const;
    void restore() const;
    void draw(const ScPath &path, const ScPaint &paint) const;
    void drawGlyphs(int count, const SkGlyphID glyphs[], const ScPoint positions[], const ScPoint &origin, const ScFont& font, const ScPaint& paint) const;
    void drawImage(const ScImage &image, const ScRect &rect) const;
    void drawImage(const ScBitmap &bitmap, const ScRect &rect) const;
    // void concat(SkMatrix &matrix) const;
    void clipPath(const ScPath& path, bool antialiased) const;
private:
    SkCanvas *canvas = nullptr;
};

class ScContext{
public:
    ScContext();
    ~ScContext();
    ScContext(const ScContext&);
    ScContext(SkCanvas *c);

    void concatTransform(const float m[6]);
    void setTransform(const float m[6]);

    void drawPath(const ScPath &path, const ScPaint &paint) const;
    void drawGlyphs(int count, const SkGlyphID glyphs[], const ScPoint positions[], const ScPoint &origin, const ScFont& font, const ScPaint& paint) const;
    void drawImage(const ScImage &image, const ScRect &rect) const;
    void drawImage(const ScBitmap &bitmap, const ScRect &rect) const;
    void clipPath(const ScPath& path, bool antialiased = true) const;

    void save();
    void restore();
private:
    SkCanvas *canvas = nullptr;
    struct ScContextInternal;
    ScContextInternal* internal = nullptr;
};