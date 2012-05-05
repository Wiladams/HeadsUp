
require "LuaScriptThread"

local Nodes = require "starters"

local user32 = ffi.load("user32");
local kernel32 = ffi.load("kernel32");


local path = ffi.new("char["..(string.len(package.path)+1).."]");
ffi.copy(path, ffi.cast("char *",package.path), string.len(package.path));



function test_RunScript()
	--HUP.RunLuaScript(ffi.cast("void *", Nodes.Simple), path);
	--HUP.RunLuaScript(ffi.cast("void *", Nodes.Simplest));

	local looper = LuaScriptThread(Nodes.Simplest);

end


function testLooper()
	--local looper = LuaScriptThread(Nodes.BhutStart, nil);
	local looper = LuaScriptThread(Nodes.Simplest, nil);

	-- Give the thread a chance to start
	kernel32.Sleep(100);

	local maxIterations = 0xff;
	local counter = 1;
	local bRet;
	cmd = C.WM_COMMAND;

	while (true) do
		if counter > maxIterations then
			looper:Quit();
			return ;
		end

		looper:Receive(cmd, counter, 0);
		counter = counter + 1;
		kernel32.Sleep(1000);
	end
end

function testTimeLooper()
	local looper = LuaScriptThread(Nodes.ClockStart, nil);

	-- Give the thread a chance to start
	kernel32.Sleep(100);

	local maxIterations = 60;
	local counter = 1;
	local bRet;
	cmd = C.WM_COMMAND;

	while (true) do
		if counter > maxIterations then
			looper:Quit();
			return ;
		end

		looper:Receive(cmd, counter, 0);
		counter = counter + 1;
		kernel32.Sleep(1000);
	end
end

test_RunScript();

--testLooper();

--testTimeLooper();
