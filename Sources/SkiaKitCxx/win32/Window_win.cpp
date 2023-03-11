/*
* Copyright 2016 Google Inc.
*
* Use of this source code is governed by a BSD-style license that can be
* found in the LICENSE file.
*/

#include "Window_win.h"

#include <tchar.h>
#include <windows.h>
#include <windowsx.h>

#include "src/utils/SkUTF.h"
#include "SkWindowContext.h"
#include "WindowContextFactory_win.h"
#include "ScModifierKey.h"

namespace SC {

static int gWindowX = 300;
static int gWindowY = 100;
static int gWindowWidth = 600;
static int gWindowHeight = 400;

Window* Window::CreateNativeWindow(void* platformData) {
    HINSTANCE hInstance = (HINSTANCE)platformData;

    Window_win* window = new Window_win();
    if (!window->init(hInstance)) {
        printf("init window failed\n");
        delete window;
        return nullptr;
    }

    return window;
}

void Window_win::closeWindow() {
    RECT r;
    if (GetWindowRect(fHWnd, &r)) {
        gWindowX = r.left;
        gWindowY = r.top;
        gWindowWidth = r.right - r.left;
        gWindowHeight = r.bottom - r.top;
    }
    DestroyWindow(fHWnd);
}

Window_win::~Window_win() {
    this->closeWindow();
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam);


bool Window_win::init(HINSTANCE hInstance) {
    // ImmDisableIME(0);
    fHInstance = hInstance ? hInstance : GetModuleHandle(nullptr);

    // The main window class name
    static const TCHAR gSZWindowClass[] = _T("SkiaApp");

    static WNDCLASSEX wcex;
    static bool wcexInit = false;
    if (!wcexInit) {
        wcex.cbSize = sizeof(WNDCLASSEX);

        wcex.style = CS_HREDRAW | CS_VREDRAW | CS_OWNDC;
        wcex.lpfnWndProc = WndProc;
        wcex.cbClsExtra = 0;
        wcex.cbWndExtra = 0;
        wcex.hInstance = fHInstance;
        wcex.hIcon = LoadIcon(fHInstance, (LPCTSTR)IDI_WINLOGO);
        wcex.hCursor = LoadCursor(nullptr, IDC_ARROW);
        wcex.hbrBackground = (HBRUSH)(COLOR_WINDOW + 1);
        wcex.lpszMenuName = nullptr;
        wcex.lpszClassName = gSZWindowClass;
        wcex.hIconSm = LoadIcon(fHInstance, (LPCTSTR)IDI_WINLOGO);

        if (!RegisterClassEx(&wcex)) {
            return false;
        }
        wcexInit = true;
    }

   /*
    if (fullscreen)
    {
        DEVMODE dmScreenSettings;
        // If full screen set the screen to maximum size of the users desktop and 32bit.
        memset(&dmScreenSettings, 0, sizeof(dmScreenSettings));
        dmScreenSettings.dmSize = sizeof(dmScreenSettings);
        dmScreenSettings.dmPelsWidth = (unsigned long)width;
        dmScreenSettings.dmPelsHeight = (unsigned long)height;
        dmScreenSettings.dmBitsPerPel = 32;
        dmScreenSettings.dmFields = DM_BITSPERPEL | DM_PELSWIDTH | DM_PELSHEIGHT;

        // Change the display settings to full screen.
        ChangeDisplaySettings(&dmScreenSettings, CDS_FULLSCREEN);

        // Set the position of the window to the top left corner.
        posX = posY = 0;
    }
    */
 //   gIsFullscreen = fullscreen;

    fHWnd = CreateWindow(gSZWindowClass, nullptr, WS_OVERLAPPEDWINDOW,
                         gWindowX, gWindowY, gWindowWidth, gWindowHeight,
                         nullptr, nullptr, fHInstance, nullptr);
    if (!fHWnd)
    {
        return false;
    }

    SetWindowLongPtr(fHWnd, GWLP_USERDATA, (LONG_PTR)this);
    RegisterTouchWindow(fHWnd, 0);

    return true;
}

static SC::Key get_key(WPARAM vk) {
    static const struct {
        WPARAM      fVK;
        SC::Key fKey;
    } gPair[] = {
        { VK_BACK,    SC::Key::kBack     },
        { VK_CLEAR,   SC::Key::kBack     },
        { VK_RETURN,  SC::Key::kOK       },
        { VK_UP,      SC::Key::kUp       },
        { VK_DOWN,    SC::Key::kDown     },
        { VK_LEFT,    SC::Key::kLeft     },
        { VK_RIGHT,   SC::Key::kRight    },
        { VK_TAB,     SC::Key::kTab      },
        { VK_PRIOR,   SC::Key::kPageUp   },
        { VK_NEXT,    SC::Key::kPageDown },
        { VK_HOME,    SC::Key::kHome     },
        { VK_END,     SC::Key::kEnd      },
        { VK_DELETE,  SC::Key::kDelete   },
        { VK_ESCAPE,  SC::Key::kEscape   },
        { VK_SHIFT,   SC::Key::kShift    },
        { VK_CONTROL, SC::Key::kCtrl     },
        { VK_MENU,    SC::Key::kOption   },
        { 'A',        SC::Key::kA        },
        { 'C',        SC::Key::kC        },
        { 'V',        SC::Key::kV        },
        { 'X',        SC::Key::kX        },
        { 'Y',        SC::Key::kY        },
        { 'Z',        SC::Key::kZ        },
    };
    for (size_t i = 0; i < std::size(gPair); i++) {
        if (gPair[i].fVK == vk) {
            return gPair[i].fKey;
        }
    }
    return SC::Key::kNONE;
}

static SC::ModifierKey get_modifiers(UINT message, WPARAM wParam, LPARAM lParam) {
    SC::ModifierKey modifiers = SC::ModifierKey::kNone;

    switch (message) {
        case WM_UNICHAR:
        case WM_CHAR:
            if (0 == (lParam & (1 << 30))) {
                modifiers |= SC::ModifierKey::kFirstPress;
            }
            if (lParam & (1 << 29)) {
                modifiers |= SC::ModifierKey::kOption;
            }
            break;

        case WM_KEYDOWN:
        case WM_SYSKEYDOWN:
            if (0 == (lParam & (1 << 30))) {
                modifiers |= SC::ModifierKey::kFirstPress;
            }
            if (lParam & (1 << 29)) {
                modifiers |= SC::ModifierKey::kOption;
            }
            break;

        case WM_KEYUP:
        case WM_SYSKEYUP:
            if (lParam & (1 << 29)) {
                modifiers |= SC::ModifierKey::kOption;
            }
            break;

        case WM_LBUTTONDOWN:
        case WM_LBUTTONUP:
        case WM_RBUTTONDOWN:
        case WM_RBUTTONUP:
        case WM_MOUSEMOVE:
        case WM_MOUSEWHEEL:
            if (wParam & MK_CONTROL) {
                modifiers |= SC::ModifierKey::kControl;
            }
            if (wParam & MK_SHIFT) {
                modifiers |= SC::ModifierKey::kShift;
            }
            break;
    }

    return modifiers;
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
    PAINTSTRUCT ps;

    Window_win* window = (Window_win*) GetWindowLongPtr(hWnd, GWLP_USERDATA);

    bool eventHandled = false;

    int deltaX = 0;
    int deltaY = 0;
    bool isScrollHorizontal = false;

    switch (message) {
        case WM_CREATE:
            eventHandled = true;
            break;
        case WM_PAINT:
            BeginPaint(hWnd, &ps);
            window->onPaint();
            EndPaint(hWnd, &ps);
            eventHandled = true;
            break;

        case WM_CLOSE:
            window->onClose();
            eventHandled = true;
            break;

        case WM_ACTIVATE:
            // disable/enable rendering here, depending on wParam != WA_INACTIVE
            break;

        case WM_SIZE:
            window->onResize(LOWORD(lParam), HIWORD(lParam));
            eventHandled = true;
            break;

        case WM_UNICHAR:
            eventHandled = window->onChar((SkUnichar)wParam,
                                          get_modifiers(message, wParam, lParam));
            break;

        case WM_CHAR: {
            const uint16_t* cPtr = reinterpret_cast<uint16_t*>(&wParam);
            SkUnichar c = SkUTF::NextUTF16(&cPtr, cPtr + 2);
            eventHandled = window->onChar(c, get_modifiers(message, wParam, lParam));
        } break;

        case WM_KEYDOWN:
        case WM_SYSKEYDOWN:
            eventHandled = window->onKey(get_key(wParam), SC::InputState::kDown,
                                         get_modifiers(message, wParam, lParam));
            break;

        case WM_KEYUP:
        case WM_SYSKEYUP:
            eventHandled = window->onKey(get_key(wParam), SC::InputState::kUp,
                                         get_modifiers(message, wParam, lParam));
                                         
            break;

        case WM_LBUTTONDOWN:
        case WM_LBUTTONUP: 
        case WM_RBUTTONDOWN:
        case WM_RBUTTONUP:{
                int xPos = GET_X_LPARAM(lParam);
                int yPos = GET_Y_LPARAM(lParam);
                
                SC::InputState istate = ((wParam & MK_LBUTTON) != 0) ? SC::InputState::kDown
                                                                        : SC::InputState::kUp;
                if (message == WM_RBUTTONDOWN || WM_RBUTTONDOWN==WM_RBUTTONUP){
                    istate = ((wParam & MK_RBUTTON) != 0) ? SC::InputState::kRightDown
                                                                        : SC::InputState::kRightUp;
                }

                eventHandled = window->onMouse(xPos, yPos, istate,
                                                get_modifiers(message, wParam, lParam));
            } 
            break;


        case WM_MOUSEMOVE: {
            int xPos = GET_X_LPARAM(lParam);
            int yPos = GET_Y_LPARAM(lParam);

            //if (!gIsFullscreen)
            //{
            //    RECT rc = { 0, 0, 640, 480 };
            //    AdjustWindowRect(&rc, WS_OVERLAPPEDWINDOW, FALSE);
            //    xPos -= rc.left;
            //    yPos -= rc.top;
            //}

            eventHandled = window->onMouse(xPos, yPos, SC::InputState::kMove,
                                           get_modifiers(message, wParam, lParam));
        } break;
        case WM_MOUSEHWHEEL:
            deltaX = GET_WHEEL_DELTA_WPARAM(wParam);
            isScrollHorizontal = true;
        case WM_MOUSEWHEEL:
            if (!isScrollHorizontal){
                deltaY = GET_WHEEL_DELTA_WPARAM(wParam);
            }
            {
                int xPos = GET_X_LPARAM(lParam);
                int yPos = GET_Y_LPARAM(lParam);
                POINT p{xPos, yPos};
                ScreenToClient(hWnd, &p);
                eventHandled = window->onMouseWheel(p.x, p.y, deltaX, deltaY,
                                                get_modifiers(message, wParam, lParam));
            }
        break;

        case WM_TOUCH: {
            uint16_t numInputs = LOWORD(wParam);
            std::unique_ptr<TOUCHINPUT[]> inputs(new TOUCHINPUT[numInputs]);
            if (GetTouchInputInfo((HTOUCHINPUT)lParam, numInputs, inputs.get(),
                                  sizeof(TOUCHINPUT))) {
                POINT topLeft = {0, 0};
                ClientToScreen(hWnd, &topLeft);
                for (uint16_t i = 0; i < numInputs; ++i) {
                    TOUCHINPUT ti = inputs[i];
                    SC::InputState state;
                    if (ti.dwFlags & TOUCHEVENTF_DOWN) {
                        state = SC::InputState::kDown;
                    } else if (ti.dwFlags & TOUCHEVENTF_MOVE) {
                        state = SC::InputState::kMove;
                    } else if (ti.dwFlags & TOUCHEVENTF_UP) {
                        state = SC::InputState::kUp;
                    } else {
                        continue;
                    }
                    // TOUCHINPUT coordinates are in 100ths of pixels
                    // Adjust for that, and make them window relative
                    LONG tx = (ti.x / 100) - topLeft.x;
                    LONG ty = (ti.y / 100) - topLeft.y;
                    eventHandled = window->onTouch(ti.dwID, state, tx, ty) || eventHandled;
                }
            }
        } break;

        default:
            return DefWindowProc(hWnd, message, wParam, lParam);
    }
    return eventHandled ? 0 : 1;
}

void Window_win::setTitle(const char* title) {
    SetWindowTextA(fHWnd, title);
}

void Window_win::show() {
    ShowWindow(fHWnd, SW_SHOW);
}
void Window_win::close(){
    closeWindow();
}
SkISize Window_win::getSize() const{
    RECT rect={0};
    GetWindowRect(fHWnd, &rect);
    int width = rect.right - rect.left;
    int height = rect.bottom - rect.top;
    return SkISize::Make(width, height);
}
void Window_win::resize(int width, int height) {
    auto point = getPosition();
    MoveWindow(fHWnd, point.fX, point.fY, width, height, false);
}
void Window_win::setPosition(int posX, int posY) {
    auto size = getSize();
    MoveWindow(fHWnd, posX, posY, size.fWidth, size.fHeight, false);
}
SkIPoint Window_win::getPosition() const  { 
    RECT rect={0};
    GetWindowRect(fHWnd, &rect);
    return SkIPoint::Make(rect.left, rect.top);
}
SkIRect Window_win::getContentRect() const{
    RECT rect={0};
    GetClientRect(fHWnd, &rect);
    int width = rect.right - rect.left;
    int height = rect.bottom - rect.top;
    return SkIRect::MakeWH(width, height);
}

void Window_win::setInputMethodStatus(bool enable){
    auto imc = ImmGetContext(fHWnd);
    if (imc){
        ImmSetOpenStatus(imc, enable);
        ImmReleaseContext(fHWnd, imc);
    }
}

bool Window_win::attach(BackendType attachType) {
    fBackend = attachType;
    fInitializedBackend = true;

    switch (attachType) {
#ifdef SK_GL
        case kNativeGL_BackendType:
            fWindowContext = window_context_factory::MakeGLForWin(fHWnd, fRequestedDisplayParams);
            break;
#endif
#if SK_ANGLE
        case kANGLE_BackendType:
            fWindowContext =
                    window_context_factory::MakeANGLEForWin(fHWnd, fRequestedDisplayParams);
            break;
#endif
#ifdef SK_DAWN
        case kDawn_BackendType:
            fWindowContext =
                    window_context_factory::MakeDawnD3D12ForWin(fHWnd, fRequestedDisplayParams);
            break;
#ifdef SK_GRAPHITE_ENABLED
        case kGraphiteDawn_BackendType:
            fWindowContext = window_context_factory::MakeGraphiteDawnD3D12ForWin(
                    fHWnd, fRequestedDisplayParams);
            break;
#endif
#endif
        case kRaster_BackendType:
            fWindowContext =
                    window_context_factory::MakeRasterForWin(fHWnd, fRequestedDisplayParams);
            break;
#ifdef SK_VULKAN
        case kVulkan_BackendType:
            fWindowContext =
                    window_context_factory::MakeVulkanForWin(fHWnd, fRequestedDisplayParams);
            break;
#endif
#ifdef SK_DIRECT3D
        case kDirect3D_BackendType:
            fWindowContext =
                window_context_factory::MakeD3D12ForWin(fHWnd, fRequestedDisplayParams);
            break;
#endif
    }
    this->onBackendCreated();

    return (SkToBool(fWindowContext));
}

void Window_win::onInval() {
    InvalidateRect(fHWnd, nullptr, false);
}

void Window_win::setRequestedDisplayParams(const DisplayParams& params, bool allowReattach) {
    // GL on Windows doesn't let us change MSAA after the window is created
    if (params.fMSAASampleCount != this->getRequestedDisplayParams().fMSAASampleCount
            && allowReattach) {
        // Need to change these early, so attach() creates the window context correctly
        fRequestedDisplayParams = params;

        fWindowContext = nullptr;
        this->closeWindow();
        this->init(fHInstance);
        if (fInitializedBackend) {
            this->attach(fBackend);
        }
    }

    INHERITED::setRequestedDisplayParams(params, allowReattach);
}

}   // namespace sk_app
