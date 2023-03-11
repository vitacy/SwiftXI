#pragma once

#include "ScTypes.h"
#include "ScValue.h"
#include "ScRect.h"

class SkImage;
class SkBitmap;
class SkData;
class SkImageInfo;

template<typename T>
class sk_sp;

template<>
struct ScValueLimit<sk_sp<SkImage>>{
static constexpr size_t Align = 8;
static constexpr size_t Size = 8;
};

template<>
struct ScValueLimit<SkBitmap>{
static constexpr size_t Align = 8;
static constexpr size_t Size = 56;
};

template<>
struct ScValueLimit<sk_sp<SkData>>{
static constexpr size_t Align = 8;
static constexpr size_t Size = 8;
};

template<>
struct ScValueLimit<SkImageInfo>{
static constexpr size_t Align = 8;
static constexpr size_t Size = 24;
};

enum class ScColorType : int {
    kUnknown_SkColorType,      //!< uninitialized
    kAlpha_8_SkColorType,      //!< pixel with alpha in 8-bit byte
    kRGB_565_SkColorType,      //!< pixel with 5 bits red, 6 bits green, 5 bits blue, in 16-bit word
    kARGB_4444_SkColorType,    //!< pixel with 4 bits for alpha, red, green, blue; in 16-bit word
    kRGBA_8888_SkColorType,    //!< pixel with 8 bits for red, green, blue, alpha; in 32-bit word
    kRGB_888x_SkColorType,     //!< pixel with 8 bits each for red, green, blue; in 32-bit word
    kBGRA_8888_SkColorType,    //!< pixel with 8 bits for blue, green, red, alpha; in 32-bit word
    kRGBA_1010102_SkColorType, //!< 10 bits for red, green, blue; 2 bits for alpha; in 32-bit word
    kBGRA_1010102_SkColorType, //!< 10 bits for blue, green, red; 2 bits for alpha; in 32-bit word
    kRGB_101010x_SkColorType,  //!< pixel with 10 bits each for red, green, blue; in 32-bit word
    kBGR_101010x_SkColorType,  //!< pixel with 10 bits each for blue, green, red; in 32-bit word
    kGray_8_SkColorType,       //!< pixel with grayscale level in 8-bit byte
    kRGBA_F16Norm_SkColorType, //!< pixel with half floats in [0,1] for red, green, blue, alpha;
                               //   in 64-bit word
    kRGBA_F16_SkColorType,     //!< pixel with half floats for red, green, blue, alpha;
                               //   in 64-bit word
    kRGBA_F32_SkColorType,     //!< pixel using C float for red, green, blue, alpha; in 128-bit word

    // The following 6 colortypes are just for reading from - not for rendering to
    kR8G8_unorm_SkColorType,         //!< pixel with a uint8_t for red and green

    kA16_float_SkColorType,          //!< pixel with a half float for alpha
    kR16G16_float_SkColorType,       //!< pixel with a half float for red and green

    kA16_unorm_SkColorType,          //!< pixel with a little endian uint16_t for alpha
    kR16G16_unorm_SkColorType,       //!< pixel with a little endian uint16_t for red and green
    kR16G16B16A16_unorm_SkColorType, //!< pixel with a little endian uint16_t for red, green, blue
                                     //   and alpha

    kSRGBA_8888_SkColorType,
    kR8_unorm_SkColorType,

    kLastEnum_SkColorType     = kR8_unorm_SkColorType, //!< last valid value
};
enum class ScAlphaType : int {
    kUnknown_SkAlphaType,                          //!< uninitialized
    kOpaque_SkAlphaType,                           //!< pixel is opaque
    kPremul_SkAlphaType,                           //!< pixel components are premultiplied by alpha
    kUnpremul_SkAlphaType,                         //!< pixel components are independent of alpha
    kLastEnum_SkAlphaType = kUnpremul_SkAlphaType, //!< last valid value
};

class ScImageInfo: public ScValueNLimited<SkImageInfo>{
public:
    ScImageInfo();
    ScImageInfo(const ScImageInfo&);
    ~ScImageInfo();
    static ScImageInfo Make(int width, int height, ScColorType ct, ScAlphaType at);
};
class ScData;
class ScImage: public ScValueN<sk_sp<SkImage>, ScValueLimit<sk_sp<SkImage>>::Size, ScValueLimit<sk_sp<SkImage>>::Align>{
    public:
    ScImage();
    ScImage(const ScImage&);
    ~ScImage();

    ScImage(const ScData&);
    bool isValid() const;

    SkScalar width() const ;
    SkScalar height() const ;
};

class ScBitmap: public ScValueN<SkBitmap, ScValueLimit<SkBitmap>::Size, ScValueLimit<SkBitmap>::Align>{
public:
    ScBitmap();
    ScBitmap(const ScBitmap&);
    ~ScBitmap();

    SkScalar width() const ;
    SkScalar height() const ;

    bool installPixels(const ScImageInfo& info, void* pixels, size_t rowBytes, void (*releaseProc)(void* addr, void* context), void* context);
    void setImmutable();
};
class ScData: public ScValueNLimited<sk_sp<SkData>>{
    public:
    ScData();
    ScData(const ScData&);
    ~ScData();

    typedef void (*ReleaseProc)(const void* ptr, void* context);
    ScData(const void* ptr, size_t length, ReleaseProc proc, void* ctx);
};