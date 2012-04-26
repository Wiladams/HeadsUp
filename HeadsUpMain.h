#pragma once

#define DllExport __declspec(dllexport)
#define DllImport __declspec(dllimport)

#define WIN32_LEAN_AND_MEAN

#include <windows.h>
#include <gl\gl.h>
#include <gl\glu.h>
#include "include/wglext.h"
#include "include/glext.h"

#include <assert.h>
#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

#include "include\lua.h"
#include "include\lauxlib.h"
#include "include\lualib.h"

typedef void (*OnIdleDelegate)();
typedef void (*OnResizedDelegate)(int newWidth, int newHeight);
typedef void (*OnTickDelegate)(int tickCount);
typedef void (*MsgReceiver)(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

DllExport int RegisterIdleDelegate(OnIdleDelegate delegate);
DllExport int RegisterTickDelegate(OnTickDelegate delegate);
DllExport int RegisterKeyboardMouse(MsgReceiver receiver);
DllExport int RegisterResizingDelegate(OnResizedDelegate delegate);
DllExport int RegisterResizedDelegate(OnResizedDelegate delegate);

DllExport double GetCurrentTickTime();
DllExport int SwapGLBuffers(void);

#ifdef __cplusplus
}
#endif
