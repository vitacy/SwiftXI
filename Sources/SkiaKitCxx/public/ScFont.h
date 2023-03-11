#pragma once
#include "ScTypes.h"
#include "ScValue.h"
#include "ScString.h"
#include "ScRect.h"

class SkFont;
class ScPaint;
class SkTypeface;
template<typename T>
class sk_sp;

class ScFontStyle {
public:
    enum class Weight {
        kInvisible_Weight   =    0,
        kThin_Weight        =  100,
        kExtraLight_Weight  =  200,
        kLight_Weight       =  300,
        kNormal_Weight      =  400,
        kMedium_Weight      =  500,
        kSemiBold_Weight    =  600,
        kBold_Weight        =  700,
        kExtraBold_Weight   =  800,
        kBlack_Weight       =  900,
        kExtraBlack_Weight  = 1000,
    };
};
namespace std{
    template<typename T>
    class shared_ptr;
}
template<>
struct ScValueLimit<std::shared_ptr<SkFont>>{
static constexpr size_t Align = 8;
static constexpr size_t Size = 16;
};

class ScFont{
    public:
    ScFont();
    ScFont(const ScFont&);
    ScFont(const ScString& name, ScFloat size);
    ScFont(const sk_sp<SkTypeface>&, ScFloat size);
    ScFont& operator=(const ScFont&);

    ~ScFont();

    bool isValid() const;
    const SkFont& ref() const;

    ScString fontName() const;
    ScString familyName() const;
    SkScalar pointSize() const;
    SkScalar lineHeight() const;
    SkScalar ascender() const;
    SkScalar getDescender() const;
    SkScalar getLeading() const;

    void unicharsToGlyphs(const SkUnichar uni[], int count, SkGlyphID glyphs[]) const;
    void layoutGlyphs(const SkGlyphID glyphs[], int count, SkScalar widths[], ScRect bounds[], const ScPaint* paint) const;

    void fallbackSystemFont(const SkUnichar character, ScFont &w) const;
    void toItalic(ScFont &w) const;
    ScFont withWeight(const ScFontStyle::Weight w) const;
    void withWeight(const ScFontStyle::Weight w, ScFont &font) const;

    static void getAllFontFamilies(void *array);
    static void getAllFontNames(void *array);

    //only use in swift, swift is not works with this call
    static ScString getFontName(const ScFont & font){
        return font.fontName();
    }
    static ScString getFamilyName(const ScFont & font){
        return font.familyName();
    }
    private:
    std::shared_ptr<SkFont>& getFont(){
        return internal._font.ref();
    }
    const std::shared_ptr<SkFont>& getFont() const{
        return internal._font.ref();
    }
    void configFont();
    struct ScFontInternal{
        ScValueNLimited<std::shared_ptr<SkFont>> _font;
    };
    ScFontInternal internal;
};
