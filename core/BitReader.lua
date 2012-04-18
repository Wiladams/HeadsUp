--require "BanateCore"

local byteptr = ffi.typeof("uint8_t *")
local floatptr = ffi.typeof("float *")
local doubleptr = ffi.typeof("double *")

class.BitReader()

function BitReader:_init(bigendian)
	bigendian = bigendian or ffi.abi("be")
	self.BigEndian = bigendian
end

function BitReader:ReadByte(bytes, bigendian)
	return bytes[0]
end

function BitReader:ReadInt16(bytes, bigendian)
	return lshift(bytes[1],8) +
		bytes[0]
end

function BitReader:ReadInt32(bytes, bigendian)
	return lshift(bytes[3],24) +
		lshift(bytes[2],16) +
		lshift(bytes[1],8) +
		lshift(bytes[0],0)
end

function BitReader:ReadInt64(bytes, value, bigendian)
	return
		lshift(bytes[7],56) +
		lshift(bytes[6],48) +
		lshift(bytes[5],40) +
		lshift(bytes[4],32) +
		lshift(bytes[3],24) +
		lshift(bytes[2],16) +
		lshift(bytes[1],8) +
		lshift(bytes[0],0)
end

function BitReader:ReadSingle(bytes, value, bigendian)
	return floatptr(bytes)[0]
end

function BitReader:ReadDouble(bytes, value, bigendian)
	return doubleptr(bytes)[0]
end


