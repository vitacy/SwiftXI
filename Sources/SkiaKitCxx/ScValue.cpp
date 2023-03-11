#include "ScValue.h"
#include "SkiaCxxPrivate.h"

template<typename T>
ScValue<T>::ScValue(){_ref = new T();};

template<typename T>
    ScValue<T>::~ScValue(){ delete _ref;};

template<typename T>
ScValue<T>::ScValue(const ScValue& v):ScValue{}{
    *this = v;
};

template<typename T>
ScValue<T>& ScValue<T>::operator=(const ScValue<T>& v){
    *this = v.ref();
    return *this;
}

template<typename T>
ScValue<T>::ScValue(const T &t){
    _ref = new T(t);
}

template<typename T>
ScValue<T>& ScValue<T>::operator=(const T& t){
    ref() = t;
    return *this;
}


template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>::ScValueN(){
    new(&ref()) T();
}

template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>::~ScValueN(){
    ref().~T();
}

template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>::ScValueN(const ScValueN<T, N, Align>& v):ScValueN{v.ref()}{
}
template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>::ScValueN(ScValueN<T, N, Align>&& v):ScValueN{std::forword<T&&>(v.ref())}{
}
template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>::ScValueN(const T &t){
    new(&ref()) T(t);
}
template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>::ScValueN(T &&t){
    new(&ref()) T(std::forword<T&&>(t));
}

template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>& ScValueN<T, N, Align>::operator=(const ScValueN<T, N, Align>& v){
    ref() = v.ref();
    return *this;
}
template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>& ScValueN<T, N, Align>::operator=(ScValueN<T, N, Align>&& v){
    ref() = std::forword<T&&>(v.ref());
    return *this;
}

template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>& ScValueN<T, N, Align>::operator=(const T& t){
    ref() = t;
    return *this;
}
template<typename T, size_t N, size_t Align>
ScValueN<T, N, Align>& ScValueN<T, N, Align>::operator=(T&& t){
    ref() = std::forword<T&&>(t);
    return *this;
}

template<typename T>
void _scValue_link_fixed_type(){
    static_assert(std::is_same_v<ScValueN<T>, ScValueN<T, ScValueLimit<T>::Size, ScValueLimit<T>::Align>>, "type must equle");

    ScValueN<T, sizeof(T)> t;
    auto t1(t);
    auto t2=t;
}

void _scValue_link_fixed(){
    _scValue_link_fixed_type<SkString>();
    _scValue_link_fixed_type<SkBitmap>();
    _scValue_link_fixed_type<sk_sp<SkImage>>();
    _scValue_link_fixed_type<sk_sp<SkData>>();
    _scValue_link_fixed_type<SkImageInfo>();
    _scValue_link_fixed_type<ScPaint>();
    _scValue_link_fixed_type<ScPath>();
    _scValue_link_fixed_type<std::shared_ptr<SkFont>>();
    
}