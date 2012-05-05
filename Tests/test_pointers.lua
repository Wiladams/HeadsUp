local ffi = require "ffi"

function CreatePointerString(instance)
	if ffi.abi("64bit") then
		return string.format("0x%016x", tonumber(ffi.cast("int64_t", ffi.cast("void *", instance))))
	elseif ffi.abi("32bit") then
		return string.format("0x%08x", tonumber(ffi.cast("int32_t", ffi.cast("void *", instance))))
	end

	return nil
end

local path = ffi.new("char["..(string.len(package.path)+1).."]");
ffi.copy(path, ffi.cast("char *",package.path), string.len(package.path));

local _ThreadParam = CreatePointerString(path);
print("_ThreadParam: ", _ThreadParam);

local paramnumber = tonumber(_ThreadParam);
print(string.format("Param Number: 0x%x", paramnumber));

local charptr = ffi.cast("char *",paramnumber);
print(charptr);

local repath = ffi.string(charptr);
print("Repath: ", repath);
