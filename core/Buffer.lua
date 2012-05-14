local ffi = require "ffi"

--[[
	Buffer

	This is an object that manages a bit of memory.  The buffer
	contains a piece of memory of a given size.  The size of
	the buffer is retained.  The buffer is intended to be used
	by a streaming interface, so it maintains an Index field,
	which is the last position valid bytes were written to.

	The buffer object itself has a couple of convenience functions
	to allocate and write bytes of memory.  Beyond that though
	it does not have any knowledge of types, relying on higher
	level abstractions to deal with proper streaming of data.
--]]

ffi.cdef[[
typedef struct {
	uint8_t *Data;
	uint32_t Size;
	uint32_t Index;
}buffer_t;
]]

Buffer = {}
Buffer_mt = {

	__index = {
		Initialize = function(self, size)
			self.Data = ffi.new("uint8_t["..size.."]");
			self.Size = size;
			self.Index = 0;

			return self;
		end,

		Allocate = function(self, size)
			local buffer = nil;
			if (self.Index + size < self.Size) then
				buffer = self.Data + self.Index;
				self.Index = self.Index + size;
			end

			return buffer;
		end,

		CopyToBuffer = function(self, data, len)
			local buffer = self:Allocate(len)
			if buffer then
				ffi.copy(buffer, data, len)
			end
			return buffer
		end,

		CopyStringToBuffer = function(self, str)
			local len = string.len(str);
			local strptr = ffi.cast("uint8_t*", str);
			local buffer = self:Allocate(len);
			if buffer then
				ffi.copy(buffer, strptr, len);
			end

			return buffer;
		end,
	},
}
Buffer = ffi.metatype("buffer_t", Buffer_mt)


