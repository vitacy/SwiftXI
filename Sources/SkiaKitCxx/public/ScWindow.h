#pragma once
#include "ScTypes.h"
#include "ScValue.h"
#include "ScString.h"
#include "ScRect.h"

struct ScWindowLayer;
class ScWindow{
public:
    ScWindow();
    ScWindow(const ScWindow&);
    ScWindow operator=(const ScWindow&);
    ~ScWindow();

    void setSwiftWindow(void *);
    void getSize(ScSize &) const;
    void setSize(const ScSize& size);

    void getTitle(ScString&) const;
    void setTitle(const ScString&);

    void getPosition(ScPoint& p);
    void setPosition(const ScPoint& p);

    void getContentRect(ScRect &) const;

    void show();
    void close();
    void inval();

    private:
    struct ScWindowInternal;
    ScWindowInternal *internal;
};
