-- BinaryStreamWriter.lua
local ffi = require "ffi"
require "BanateCore"
require "BitReaderWriter"

local byteptr = ffi.typeof("uint8_t *")

class.BinaryStreamWriter()

function BinaryStreamWriter:_init(bytes, len)
	self.BitWriter = BitWriter();

	self.Position = 0;
	self.Bytes = ffi.cast("uint8_t *", bytes);
	self.Length = len;
end

function BinaryStreamWriter:Remaining()
	return self.Length - self.Position;
end

function BinaryStreamWriter:Reset()
	self.Position = 0;
end

function BinaryStreamWriter:Seek(pos)
	if pos < 0 or pos >= self.Length then return nil end;

	self.Position = pos;

	return self.Position;
end

function BinaryStreamWriter:WriteByte(value)
	if self:Remaining() < 1 then return nil end

	self.Position = self.Position + 1;

	return self.BitWriter:WriteByte(self.Bytes+self.Position-1, value);
end

function BinaryStreamWriter:WriteInt16(value)
	if self:Remaining() < 2 then return nil end

	self.Position = self.Position + 2;

	return self.BitWriter:WriteInt16(self.Bytes+self.Position-2, value);
end

function BinaryStreamWriter:WriteInt32(value)
	if self:Remaining() < 4 then return nil end

	self.Position = self.Position + 4;

	return self.BitWriter:WriteInt32(self.Bytes+self.Position-4, value);
end

function BinaryStreamWriter:WriteInt64(value)
	if self:Remaining() < 8 then return nil end

	self.Position = self.Position + 8;

	return self.BitWriter:WriteInt64(self.Bytes+self.Position-8, value);
end

function BinaryStreamWriter:WriteSingle(value)
	if self:Remaining() < 4 then return nil end

	self.Position = self.Position + 4;

	return self.BitWriter:WriteSingle(self.Bytes+self.Position-4, value);
end

function BinaryStreamWriter:WriteDouble(value)
	if self:Remaining() < 8 then return nil end

	self.Position = self.Position + 8;

	return self.BitWriter:WriteDouble(self.Bytes+self.Position-8, value);
end

function BinaryStreamWriter:WriteString(str)
	local len = string.len(str);

	if self:Remaining() < 4 then return nil end

	-- Write the lenth as an unsigned int32
	self:WriteInt32(len);

	-- Now write out each byte individually
	if type(str) == "string" then
		for i=1,len do
			self:WriteByte(string.byte(str, i, i));
		end
	end

	return len
end


function BinaryStreamWriter.CreateForString(str)
	local bytes = ffi.cast("uint8_t *", str);
	local len = string.len(str);
	return BinaryStreamWriter(bytes, len)
end

function BinaryStreamWriter.CreateForBytes(bytes, size)
	return BinaryStreamWriter(bytes, size)
end
