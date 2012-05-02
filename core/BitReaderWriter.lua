require "BanateCore"
local ffi = require "ffi"

ffi.cdef[[
typedef union  {
		uint8_t		Byte;
		int16_t 	Short;
		uint16_t	UShort;
		int32_t		Int32;
		uint32_t	UInt32;
		int64_t		Int64;
		uint64_t	UInt64;
		float 		f;
		double 		d;
		uint8_t bytes[8];
} bittypes_t
]]
local bittypes = ffi.typeof("bittypes_t")


class.BitReader()

function BitReader:_init(bigendian)
	bigendian = bigendian or ffi.abi("be")
	self.BigEndian = bigendian
end

function BitReader:ReadByte(bytes)
	return bytes[0]
end

function BitReader:ReadInt16(bytes, bigendian)
	local bt = bittypes()

	bt.bytes[0] = bytes[0]
	bt.bytes[1] = bytes[1]

	return bt.Short;
end

function BitReader:ReadUInt16(bytes, bigendian)
	local bt = bittypes()

	bt.bytes[0] = bytes[0]
	bt.bytes[1] = bytes[1]

	return bt.UShort;
end

function BitReader:ReadInt32(bytes, bigendian)
	local bt = bittypes()

	bt.bytes[0] = bytes[0]
	bt.bytes[1] = bytes[1]
	bt.bytes[2] = bytes[2]
	bt.bytes[3] = bytes[3]

	return bt.Int32;
end

function BitReader:ReadUInt32(bytes, bigendian)
	local bt = bittypes()

	bt.bytes[0] = bytes[0]
	bt.bytes[1] = bytes[1]
	bt.bytes[2] = bytes[2]
	bt.bytes[3] = bytes[3]

	return bt.UInt32;
end

function BitReader:ReadInt64(bytes)
	local bt = bittypes()

	bt.bytes[0] = bytes[0]
	bt.bytes[1] = bytes[1]
	bt.bytes[2] = bytes[2]
	bt.bytes[3] = bytes[3]
	bt.bytes[4] = bytes[4]
	bt.bytes[5] = bytes[5]
	bt.bytes[6] = bytes[6]
	bt.bytes[7] = bytes[7]

	return bt.Int64;
end

function BitReader:ReadUInt64(bytes)
	local bt = bittypes()

	bt.bytes[0] = bytes[0]
	bt.bytes[1] = bytes[1]
	bt.bytes[2] = bytes[2]
	bt.bytes[3] = bytes[3]
	bt.bytes[4] = bytes[4]
	bt.bytes[5] = bytes[5]
	bt.bytes[6] = bytes[6]
	bt.bytes[7] = bytes[7]

	return bt.UInt64;
end

function BitReader:ReadSingle(bytes)
	local bt = bittypes()

	bt.bytes[0] = bytes[0]
	bt.bytes[1] = bytes[1]
	bt.bytes[2] = bytes[2]
	bt.bytes[3] = bytes[3]

	return bt.f
end

function BitReader:ReadDouble(bytes)
	local bt = bittypes()

	bt.bytes[0] = bytes[0]
	bt.bytes[1] = bytes[1]
	bt.bytes[2] = bytes[2]
	bt.bytes[3] = bytes[3]
	bt.bytes[4] = bytes[4]
	bt.bytes[5] = bytes[5]
	bt.bytes[6] = bytes[6]
	bt.bytes[7] = bytes[7]

	return bt.d
end




class.BitWriter()

function BitWriter:_init(bigendian)
	self.WriteAsBigEndian = bigendian
end

function BitWriter:WriteByte(bytes, value)
	bytes[0] = value
	return 1;
end

function BitWriter:WriteInt16(bytes, value)
	if self.WriteAsBigEndian then
		bytes[1] = band(rshift(value, 0), 0xff)
		bytes[0] = band(rshift(value, 8), 0xff)
	else
		bytes[0] = band(rshift(value, 0), 0xff)
		bytes[1] = band(rshift(value, 8), 0xff)
	end

	return 2
end

function BitWriter:WriteInt32(bytes, value)
	if self.WriteAsBigEndian then
		bytes[3] = band(rshift(value, 0), 0xff)
		bytes[2] = band(rshift(value, 8), 0xff)
		bytes[1] = band(rshift(value, 16), 0xff)
		bytes[0] = band(rshift(value, 24), 0xff)
	else
		bytes[0] = band(rshift(value, 0), 0xff)
		bytes[1] = band(rshift(value, 8), 0xff)
		bytes[2] = band(rshift(value, 16), 0xff)
		bytes[3] = band(rshift(value, 24), 0xff)
	end
	return 4
end

function BitWriter:WriteInt64(bytes, value)
	if self.WriteAsBigEndian then
		bytes[7] = band(rshift(value, 0), 0xff)
		bytes[6] = band(rshift(value, 8), 0xff)
		bytes[5] = band(rshift(value, 16), 0xff)
		bytes[4] = band(rshift(value, 24), 0xff)
		bytes[3] = band(rshift(value, 32), 0xff)
		bytes[2] = band(rshift(value, 40), 0xff)
		bytes[1] = band(rshift(value, 48), 0xff)
		bytes[0] = band(rshift(value, 56), 0xff)
	else
		bytes[0] = band(rshift(value, 0), 0xff)
		bytes[1] = band(rshift(value, 8), 0xff)
		bytes[2] = band(rshift(value, 16), 0xff)
		bytes[3] = band(rshift(value, 24), 0xff)
		bytes[4] = band(rshift(value, 32), 0xff)
		bytes[5] = band(rshift(value, 40), 0xff)
		bytes[6] = band(rshift(value, 48), 0xff)
		bytes[7] = band(rshift(value, 56), 0xff)
	end
	return 8
end

function BitWriter:WriteSingle(bytes, value)
	local f1 = float(value)
	local bt = bittypes()
	bt.f = f1

	if self.WriteAsBigEndian then
		bytes[3] = bt.bytes[0]
		bytes[2] = bt.bytes[1]
		bytes[1] = bt.bytes[2]
		bytes[0] = bt.bytes[3]
	else
		bytes[0] = bt.bytes[0]
		bytes[1] = bt.bytes[1]
		bytes[2] = bt.bytes[2]
		bytes[3] = bt.bytes[3]
	end

	return 4
end

function BitWriter:WriteDouble(bytes, value)
	--local d1 = double(value)
	local bt = bittypes()
	bt.d = value

	bytes[0] = bt.bytes[0]
	bytes[1] = bt.bytes[1]
	bytes[2] = bt.bytes[2]
	bytes[3] = bt.bytes[3]
	bytes[4] = bt.bytes[4]
	bytes[5] = bt.bytes[5]
	bytes[6] = bt.bytes[6]
	bytes[7] = bt.bytes[7]
	return 8
end

