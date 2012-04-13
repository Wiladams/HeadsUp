local ffi = require"ffi"
local C = ffi.C
local bit = require"bit"
local bor = bit.bor

local gl = require"gl"

require "win_gdi32"
require "win_kernel32"

local gdi32 = ffi.load("gdi32")
local wgl = ffi.load("opengl32")
local kernel32 = ffi.load("kernel32")

ffi.cdef[[
/* Constants for wglGetPixelFormatAttribivARB */
enum {
WGL_NUMBER_PIXEL_FORMATS_ARB    =0x2000,
WGL_DRAW_TO_WINDOW_ARB          =0x2001,
WGL_SUPPORT_OPENGL_ARB          =0x2010,
WGL_ACCELERATION_ARB            =0x2003,
WGL_DOUBLE_BUFFER_ARB           =0x2011,
WGL_STEREO_ARB                  =0x2012,
WGL_PIXEL_TYPE_ARB              =0x2013,
WGL_COLOR_BITS_ARB              =0x2014,
WGL_RED_BITS_ARB                =0x2015,
WGL_GREEN_BITS_ARB              =0x2017,
WGL_BLUE_BITS_ARB               =0x2019,
WGL_ALPHA_BITS_ARB              =0x201B,
WGL_ACCUM_BITS_ARB              =0x201D,
WGL_ACCUM_RED_BITS_ARB          =0x201E,
WGL_ACCUM_GREEN_BITS_ARB        =0x201F,
WGL_ACCUM_BLUE_BITS_ARB         =0x2020,
WGL_ACCUM_ALPHA_BITS_ARB        =0x2021,
WGL_DEPTH_BITS_ARB              =0x2022,
WGL_STENCIL_BITS_ARB            =0x2023,
WGL_AUX_BUFFERS_ARB             =0x2024,
WGL_SAMPLE_BUFFERS_ARB          =0x2041,
WGL_SAMPLES_ARB                 =0x2042,
}

/* Constants for WGL_ACCELERATION_ARB */
enum {
	WGL_NO_ACCELERATION_ARB         =0x2025,
	WGL_GENERIC_ACCELERATION_ARB    =0x2026,
	WGL_FULL_ACCELERATION_ARB       =0x2027,
}

/* Constants for WGL_PIXEL_TYPE_ARB */
enum {
	WGL_TYPE_RGBA_ARB               =0x202B,
	WGL_TYPE_COLORINDEX_ARB         =0x202C,
}
]]

-- Definitions for Wgl (Windows GL)
ffi.cdef[[
	// Callback functions

	typedef int (__attribute__((__stdcall__)) *PROC)();

	BOOL wglCopyContext(HGLRC hglrcSrc, HGLRC hglrcDst, UINT  mask);

	HGLRC wglCreateContext(HDC hdc);

	HGLRC wglCreateLayerContext(HDC hdc, int  iLayerPlane);

	BOOL wglDeleteContext(HGLRC  hglrc);

	BOOL wglDescribeLayerPlane(HDC hdc,int  iPixelFormat, int  iLayerPlane, UINT  nBytes, LPLAYERPLANEDESCRIPTOR plpd);

	HGLRC wglGetCurrentContext(void);

	HDC wglGetCurrentDC(void);

	int wglGetLayerPaletteEntries(HDC  hdc, int  iLayerPlane, int  iStart,int  cEntries, const COLORREF *pcr);

	PROC wglGetProcAddress(LPCSTR lpszProc);

	BOOL wglMakeCurrent(HDC hdc, HGLRC  hglrc);

	BOOL wglRealizeLayerPalette(HDC hdc, int iLayerPlane, BOOL bRealize);

	int wglSetLayerPaletteEntries(HDC  hdc, int iLayerPlane,int  iStart,int  cEntries, const COLORREF *pcr);

	BOOL wglShareLists(HGLRC  hglrc1, HGLRC  hglrc2);

	BOOL wglSwapLayerBuffers(HDC hdc, UINT  fuPlanes);

	BOOL wglUseFontBitmapsA(HDC  hdc, DWORD  first, DWORD  count, DWORD listBase);
	BOOL wglUseFontBitmapsW(HDC  hdc, DWORD  first, DWORD  count, DWORD listBase);

	BOOL wglUseFontOutlinesA(HDC  hdc,DWORD  first, DWORD  count, DWORD  listBase,  FLOAT  deviation, FLOAT  extrusion,int  format, LPGLYPHMETRICSFLOAT  lpgmf);
	BOOL wglUseFontOutlinesW(HDC  hdc,DWORD  first, DWORD  count, DWORD  listBase,  FLOAT  deviation, FLOAT  extrusion,int  format, LPGLYPHMETRICSFLOAT  lpgmf);

	// Extension functions
	// WGL_ARB_extensions_string
	typedef const char * (* PFNWGLGETEXTENSIONSSTRINGARBPROC)(HDC);

	const char *wglGetExtensionsStringARB(HDC);


]]

