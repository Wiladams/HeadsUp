--local ffi = require "ffi"
--gl = require "gl"
local opengl32 = ffi.load("opengl32")

function GetFunctionProtoName(fname)
	local upname = fname:upper();
	local protoname = string.format("PFN%sPROC", upname);

	return protoname;
end

function GetWglFunctionPointer(fname, funcptr)
	local protoname = GetFunctionProtoName(fname);
	local castfunc = ffi.cast(protoname, funcptr);

	return castfunc;
end

function GetWglFunction(fname)
	local funcptr = opengl32.wglGetProcAddress(fname);
print("GetWglFunction - funcptr: ", funcptr);
	if funcptr == nil then
		return nil
	end

	local castfunc = GetWglFunctionPointer(fname, funcptr);

	return castfunc;
end


--require "glext"
require "wglext"




OglMan={}
OglMan_mt = {
	__index = function(tbl, key)
		local funcptr = GetWglFunction(key)

		-- Set the function into the table of
		-- known functions, so next time around,
		-- it this code will not need to execute
		rawset(tbl, key, funcptr)

		return funcptr;
	end,

	__newindex = function(tbl, idx, value)
		if idx == "Execute" then
			rawset(tbl, idx, value)
		end
	end,
}

setmetatable(OglMan, OglMan_mt)



function OglMan.Execute(self, ...)
	local args = {...};
	print ("OglMan.Execute")
end

OglMan_mt.__call = OglMan.Execute;


--OglMan.wglGetExtensionsStringARB(0x4001);
local wglGetExtensionsStringARB = GetWglFunction("wglGetExtensionsStringARB");
print("wglGetExtensionsStringARB: ", wglGetExtensionsStringARB);

local wglGetExtensionsStringEXT = GetWglFunction("wglGetExtensionsStringEXT");
print("wglGetExtensionsStringEXT: ", wglGetExtensionsStringEXT);

local ext = OglMan.wglGetExtensionsStringARB
print("ext1: ", ext);
ext = OglMan.wglGetExtensionsStringARB
print("ext2: ", ext);
