package.path = "..\\?.lua;..\\core\\?.lua;..\\core\\win32\\?.lua;"

local ffi = require "ffi"


require "win_kernel32"
local kernel32 = ffi.load("kernel32")

require "Heap"

local threadid = kernel32.GetCurrentThreadId();
print("Current Thread ID: ", threadid);

local heap = CreateHeap(1024, 1024*4096)

-- Allocate a pointer
local ptr1 = heap:Alloc(256)

print("Allocated Ptr: ", ptr1);

function test_blob()
	-- Allocate a blob
	local blob1 = heap:AllocBlob(256);
	print("Allocated Blob: ", blob1);
	return blob1;
end


local blob1 = test_blob();

blob1 = nil;

for i=1,5 do
	kernel32.Sleep(1000);
	print(i);
end

-- Create a couple of threads

-- Send data to them for awhile

-- Tell them to quit
