require "BanateCore"

require "StopWatch"
require "FileUtils"


class.HeadsUpViewer()

function HeadsUpViewer:_init(awidth, aheight)
	self.Running = false
	self.TickCount = 0
	self.frameCount = 0
	self.StopWatch = StopWatch()

	self:OnWindowResized(awidth, aheight);
end


function HeadsUpViewer:OnTick(tickCount)
	self:Tick(tickCount)
end

function HeadsUpViewer:OnWindowResized(width, height)
	self.WindowWidth = width;
	self.WindowHeight = height;

	if _G.reshape then
		reshape(width, height);
	else
		gl.glViewport(0, 0, width, height);
	end
end

function HeadsUpViewer:OnKeyboardMouse(hWnd, msg, wParam, lParam)
--print(string.format("OnKeyboardMouse: 0x%x", msg))
end




--[==============================[
	Compiling
--]==============================]

function HeadsUpViewer:ClearGlobalFunctions()
	-- Clear out the global routines
	-- That the user may have supplied
	_G.init = nil
	_G.display = nil
	_G.reshape = nil
end

function HeadsUpViewer:LoadFile(filename)
	if filename ~= nil then
		self.LoadedFile = filename
		self.FileAttributes = GetFileAttributes(filename)
		self.LastWriteTime = tostring(self.FileAttributes.ftLastWriteTime)
		print("Loaded File last Write Time: ", self.LastWriteTime)

		local f = assert(io.open(filename, "r"))
		local txt = f:read("*all")
		self:Compile(txt)
		f:close()
	end
end

function HeadsUpViewer:ReloadCurrentFile()
	self:LoadFile(self.LoadedFile)
end

function HeadsUpViewer:Compile(inputtext)
	-- Stop animation if currently running
	self:StopAnimation()


	-- Ideally, create a new lua state to run
	-- the script in.  That way, cleanup becomes
	-- very easy, and an error in the script will
	-- not take down the entire application.
	-- Fow now, just use the same script environment
	-- but clean up the global functions that we use

	self:ClearGlobalFunctions();

	-- Compile the code
	local f = loadstring(inputtext)
	f()

	-- If there is a setup routine,
	-- run that before anything else
	if _G.init ~= nil then
		_G.init()
	end

	-- Run animation loop
	self:StartAnimation()
end

function HeadsUpViewer:StartAnimation()
	self.Running = true
	self.TickCount = 0
	self.FramesPerSecond = 0
	self.frameCount = 0
	self.StopWatch:Reset()
end

function HeadsUpViewer:StopAnimation()
	self.Running = false
	self.TickCount = 0
end

function HeadsUpViewer:ReloadScriptIfChanged()
	-- Check to see if file has changed,
	-- if it has, then reload it
	--print("Loaded File Write Time: ", self.LastWriteTime)

	-- Get the current attributes on the file
	local fa = GetFileAttributes(self.LoadedFile)
	local currentWriteTime = tostring(fa.ftLastWriteTime)
	--print("Current Write Time: ", currentWriteTime)

	-- Compare the current write time with the last write time
	local writeTimesEqual = currentWriteTime == self.LastWriteTime
	--print("Write Times Equal: ", writeTimesEqual)

	if (writeTimesEqual == false) then
		self:ReloadCurrentFile()
	end
end

function HeadsUpViewer:Tick(tickCount)
	if not self.Running then return end

	self.TickCount = self.TickCount + 1
	self.frameCount = self.frameCount + 1

	self.FramesPerSecond = self.TickCount / self.StopWatch:Seconds()

	if (_G.ontick) ~= nil then
		ontick(tickCount)
	end

	-- If the user has created a global 'display()' function
	-- then execute that function
	if (_G.display) ~= nil then
		display()
	end

	-- Check every 30 ticks
	local timeToCheck = ((tickCount %30) == 0);
	if timeToCheck and (self.LoadedFile ~= nil) then
		self:ReloadScriptIfChanged()
	end
end



