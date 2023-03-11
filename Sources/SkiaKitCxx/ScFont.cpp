#include <memory>

#include "ScFont.h"
#include "SkiaCxxPrivate.h"

#include <include/core/SkFont.h>
#include <include/core/SkFontMetrics.h>
#include <include/core/SkFontMgr.h>
#include <include/core/SkString.h>

static SkString makeFontName(SkString family, SkString styleName) {
    SkString fontName = family;
    fontName += " ";
    fontName += styleName;
    return fontName;
}

static sk_sp<SkTypeface> fontFaceForFontName(SkString fontname) {
    auto mgr = SkFontMgr::RefDefault();
    auto num = mgr->countFamilies();

    sk_sp<SkTypeface> face;
    for (int i = 0; i < num; i++) {
        SkString family;
        mgr->getFamilyName(i, &family);
        if (fontname.startsWith(family.data())) {
            auto sets = sk_sp(mgr->createStyleSet(i));
            int setsNum = sets->count();

            for (int index = 0; index < setsNum; index++) {
                SkFontStyle style;
                SkString name;
                sets->getStyle(index, &style, &name);
                if (makeFontName(family, name) == fontname) {
                    face = sk_sp(sets->createTypeface(index));
                    break;
                }
            }
        }
    }
    return face;
}

ScFont::ScFont(){
    getFont() = std::make_shared<SkFont>();
    configFont();
}
ScFont::ScFont(const ScFont& v){
    *this = v;
}
ScFont::ScFont(const sk_sp<SkTypeface>& face, ScFloat size){
    getFont() = std::make_shared<SkFont>(face, size);
    configFont();
}
ScFont::ScFont(const ScString& name, ScFloat size){
    sk_sp<SkTypeface> face;
    if (name.size() == 0) {
        face = SkTypeface::MakeDefault();
    } else {
        face = fontFaceForFontName(SkString(name.data()));
    }
    getFont() = std::make_shared<SkFont>(face, size);
    configFont();
}
ScFont& ScFont::operator=(const ScFont& v){
    getFont() = v.getFont();
    return *this;
}

ScFont::~ScFont(){
}
void ScFont::configFont(){
    auto font = getFont();
    font->setSubpixel(true);
    font->setEdging(SkFont::Edging::kSubpixelAntiAlias);
    font->setHinting(SkFontHinting::kSlight);
    font->setForceAutoHinting(false);
}
bool ScFont::isValid() const{
    return getFont()->getTypeface() != nullptr;
}
const SkFont& ScFont::ref() const{
    return *getFont();
}
ScString ScFont::fontName() const{
    SkString name;
    auto face = getFont()->getTypeface();
    if (face){
        face->getFamilyName(&name);
    }
    return name;
}
ScString ScFont::familyName() const{
    SkString name;
    auto face = getFont()->getTypeface();
    if (face){
        face->getFamilyName(&name);
    }
    return name;
}
SkScalar ScFont::pointSize() const{
    return getFont()->getSize();
}
SkScalar ScFont::lineHeight() const{
    return getFont()->getSpacing();
}
SkScalar ScFont::ascender() const{
    SkFontMetrics m={0};
    auto font = getFont();
    font->getMetrics(&m);
    return m.fAscent;
}
SkScalar ScFont::getDescender() const{
    SkFontMetrics m={0};
    auto font = getFont();
    font->getMetrics(&m);
    return m.fDescent;
}
SkScalar ScFont::getLeading() const{
    SkFontMetrics m={0};
    auto font = getFont();
    font->getMetrics(&m);
    return m.fLeading;
}
void ScFont::unicharsToGlyphs(const SkUnichar uni[], int count, SkGlyphID glyphs[]) const{
    auto font = getFont();
    font->unicharsToGlyphs(uni, count, glyphs);
}
void ScFont::layoutGlyphs(const SkGlyphID glyphs[], int count, SkScalar widths[], ScRect bounds[], const ScPaint* paint) const{
    auto font = getFont();
    font->getWidthsBounds(glyphs, count, widths, (SkRect*)bounds, paint == nullptr ? nullptr : &paint->ref());
}
void ScFont::fallbackSystemFont(const SkUnichar character, ScFont &w) const{
    auto font = getFont();
    auto face = font->getTypeface();
    sk_sp<SkTypeface> fallback;
    if (face){
        fallback = sk_sp(SkFontMgr::RefDefault()->matchFamilyStyleCharacter(nullptr, face->fontStyle(), nullptr, 0, character));
        w = ScFont(fallback, pointSize());
    }
}
void ScFont::toItalic(ScFont &w) const{
    auto font = getFont();
    auto face = font->getTypeface();
    if (face && !face->isItalic()){
        auto oldStyle = face->fontStyle();
        auto style = SkFontStyle(oldStyle.weight(), oldStyle.width(), SkFontStyle::Slant::kItalic_Slant);
        SkString name;
        face->getFamilyName(&name);
        auto result = SkTypeface::MakeFromName(name.data(), style);
        w = ScFont(result, pointSize());
        return;
    }
    w = ScFont();
}
ScFont ScFont::withWeight(const ScFontStyle::Weight w) const{
    auto font = getFont();
    auto face = font->getTypeface();
    if (face && !face->isBold()){
        auto oldStyle = face->fontStyle();
        auto style = SkFontStyle((SkFontStyle::Weight)w, oldStyle.width(), oldStyle.slant());
        SkString name;
        face->getFamilyName(&name);
        auto result = SkTypeface::MakeFromName(name.data(), style);
        return ScFont(result, pointSize());
    }
    return ScFont();
}
void ScFont::withWeight(const ScFontStyle::Weight w, ScFont &font) const{
    font = withWeight(w);
}

void ScFont::getAllFontFamilies(void *array) {
    auto mgr = SkFontMgr::RefDefault();
    auto num = mgr->countFamilies();
    for (int i = 0; i < num; i++) {
        SkString str;
        mgr->getFamilyName(i, &str);
        if (str.size() > 0) {
            SwiftStringArrayAddUtf8StringItem(array, str);
        }
    }
}
void ScFont::getAllFontNames(void *array) {
    auto mgr = SkFontMgr::RefDefault();
    auto num = mgr->countFamilies();
    for (int i = 0; i < num; i++) {
        SkString family;
        mgr->getFamilyName(i, &family);
        auto sets = sk_sp(mgr->createStyleSet(i));
        int setsNum = sets->count();
        for (int index = 0; index < setsNum; index++) {
            SkFontStyle style;
            SkString name;
            sets->getStyle(index, &style, &name);
            if (name.size() > 0) {
                auto fontName = makeFontName(family, name);
                SwiftStringArrayAddUtf8StringItem(array, fontName);
            }
        }
    }
}

void SwiftStringArrayAddUtf8StringItem(void *array, SkString &str){
    auto scString = ScString(str);
    SwiftStringArrayAddUtf8StringItem(array, scString);
}