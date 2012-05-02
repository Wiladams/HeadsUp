local ffi = require "ffi"

--package.path = package.path.."c:/repos/HeadsUp;c:/repos/HeadsUp/core/?.lua";
--package.cpath = package.cpath..";".._appdir.."\\?.exe";


require "BanateCore"

class.StopWatch()


function StopWatch:_init()
	self:Reset();
end

function StopWatch:__tostring()
	return string.format("Seconds: %d", self:Seconds())
end



--[[
/// <summary>
/// Reset the startCount, which is the current tick count.
/// This will reset the elapsed time because elapsed time is the
/// difference between the current tick count, and the one that
/// was set here in the Reset() call.
/// </summary>
--]]

function StopWatch:Reset()
	self.StartTime = GetCurrentTickTime();
end

-- <summary>
-- Return the number of seconds that elapsed since Reset() was called.
-- </summary>
-- <returns>The number of elapsed seconds.</returns>

function StopWatch:Seconds()
	local currentTime = GetCurrentTickTime();
--print("StopWatch:Seconds: ", currentTime);
	local seconds = currentTime - self.StartTime;

	return seconds;
end

function StopWatch:Milliseconds()
	return self:Seconds() * 1000;
end

