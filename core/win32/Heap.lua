local ffi = require "ffi"

require "WinBase"
require "win_kernel32"

local kernel32 = ffi.load("kernel32")

ffi.cdef[[
typedef struct {
	void *	Data;
	int32_t	Size;
	HANDLE	HeapHandle;
	DWORD	owningthread;
} HeapBlob;

typedef struct {
	HANDLE	Handle;
	int		Options;
	size_t	InitialSize;
	size_t	MaximumSize;
	DWORD	owningthread;
} HEAP;
]]

PROCESS_HEAP_ENTRY = ffi.typeof("PROCESS_HEAP_ENTRY")


--[[
	A HeapBlob is a chunk of memory that is allocated
	from a Heap.  The HeapBlob contains the pointer to
	the data that was allocated, as well as the size of
	the data.  It also contains a pointer back to the heap
	that was used to allocate the data in the first place.

	Given the amount of overhead associated with each blob,
	this construct is most useful when allocated large amounts
	of data, not small chunks.

	Given that it is a metatype, the objects can call the
	proper heap deallocation routine when they go out of scope
	and are about to be garbage collected.  This is a nice
	convenience, and makes heap allocation as seamless and
	painless as using ffi.new()
--]]
HeapBlob = nil
HeapBlob_mt = {
	__gc = function(self)
		if self.HeapHandle == nil or self.owningthread == 0 then return nil end

		if self.owningthread == kernel32.GetCurrentThreadId() then
			local success = kernel32.HeapFree(self.HeapHandle, 0, self.Data) ~= 0
		end
	end;


	__tostring = function(self)
		return string.format("Blob: Size: %d  Thread: %d",
			self.Size, self.owningthread);
	end;

	__index = {
		GetSize = function(self, flags)
			flags = flags or 0

			if self.HeapHandle == nil then return 0 end

			local result = kernel32.HeapSize(self.HeapHandle, flags, self.Data)

			return result
		end,

		IsValid = function(self, flags)
			flags = flags or 0

			if self.HeapHandle == nil then return false end

			local isValid = kernel32.HeapValidate(self.HeapHandle, flags, self.Data)

			return isValid
		end,

		ReaAlloc = function(self, nbytes, flags)
			flags = flags or 0

			if self.Heap == nil then return false end

			local ptr = kernel32.HeapReAlloc(self.HeapHandle, flags, self.Data, nbytes)

			if ptr == nil then return false end

			self.Data = ptr;
			self.Size = nbytes;

			return true
		end,

	}
}
HeapBlob = ffi.metatype("HeapBlob", HeapBlob_mt)




Heap = nil
Heap_mt = {
	__gc = function(self)
		if self.Handle == nil or self.owningthread == 0 then return nil end

		if self.owningthread == kernel32.GetCurrentThreadId() then
			local success = kernel32.HeapDestroy(self.Handle) ~= 0
		end
	end,

	__index = {
		Alloc = function(self, nbytes, flags)
			flags = flags or 0
			nbytes = nbytes or 1

			local ptr = kernel32.HeapAlloc(self.Handle, flags, nbytes)

			return ptr;
		end,

		AllocBlob = function(self, nbytes, flags)
			flags = flags or 0
			nbytes = nbytes or 1

			local ptr = kernel32.HeapAlloc(self.Handle, flags, nbytes)

			-- If the allocation failed, then just return
			if ptr == nil then
				return nil
			end

			-- Create a blob object, and return that to the
			-- caller.
			local blob = HeapBlob(ptr, nbytes, self.Handle, kernel32.GetCurrentThreadId())

			return blob
		end,

		Compact = function(self, flags)
			flags = flags or 0
			local size = kernel32.HeapCompact(self.Handle, flags)
			return size
		end,

		Lock = function(self)
			local success = kernel32.HeapLock(self.Handle) ~= 0
			return success
		end,

		Unlock = function(self)
			local success = kernel32.HeapUnlock(self.Handle) ~= 0
			return success
		end,

		StartHeapWalk = function(self)
			local heapEntry = ffi.new("PROCESS_HEAP_ENTRY")
			local pheapEntry = ffi.new("PROCESS_HEAP_ENTRY[1]", heapEntry)
			local success = kernel32.HeapWalk(self.Handle, pheapEntry) ~= 0
			--heapEntry = pheapEntry[0]

			return heapEntry, success
		end,

		ContinueHeapWalk = function(self, heapEntry)
			pheapEntry = ffi.new("PROCESS_HEAP_ENTRY[1]", heapEntry)
			local success = kernel32.HeapWalk(self.Handle, pheapEntry) ~= 0
			heapEntry = pheapEntry[0]

			return heapEntry, success
		end,

		IsValid = function(self, flags)
			flags = flags or 0

			local isValid = kernel32.HeapValidate(self.Handle, flags, nil)

			return isValid
		end,


	},
}
Heap = ffi.metatype("HEAP", Heap_mt)





function CreateHeap(initialSize, maxSize, options)
	initialSize = initialSize or 0
	maxSize = maxSize or 0
	options = options or 0

	-- Try to allocate the heap as specified
	local handle = kernel32.HeapCreate(options, initialSize, maxSize)

	-- If the allocation fails
	-- just return nil
	if handle == nil then
		return nil
	end

	local aheap = Heap(handle, options, initialSize, maxSize)

	return aheap
end

function GetProcessHeap()
	local handle = kernel32.GetProcessHeap()

		-- If the allocation fails
	-- just return nil
	if handle == nil then
		return nil
	end

	local aheap = Heap(handle)

	return aheap
end

