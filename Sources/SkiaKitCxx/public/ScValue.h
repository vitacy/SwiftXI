#pragma once


template<typename T>
class ScValue{
public:
    ScValue();
    ~ScValue();

    ScValue(const ScValue& v);
    ScValue& operator=(const ScValue& v);

    ScValue(ScValue&& v)=delete;
    ScValue& operator=(ScValue&& v)=delete;

    ScValue(const T &);
    ScValue& operator=(const T& t);

    T& ref(){return *_ref;};
    const T& ref() const{return *_ref;};
private:
    T *_ref;
};

template<typename T>
struct ScValueLimit{
static size_t constexpr Align = alignof(T);
static size_t constexpr Size = sizeof(T);
};

template<typename T, size_t N = sizeof(T), size_t Align = alignof(T)>
class ScValueN{
public:
    ScValueN();
    ~ScValueN();

    ScValueN(const ScValueN& v);
    ScValueN(ScValueN&& v);
    ScValueN(const T &);
    ScValueN(T &&);

    ScValueN& operator=(const ScValueN& v);
    ScValueN& operator=(ScValueN&& v);
    ScValueN& operator=(const T& t);
    ScValueN& operator=(T&& t);

    T& ref(){return *reinterpret_cast<T*>(&_data[0]);};
    const T& ref() const{return *reinterpret_cast<const T*>(&_data[0]);};
private:
    alignas(Align) unsigned char _data[N];
};

template<typename T>
using ScValueNLimited = ScValueN<T, ScValueLimit<T>::Size, ScValueLimit<T>::Align>;

