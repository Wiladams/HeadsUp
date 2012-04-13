--
-- HeadsUp.lua
--
-- The main interface file
--
--print("StartUp.lua - Package Path Before: ", package.path)

local apppath = string.format([[;%s\?.lua;%s\core\?.lua;%s\core\Win32\?.lua;%s\modules\?.lua]],arg[1], arg[1], arg[1], arg[1]);
local ppath = package.path..apppath;
package.path = ppath;

--print("StartUp.lua - Package Path After: ", package.path)


ffi = require "ffi"
gl = require( "gl" )
HUP = ffi.load("HeadsUp.exe")


require "HeadsUpViewer"

ffi.cdef[[
typedef void (*OnResizedDelegate)(int newWidth, int newHeight);
typedef void (*OnTickDelegate)(int tickCount);
typedef void (*MsgReceiver)(HWND hWnd, UINT msg, WPARAM wParam, LPARAM lParam);

int RegisterKeyboardMouse(MsgReceiver receiver);
int RegisterResizedDelegate(OnResizedDelegate delegate);
int RegisterTickDelegate(OnTickDelegate delegate);

]]


local canvasWidth = 1024
local canvasHeight = 768

MainView = nil;


function OnTick(tickCount)
	MainView:Tick(tickCount)
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
	if arg[2] ~= nil then
print("StartUp main, loading file: ", arg[2]);
		MainView:LoadFile(arg[2])
	end
end

main();
