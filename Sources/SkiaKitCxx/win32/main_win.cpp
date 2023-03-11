#include <windows.h>

#include <memory>
#include <cstdio>

#include "SkiaCxxPrivate.h"

using SC::Application;


int APIENTRY _tWinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPTSTR lpCmdLine,
                       int nCmdShow);

static bool isRunLoopStoped = false;
void Application::quit(){
    PostQuitMessage(0);
    isRunLoopStoped = true;
}
static VOID blockTimerAction(HWND, UINT, UINT_PTR, DWORD){
    Application::shared()->onIdle();
}
static UINT_PTR IDT_BlockTimer = 0x01;
void* g_AppPlatformData=nullptr;
void Application::run(){
    g_AppPlatformData = GetModuleHandle(nullptr);
    launchApp();

    MSG msg;
    memset(&msg, 0, sizeof(msg));

    printf("start PeekMessage loop\n");
    // Main message loop
    while (WM_QUIT != msg.message || !isRunLoopStoped) {
        if (PeekMessage(&msg, nullptr, 0, 0, PM_REMOVE)) {
            TranslateMessage(&msg);

            HWND timerWnd = nullptr;
            if (msg.message == WM_NCLBUTTONDOWN && msg.hwnd != nullptr){
                timerWnd = msg.hwnd;
                SetTimer(timerWnd, IDT_BlockTimer,  10,  (TIMERPROC) blockTimerAction);
            }
            DispatchMessage(&msg);
            if (timerWnd != nullptr){
                KillTimer(timerWnd, IDT_BlockTimer); 
            }
        }
        
        onIdle();
    }
}