ffi.cdef[[
typedef struct {
	HDC		GDIHandle;
	HGLRC	GLHandle;
	HWND	WindowHandle;
} GLContext;
]]

GDIGL = {
	ChoosePixelFormat   = ffi.cast("PFNCHOOSEPIXELFORMAT", GetProcAddress("gdi32", "ChoosePixelFormat"));
    DescribePixelFormat = ffi.cast("PFNDESCRIBEPIXELFORMAT", GetProcAddress( "gdi32", "DescribePixelFormat"));
    --GetPixelFormat      = ffi.cast("PFNGETPIXELFORMAT", kernel32.GetProcAddress( "gdi32", "GetPixelFormat"));
    SetPixelFormat      = ffi.cast("PFNSETPIXELFORMAT", GetProcAddress( "gdi32", "SetPixelFormat"));
    SwapBuffers         = ffi.cast("PFNSWAPBUFFERS", GetProcAddress( "gdi32", "SwapBuffers"));
}




GLContext = nil
GLContext_mt = {
	__tostring = function(self)
		return string.format("GLContext(GDI: 0x%s\nGL: 0x%s\nVendor: %s\nVersion: %s)",
			tostring(self.GDIHandle),
			tostring(self.GLHandle),
			self.Vendor(),
			self.Version())
	end,

	__index = {
		TypeName = "GLContext",

		Size = ffi.sizeof("GLContext"),

		Vendor = function(self)
			return ffi.string(gl.glGetString(gl.GL_VENDOR))
		end,

		Version = function(self)
			return ffi.string(gl.glGetString(gl.GL_VERSION))
		end,

		Renderer = function(self)
			return ffi.string(gl.glGetString(gl.GL_RENDERER))
		end,

		Attach = function(self)
			local result = wgl.wglMakeCurrent(self.GDIHandle, self.GLHandle);
			return result
		end,

		Detach = function(self)
			local result = wgl.wglMakeCurrent(self.GDIHandle, nil);
			return result
		end,

		Destroy = function(self)
			result = wgl.wglMakeCurrent(self.GDIHandle, nil);
			wgl.wglDeleteContext(self.GLHandle);
		end,
	}
}
GLContext = ffi.metatype("GLContext", GLContext_mt)

function CreateGLContextFromDC(hwnd, hdc, flags)
	-- Now create a pixel format descriptor that is appropriate
	-- for GL.  Mainly it's in the flags passed in.
	flags = flags or 0
	local ColorBits = 32
	local DepthBits = 16

	-- Initialize the data structure
	local pfd = ffi.new("PIXELFORMATDESCRIPTOR");
	pfd.nSize = ffi.sizeof("PIXELFORMATDESCRIPTOR")
	pfd.nVersion = 1

	pfd.dwFlags = bor(flags,C.PFD_SUPPORT_OPENGL);   -- Put in 'SupportOpenGL' so at least there is OpenGL support
	pfd.iPixelType = C.PFD_TYPE_RGBA;
	pfd.cColorBits = ColorBits;                        			-- How many bits used for color
	pfd.cDepthBits = DepthBits;					-- How many bits used for depth buffer
	pfd.iLayerType = C.PFD_MAIN_PLANE;

---[[
			pfd.cRedBits = 0;
			pfd.cRedShift = 0;
			pfd.cGreenBits = 0;
			pfd.cGreenShift = 0;
			pfd.cBlueBits = 0;
			pfd.cBlueShift = 0;
			pfd.cAlphaBits = 0;
			pfd.cAlphaShift = 0;
			pfd.cAccumBits = 0;
			pfd.cAccumRedBits = 0;
			pfd.cAccumGreenBits = 0;
			pfd.cAccumBlueBits = 0;
			pfd.cAccumAlphaBits = 0;
			pfd.cStencilBits = 0;
			pfd.cAuxBuffers = 0;
			pfd.bReserved = 0;
			pfd.dwLayerMask = 0;
			pfd.dwVisibleMask = 0;
			pfd.dwDamageMask = 0;
--]]

	-- Choose Pixel Format
	-- Get format that matches closest
	local pixelFormat = GDIGL.ChoosePixelFormat(hdc, pfd);
	assert(0 ~= pixelFormat, "GLContext - ChoosePixelFormat returned '0'")


	local result = GDIGL.SetPixelFormat(hdc, pixelFormat, pfd);    -- Set this as the actual format
	assert(0 ~= result,"GLContext - SetPixelFormat returned false")

	-- Create OpenGL Rendering Context (RC)
	C.SwapBuffers( hdc )
	local tmpContext = wgl.wglCreateContext(hdc);	--  Create a GLContext

	local ctx = GLContext(hdc, tmpContext, hwnd)

	return ctx
end

function CreateGLContextFromWindow(hwnd, flags)
	local hdc = C.GetDC(hwnd);
	local flags = bor(flags,C.PFD_DRAW_TO_WINDOW)
	local ctxt = CreateGLContextFromDC(hwnd, hdc, flags)

	return ctxt
end

return GLContext
