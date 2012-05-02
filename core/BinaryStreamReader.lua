-- BinaryStreamReader.lua
local ffi = require "ffi"
require "BanateCore"
require "BitReaderWriter"

local byteptr = ffi.typeof("uint8_t *")

class.BinaryStreamReader()

function BinaryStreamReader:_init(bytes, len)
	self.BitReader = BitReader();

	self.Position = 0;
	self.Bytes = bytes;
	self.Sentinel = self.Bytes;
	self.Length = len;
end

function BinaryStreamReader:Remaining()
	return self.Length - self.Position;
end

function BinaryStreamReader:Reset()
	self.Position = 0;
	self.Sentinel = self.Bytes;
end

function BinaryStreamReader:Seek(pos)
	if pos < 0 or pos >= self.Length then return nil end;

	self.Position = pos;
	self.Sentinel = self.Bytes + self.Position;

	return self.Position;
end

function BinaryStreamReader:ReadByte()
	if self:Remaining() < 1 then return nil end

	self.Position = self.Position + 1;

	return self.BitReader:ReadByte(self.Bytes+self.Position-1);
end

function BinaryStreamReader:ReadInt16()
	if self:Remaining() < 2 then return nil end

	self.Position = self.Position + 2;

	return self.BitReader:ReadInt16(self.Bytes+self.Position-2);
end

function BinaryStreamReader:ReadUInt16()
	if self:Remaining() < 2 then return nil end

	self.Position = self.Position + 2;

	return self.BitReader:ReadUInt16(self.Bytes+self.Position-2);
end

function BinaryStreamReader:ReadInt32()
	if self:Remaining() < 4 then return nil end

	self.Position = self.Position + 4;

	return self.BitReader:ReadInt32(self.Bytes+self.Position-4);
end

function BinaryStreamReader:ReadInt64()
	if self:Remaining() < 8 then return nil end

	self.Position = self.Position + 8;

	return self.BitReader:ReadInt64(self.Bytes+self.Position-8);
end

function BinaryStreamReader:ReadSingle()
	if self:Remaining() < 4 then return nil end

	self.Position = self.Position + 4;

	return self.BitReader:ReadSingle(self.Bytes+self.Position-4);
end

function BinaryStreamReader:ReadDouble()
	if self:Remaining() < 8 then return nil end

	self.Position = self.Position + 8;

	return self.BitReader:ReadDouble(self.Bytes+self.Position-8);
end

function BinaryStreamReader:ReadString()
	-- First check to see if there's enough space
	-- to read in the int32 length
	if self:Remaining() < 4 then return nil end

	-- Read in the length
	local len = self:ReadInt32();

	if len < 1 then return nil end

	-- Allocate a buffer to hold the data to be read
	local buff = Array1D(len+1, "char");

	local count = 0;
	for i=0,len-1 do
		local b = self:ReadByte();
		if not b then break end

		buff[i] = b;
		count = count + 1;
	end
	buff[count] = 0;

	local str = ffi.string(ffi.cast("char *", buff));
--print("String: ", str);

	return str;
end


function BinaryStreamReader.CreateForString(str)
	local bytes = ffi.cast("char *", str);
	local len = string.len(str);
	return BinaryStreamReader(bytes, len)
end

function BinaryStreamReader.CreateForBytes(bytes, size)
	return BinaryStreamReader(bytes, size)
end
