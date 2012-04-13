#pragma once

#define DllExport __declspec(dllexport)
#define DllImport __declspec(dllimport)

#ifdef __cplusplus
extern "C" {
#endif

#include <stddef.h>

typedef void (*OnResizedDelegate)(int newWidth, int newHeight);
typedef void (*OnTickDelegate)(int tickCount);
typedef void (*MsgReceiver)(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

DllExport int RegisterTickDelegate(OnTickDelegate delegate);
DllExport int RegisterKeyboardMouse(MsgReceiver receiver);
DllExport int RegisterResizedDelegate(OnResizedDelegate delegate);



#ifdef __cplusplus
}
#endif
