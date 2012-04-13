#define WIN32_LEAN_AND_MEAN

#include <windows.h>

#include <signal.h>
#include <stdlib.h>
#include <string.h>
#include <tchar.h>

#include "HeadsUpMain.h"

#ifdef __cplusplus
extern "C" {
#endif

#include "include\lua.h"
#include "include\lauxlib.h"
#include "include\lualib.h"

#ifdef __cplusplus
}
#endif


LRESULT CALLBACK WndProc(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

static TCHAR szWindowClass[] = _T("win32app");
static TCHAR szTitle[] = _T("Heads Up");

int argc = __argc;
char ** argv = __argv;

BOOL IsRunning = FALSE;
HDC hWndDC;
lua_State *globalL;

OnResizedDelegate gResizedDelegate = NULL;
OnTickDelegate tickDelegate = NULL;
MsgReceiver gKeyboardMouse = NULL;

extern "C"
int RegisterTickDelegate(OnTickDelegate delegate)
{
	tickDelegate = delegate;

	return 0;
}

extern "C"
int RegisterKeyboardMouse(MsgReceiver receiver)
{
	gKeyboardMouse = receiver;

	return 0;
}

extern "C"
int RegisterResizedDelegate(OnResizedDelegate delegate)
{
	gResizedDelegate = delegate;
	return 0;
 }


ATOM HUPRegisterWindowClass(HINSTANCE hInst, char *wndclassname)
{
	ATOM classAtom;
	WNDCLASSEX wcex;

    wcex.cbSize = sizeof(WNDCLASSEX);
    wcex.style          = CS_HREDRAW | CS_VREDRAW | CS_OWNDC;
    wcex.lpfnWndProc    = WndProc;
    wcex.cbClsExtra     = 0;
    wcex.cbWndExtra     = 0;
    wcex.hInstance      = hInst;
    wcex.hIcon          = LoadIcon(hInst, MAKEINTRESOURCE(IDI_APPLICATION));
    wcex.hCursor        = LoadCursor(NULL, IDC_ARROW);
    wcex.hbrBackground  = (HBRUSH)(COLOR_WINDOW+1);
    wcex.lpszMenuName   = NULL;
    wcex.lpszClassName  = wndclassname;
    wcex.hIconSm        = LoadIcon(wcex.hInstance, MAKEINTRESOURCE(IDI_APPLICATION));

	classAtom = RegisterClassEx(&wcex);

	if (!classAtom)
    {
        MessageBox(NULL,
            _T("Call to RegisterClassEx failed!"),
            _T("Win32 Guided Tour"),
            0);

        return 1;
    }

	return classAtom;
}

HWND HUPCreateWindow(HINSTANCE hInst, char *winclass, char *wintitle, int width, int height)
{
	HWND hWnd = CreateWindow(
		winclass,
		wintitle,
		WS_OVERLAPPEDWINDOW,
		CW_USEDEFAULT, CW_USEDEFAULT,
		width, height,
		NULL,	/* parent window handle */
		NULL,	/* menu bar handle */
		hInst,	/* app instance handle */
		NULL
	);

	return hWnd;
}

HGLRC HUPCreateGLContext(HWND hWnd)
{
    HDC hDC;
    HGLRC hRC;
    PIXELFORMATDESCRIPTOR pfd;
    int pixelFormat;

	// Get a handle on the device context for the window
	hDC = GetDC(hWnd);

	    // Create the GL context.
    ZeroMemory(&pfd, sizeof(pfd));
    pfd.nSize = sizeof(pfd);
    pfd.nVersion = 1;
//    pfd.dwFlags = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL;
    pfd.dwFlags = PFD_DRAW_TO_WINDOW | PFD_SUPPORT_OPENGL | PFD_DOUBLEBUFFER;
    pfd.iPixelType = PFD_TYPE_RGBA;
    pfd.cColorBits = 32;
    pfd.cDepthBits = 24;
    pfd.cStencilBits = 8;
    pfd.iLayerType = PFD_MAIN_PLANE;

	pixelFormat = ChoosePixelFormat(hDC, &pfd);

	SetPixelFormat(hDC, pixelFormat, &pfd);
    hRC = wglCreateContext(hDC);

	return hRC;
}

static void l_message(const char *pname, const char *msg)
{
  if (pname) fprintf(stderr, "%s: ", pname);
  fprintf(stderr, "%s\n", msg);
  fflush(stderr);
}

static int report(lua_State *L, int status)
{
  if (status && !lua_isnil(L, -1)) {
    const char *msg = lua_tostring(L, -1);
    if (msg == NULL) msg = "(error object is not a string)";
    l_message("HeadsUp", msg);
    lua_pop(L, 1);
  }
  return status;
}

static int traceback(lua_State *L)
{
  if (!lua_isstring(L, 1))  /* 'message' not a string? */
    return 1;  /* keep it intact */
  lua_getfield(L, LUA_GLOBALSINDEX, "debug");
  if (!lua_istable(L, -1)) {
    lua_pop(L, 1);
    return 1;
  }
  lua_getfield(L, -1, "traceback");
  if (!lua_isfunction(L, -1)) {
    lua_pop(L, 2);
    return 1;
  }
  lua_pushvalue(L, 1);  /* pass error message */
  lua_pushinteger(L, 2);  /* skip this function and traceback */
  lua_call(L, 2, 1);  /* call debug.traceback */
  return 1;
}

static void lstop(lua_State *L, lua_Debug *ar)
{
  (void)ar;  /* unused arg. */
  lua_sethook(L, NULL, 0, 0);
  /* Avoid luaL_error -- a C hook doesn't add an extra frame. */
  luaL_where(L, 0);
  lua_pushfstring(L, "%sinterrupted!", lua_tostring(L, -1));
  lua_error(L);
}

static void laction(int i)
{
  signal(i, SIG_DFL); /* if another SIGINT happens before lstop,
			 terminate process (default action) */
  lua_sethook(globalL, lstop, LUA_MASKCALL | LUA_MASKRET | LUA_MASKCOUNT, 1);
}

static int docall(lua_State *L, int narg, int clear)
{
  int status;
  int base = lua_gettop(L) - narg;  /* function index */
  lua_pushcfunction(L, traceback);  /* push traceback function */
  lua_insert(L, base);  /* put it under chunk and args */
  signal(SIGINT, laction);
  status = lua_pcall(L, narg, (clear ? 0 : LUA_MULTRET), base);
  signal(SIGINT, SIG_DFL);
  lua_remove(L, base);  /* remove traceback function */

  /* force a complete garbage collection in case of errors */
  if (status != 0) lua_gc(L, LUA_GCCOLLECT, 0);

  return status;
}

static int dofile(lua_State *L, const char *name)
{
  int status = luaL_loadfile(L, name) || docall(L, 0, 1);

  return report(L, status);
}

static int dostring(lua_State *L, const char *s, const char *name)
{
  int status = luaL_loadbuffer(L, s, strlen(s), name) || docall(L, 0, 1);
  return report(L, status);
}

static int dolibrary(lua_State *L, const char *name)
{
  lua_getglobal(L, "require");
  lua_pushstring(L, name);
  return report(L, docall(L, 1, 1));
}

int GetAppPath(char *buff, int bufflen)
{
	HMODULE hModule = GetModuleHandle(NULL);
	int maxchars = GetModuleFileName(hModule, buff, bufflen);
	buff[maxchars] = '\0';

	char * lastChar = strrchr(buff, '\\');
	if (lastChar != NULL)
		*lastChar = '\0';

	return maxchars;
}

lua_State * HUPCreateLuaState()
{
	char startupbuff[MAX_PATH];
	int startupbufflen=0;
	char appdir[MAX_PATH];
	int appdirlen = 0;
	char *fname = argv[1];
	int argidx = 1;

	appdirlen = GetAppPath(appdir, MAX_PATH);
//	printf("HeadUp Application Directory: %s\n", appdir);

	lua_State *L = lua_open();  // create state

	if (L == NULL) {
		l_message("HeadsUp", "cannot create state: not enough memory");
		return NULL;
	}

	globalL = L;

	// stop collector during initialization
	lua_gc(L, LUA_GCSTOP, 0);
	luaL_openlibs(L);
	lua_gc(L, LUA_GCRESTART, -1);

	// Load in whatever scripts we want to load
	// Create a table with the filename
	// as the argument.

	lua_newtable(L);

	// Add the application directory as the first item
	lua_pushnumber(L, 1);
	lua_pushstring(L, appdir);
	lua_settable(L,-3);

	// Add the script filename as the
	// second argv
	if (fname != NULL)
	{
//printf("Filename: %s\n", fname);
		lua_pushnumber(L, 2);
		lua_pushstring(L, fname);
		lua_settable(L,-3);
	}
	lua_setglobal(L, "arg");

	startupbufflen = sprintf(startupbuff, "%s\\%s", appdir, "StartUp.lua");
	startupbuff[startupbufflen] = '\0';
	// Execute the startup script
	//dolibrary(L, "HeadsUp.lua");
	dofile(L, startupbuff);
	//dostring(L, luaJIT_BC_StartUp, "luaJIT_BC_StartUp");

	return NULL;
}

int OnTick(int tickCount)
{
	// Call application's OnTick
	// if registered
	if (tickDelegate != NULL) {
		tickDelegate(tickCount);
	}

	// Swap GL Buffers
	SwapBuffers(hWndDC);

	return 0;
}

int OnKeyboardMouse(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	if (gKeyboardMouse != NULL) {
		gKeyboardMouse(hWnd, message, wParam, lParam);
	}

	return 0;
}

int OnWindowResized(int newWidth, int newHeight)
{
	if (gResizedDelegate != NULL) {
		gResizedDelegate(newWidth, newHeight);
	}

	return 0;
}


int Run()
{
	MSG msg;
	BOOL bRet;

	// Create event for doing some waiting
	HANDLE timerEvent = CreateEvent(NULL, FALSE, FALSE, NULL);
	int handleCount = 1;
	HANDLE handles[] = {timerEvent};

	int dwFlags = MWMO_ALERTABLE|MWMO_INPUTAVAILABLE;
	int timeleft = 1000/30;	// 30 frames per second
	int tickCount = 1;

	IsRunning = TRUE;
	while (IsRunning)
	{
		while ((bRet = PeekMessage(&msg, NULL, 0, 0, PM_REMOVE) != 0))
		{
			if (bRet == -1)
			{
			// handle the error and possibly exit
			} else
			{
				BOOL success = TranslateMessage(&msg);
				LRESULT result = DispatchMessage(&msg);
			}
		}

		if (timeleft < 0)
		{
			timeleft = 0;
		}

		// use an alertable wait
		MsgWaitForMultipleObjectsEx(handleCount, handles, timeleft, QS_ALLEVENTS, dwFlags);

		OnTick(tickCount);
		tickCount = tickCount + 1;
	}

    return (int) msg.wParam;
}

LRESULT CALLBACK WndProc(HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam)
{
	int newWidth;
	int newHeight;

 	if (((message >= WM_MOUSEFIRST) && (message <= WM_MOUSELAST)) || ((message >= WM_NCMOUSEMOVE) && (message <= WM_NCMBUTTONDBLCLK)))
	{
		OnKeyboardMouse(hWnd, message, wParam, lParam);
	}

	if ((message >= WM_KEYDOWN) && (message <= WM_SYSCOMMAND))
	{
		OnKeyboardMouse(hWnd, message, wParam, lParam);
	}

	switch (message)
    {
		case WM_DESTROY:
			IsRunning = FALSE;
			PostQuitMessage(0);
        break;

		case WM_SIZE:
			newWidth = LOWORD(lParam);
			newHeight = HIWORD(lParam);
			OnWindowResized(newWidth, newHeight);
		break;

		default:
			return DefWindowProc(hWnd, message, wParam, lParam);
        break;
    }

    return 0;
}



int main(int argc, char **argv)
{
printf("main argc, argv: %d %d\n", argc, argv);
	int err = 0;
	ATOM cAtom;
	HWND hWnd;
	HGLRC hRC;
	lua_State * L;

	HINSTANCE hInstance = GetModuleHandle(NULL);

	cAtom = HUPRegisterWindowClass(hInstance, szWindowClass);

	hWnd = HUPCreateWindow(hInstance, szWindowClass, szTitle, 640, 480);

	if (!hWnd)
	{
	MessageBox(NULL,
			_T("Call to CreateWindow failed!"),
			_T("Win32 Guided Tour"),
			0);

		return 1;
	}


	// Create a GL Context
	// and attach it to the DC
	hRC = HUPCreateGLContext(hWnd);
	hWndDC = GetDC(hWnd);
	wglMakeCurrent(hWndDC, hRC);


	L = HUPCreateLuaState();

	// Do the show after lua state is
	// created to ensure window resize
	// is passed along
	ShowWindow(hWnd, SW_SHOW);
	UpdateWindow(hWnd);

	err = Run();

	return err;
}

/*
int WINAPI WinMain(HINSTANCE hInstance, HINSTANCE hPrevInstance, LPSTR cmdLine, int nCmdShow)
{
	return main(__argc, __argv);
}
*/
