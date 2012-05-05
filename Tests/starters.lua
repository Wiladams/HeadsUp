

local bhutnode = [=[
print("Bhut Node: ", _ThreadParam);

package.path = _path;

require("win_user32");
local user32 = ffi.load("User32")

require "BhutNode"

local msg = ffi.new("MSG")

local bRet = user32.GetMessageA(msg,nil,0,0);

while (bRet ~= 0) do
	if (_G.ReceiveMSG) then
		ReceiveMSG(msg);
	end

	bRet = user32.GetMessageA(msg,nil,0,0);
end

]=];


local clocknode = [=[
print("clocknode - BEGIN");

package.path = _path;
package.cpath = _cpath;

local bit = require "bit"
local bor = bit.bor;

require "win_kernel32"
kernel32 = ffi.load("kernel32")

require "win_user32"
user32 = ffi.load("user32")

require "ClockNode"


local IsRunning = true;
local timerEvent = kernel32.CreateEventA(nil, false, false, nil)
local handleCount = 1
local handles = ffi.new('void*[1]', {timerEvent})
local dwFlags = bor(C.MWMO_ALERTABLE,C.MWMO_INPUTAVAILABLE)

local msg = ffi.new("MSG")

local tleft = 100;


while (IsRunning) do
	while (user32.PeekMessageA(msg, nil, 0, 0, C.PM_REMOVE) ~= 0) do
		if (_G.ReceiveMSG) then
			ReceiveMSG(msg);
		end
	end

	if msg.message == C.WM_QUIT then
		IsRunning = false;
	else
		if (_G.OnIdle) then
			OnIdle();
		end
	end

	-- use an alertable wait
	C.MsgWaitForMultipleObjectsEx(handleCount, handles, tleft, C.QS_ALLEVENTS, dwFlags)
end

]=];


local simplechunk = [=[

package.path = _path;

require("win_user32");
local user32 = ffi.load("User32")

require("MessagePrinter")
printer = MessagePrinter();


local msg = ffi.new("MSG")

local bRet = user32.GetMessageA(msg,nil,0,0);

while (bRet ~= 0) do
	--print("nothing");
	printer:Receive(msg);

	bRet = user32.GetMessageA(msg,nil,0,0);
end

]=];

local simplest = [=[
print("Hello World!")

print("APP DIR: ", _appdir);

print("PATH: ", _path);

print("CPATH: ", _cpath);

]=]

return {
	BhutStart = bhutnode;
	ClockStart = clocknode;
	Simple = simplechunk;
	Simplest = simplest;
}

