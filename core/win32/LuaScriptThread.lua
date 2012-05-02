
require "win_kernel32"
require "win_user32"

local ffi = require "ffi"

local kernel32 = ffi.load("kernel32")
local user32 = ffi.load("user32");

--
-- This helper routine will take a pointer
-- to cdata, and return a string that contains
-- the memory address
function PointerToString(instance)
	if ffi.abi("64bit") then
		return string.format("0x%016x", tonumber(ffi.cast("int64_t", ffi.cast("void *", instance))))
	elseif ffi.abi("32bit") then
		return string.format("0x%08x", tonumber(ffi.cast("int32_t", ffi.cast("void *", instance))))
	end

	return nil
end

function StringToPointer(str)
	return ffi.cast("void *",tonumber(str));
end

function CreatePreamble(threadparam)
	local paramAsString = PointerToString(threadparam)
	local scriptPath = ";"..string.gsub(GetCurrentDirectory(),'\\','/').."/?.lua";
	local ppath = string.gsub(package.path, '\\','/');
	local cpath = string.gsub(package.cpath, '\\','/');
	local applicationdir = string.gsub(_appdir, '\\','/');
	local preamble = [[

ffi = require "ffi"

local function StringToPointer(str)
    return ffi.cast("void *",tonumber(str));
end

_appdir = "]]..applicationdir..[["

_ThreadParam = StringToPointer("]]..paramAsString..[[");

_cpath = "]]..cpath..[["

_path = "]]..ppath..scriptPath..[["

]]

	return preamble;
end



class.LuaScriptThread()

function LuaScriptThread:_init(codechunk, param, createSuspended)
	createSuspended = createSuspended or false
	local flags = 0
	if createSuspended then
		flags = CREATE_SUSPENDED
	end

	param = param or nil

	self.CodeChunk = codechunk
	self.ThreadParam = param
	self.Flags = flags

	-- prepend the param to the code chunk if it was supplied
	local preamble = CreatePreamble(param)
	local threadprogram = preamble..codechunk;
	local threadId = ffi.new("DWORD[1]")

--print("LuaScriptThread:_init, program: \n", threadprogram)

	local codebuff = ffi.new("char["..(string.len(threadprogram)+1).."]");
	ffi.copy(codebuff, ffi.cast("char *",threadprogram), string.len(threadprogram));

	self.Handle = kernel32.CreateThread(nil,
		0,
		HUP.RunLuaScript,
		ffi.cast("void *", codebuff),
		flags,
		threadId)
	self.ThreadId = threadId[0]
--print("Thread Handle, ID: ", self.Handle, self.ThreadId);
end

function LuaScriptThread:Resume()
-- need the following thread access right
--THREAD_SUSPEND_RESUME

	local result = kernel32.ResumeThread(self.Handle)
end

function LuaScriptThread:Suspend()
end

function LuaScriptThread:Yield()
	local result = kernel32.SwitchToThread()
end

function LuaScriptThread:Quit()
	user32.PostThreadMessageA(self.ThreadId,user32.WM_QUIT,0,0);
end

function LuaScriptThread:Receive(msg, wParam, lParam)
	user32.PostThreadMessageA(self.ThreadId,msg,wParam,lParam);
end
