local ffi = require "ffi"


require "StopWatch"


local framerate = 4;
local Interval = 1/framerate;
local IsRunning = true;

local timerEvent = kernel32.CreateEventA(nil, false, false, nil)


local sw = StopWatch()

local tickCount = 0
local timeLeft = 0
local lastTime = sw:Milliseconds()
local nextTime = lastTime + (Interval * 1000)

function ReceiveMSG(msg)
	if msg.message == user32.WM_SYSCOMMAND then
		print("ClockNode:ReceiveMSG");
	else
		user32.TranslateMessage(msg)
		user32.DispatchMessageA(msg)
	end
end

function OnTick(tickCount)
	print("Tick: ", tickCount);
end

function OnIdle()
	local currentTime = sw:Milliseconds();
	timeLeft = nextTime - currentTime;
	if (timeLeft <= 0) then
		OnTick(tickCount);
		tickCount = tickCount + 1
		nextTime = nextTime + (Interval * 1000)
	end
end

