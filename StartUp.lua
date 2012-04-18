--
-- HeadsUp.lua
--
-- The main interface file
--
--print("StartUp.lua - Package Path Before: ", package.path)

ffi = require "ffi"

local apppath = string.format([[;%s\?.lua;%s\core\?.lua;%s\core\Win32\?.lua;%s\modules\?.lua]],argv[1], argv[1], argv[1], argv[1]);
local ppath = package.path..apppath;
package.path = ppath;

--print("StartUp.lua - Package Path After: ", package.path)


ogm = require("OglMan")
glu = require("glu")

require "WTypes"
require "keyboardmouse"

HUP = ffi.load("HeadsUp.exe")


--[[
	Define the ffi interface back to the host
	environment.
--]]

ffi.cdef[[
typedef void (*OnResizedDelegate)(int newWidth, int newHeight);
typedef void (*OnTickDelegate)(int tickCount);
typedef void (*MsgReceiver)(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

int RegisterKeyboardMouse(MsgReceiver receiver);
int RegisterResizedDelegate(OnResizedDelegate delegate);
int RegisterTickDelegate(OnTickDelegate delegate);

int SwapGLBuffers(void);

]]

require "HeadsUpViewer"

local canvasWidth = 1024
local canvasHeight = 768

MainView = nil;

function OnIdle(idleTime)
	MainView:OnIdle(idleTime);
end

function OnTick(tickCount)
	MainView:OnTick(tickCount)
end

function OnWindowResized(width, height)
	MainView:OnWindowResized(width, height);
end

function OnKeyboardMouse(hWnd, msg, wParam, lParam)
	MainView:OnKeyboardMouse(hWnd, msg, wParam, lParam);
end




function main()
	-- First setup the viewer so that we
	-- have something to receive delegate callabacks
	MainView = HeadsUpViewer(canvasWidth, canvasHeight)

	-- Now register for delegate callbacks
	HUP.RegisterResizedDelegate(OnWindowResized);
	HUP.RegisterTickDelegate(OnTick);
	HUP.RegisterKeyboardMouse(OnKeyboardMouse);

	-- If we have a file to load
	-- Then load the file
	if argv[2] ~= nil then
print("StartUp main, loading file: ", argv[2]);
		MainView:LoadFile(argv[2])
	end
end

main();
