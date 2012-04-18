-- MemoryStream.lua
local ffi = require"ffi"
local class = require"Class"
require "ByteArray"

local byteptr = ffi.typeof("uint8_t *")

class.MemoryStream()

function MemoryStream:_init(buffer)
	self.NextWrite = 0
	self.NextRead = 0

	self.Buffer = buffer
end

function MemoryStream:Length()
	local len = self.NextWrite - self.NextRead
	return len
end

function MemoryStream:Reset()
	self.NextWrite = 0
	self.NextRead = 0
end

function MemoryStream:Clear()
	self:Reset()
	-- And clear the memory as well
end


function MemoryStream:ReadByte()
	if self.NextRead < self.NextWrite then
		local abyte = self.Buffer.Data[self.NextRead]
		self.NextRead = self.NextRead + 1
		return abyte;
	end

	return nil
end


function MemoryStream:WriteByte(value)
	local abyte = ffi.new("unsigned char[1]",value)

	self.Buffer:CopyBytes(self.NextWrite, abyte, 0, 1)
	self.NextWrite = self.NextWrite + 1

	return 1
end

function MemoryStream:Write(buffer,offset,count)
	offset = offset or 0
	if type(buffer) == "string" then
		count = count or string.len(buffer)
		for i=1,count do
			local abyte = string.sub(buffer, i+offset, i+offset)
			self:WriteByte(abyte)
		end
	else
		self.Buffer:CopyBytes(self.NextWrite, buffer, offset, count)
		self.NextWrite = self.NextWrite + count
	end
end

function MemoryStream:WriteTo(stream)
	stream:Write(self.Buffer.data, 0, self.Buffer.Length)
end


function MemoryStream:GetBuffer()
	return self.Buffer
end


function MemoryStream.CreateNew(size)
	return MemoryStream(size)
end
