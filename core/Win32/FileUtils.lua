local ffi = require "ffi"

require "win_kernel32"
require "WinBase"

local k32 = ffi.load("kernel32")



FILETIME = nil
FILETIME_mt = {
	__tostring = function(self)
		local lpSystemTime = ffi.new("SYSTEMTIME[1]")
	    k32.FileTimeToSystemTime(self, lpSystemTime);
		local systemTime = lpSystemTime[0]
		local filetime = string.format("%02d/%02d/%04d  %2d:%2d:%2d",
			systemTime.wDay,
			systemTime.wMonth,
			systemTime.wYear,
			systemTime.wHour,
			systemTime.wMinute,
			systemTime.wSecond
			);

		return filetime
	end,

	__index = {
		Equal = function(self, rhs)
			return self.dwLowDateTime == rhs.dwLowDateTime and
				self.dwHighDateTime == rhs.dwHighDateTime
		end,
	},
}
FILETIME = ffi.metatype("FILETIME", FILETIME_mt)

ffi.cdef[[
typedef struct win32file {
	HANDLE	Handle;
} WIN32FILE, *PWIN32FILE;
]]

WIN32FILE = nil
WIN32FILE_mt = {
	__gc = function(self)
		k32.CloseHandle(self.Handle)
	end,

	__index = {
		GetInformation = function (self)
			local lpFileInformation = ffi.new("BY_HANDLE_FILE_INFORMATION[1]")
			k32.GetFileInformationByHandle(self.Handle, lpFileInformation)
			local fileInformation = lpFileInformation[0]

			return fileInformation
		end,
	},

}
WIN32FILE = ffi.metatype("WIN32FILE", WIN32FILE_mt)

function GetFileAttributes(filename)
	local handle = k32.CreateFileA(filename,
		FILE_READ_ATTRIBUTES,
		FILE_SHARE_READ,
		nil,
		OPEN_EXISTING,
		0,
		nil)


	if ffi.cast("intptr_t", handle) == INVALID_HANDLE_VALUE then
		print("Invalide File Handle for file: ", filename)
		return nil
	end

	local file = WIN32FILE(handle)
	return file:GetInformation()
end

--[==[
print("FileUtils.lua - TEST")

--[[
typedef struct _BY_HANDLE_FILE_INFORMATION {
    DWORD dwFileAttributes;
    FILETIME ftCreationTime;
    FILETIME ftLastAccessTime;
    FILETIME ftLastWriteTime;
    DWORD dwVolumeSerialNumber;
    DWORD nFileSizeHigh;
    DWORD nFileSizeLow;
    DWORD nNumberOfLinks;
    DWORD nFileIndexHigh;
    DWORD nFileIndexLow;
} BY_HANDLE_FILE_INFORMATION, *PBY_HANDLE_FILE_INFORMATION, *LPBY_HANDLE_FILE_INFORMATION;
--]]

function printHandleInformation(info)
	print("==== Handle Information ====")
	print(info.dwFileAttributes)
	print("Creation Time: ", info.ftCreationTime)
	print("   Last Write: ", info.ftLastWriteTime)
	print("  Last Access: ", info.ftLastAccessTime)
end

local hi1 = GetFileAttributes("README")
local hi2 = GetFileAttributes("README")
--local hi = GetFileAttributes("foo")

--printHandleInformation(hi)

print("Creation Time Equal: ", hi1.ftCreationTime:Equal(hi2.ftCreationTime))
print("Last Access Equal: ", hi1.ftLastAccessTime:Equal(hi2.ftLastAccessTime))
print("Last Write Equal: ", hi1.ftLastWriteTime:Equal(hi2.ftLastWriteTime))
--]==]
