local ffi = require "ffi"

local bit = require "bit"
local band = bit.band
local bor = bit.bor
local bxor = bit.bxor
local rshift = bit.rshift

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
		uint8_t b[8];
} bittypes_t
]]
local bittypes = ffi.typeof("bittypes_t")

function isset(value, bit)
	return band(value, 2^bit) > 0
end

function setbit(value, bit)
	return bor(value, 2^bit)
end

function clearbit(value, bit)
	return bxor(value, 2^bit)
end

function numbertobinary(value, nbits, bigendian)
	nbits = nbits or 32
	local res={}

	if bigendian then
		for i=nbits-1,0,-1 do
			if isset(value,i) then
				table.insert(res, '1')
			else
				table.insert(res, '0')
			end
		end
	else
		for i=0, nbits-1 do
			if isset(value,i) then
				table.insert(res, '1')
			else
				table.insert(res, '0')
			end
		end
	end

	return table.concat(res)
end



function binarytonumber(str, bigendian)
	local len = string.len(str)
	local value = 0

	if bigendian then
		for i=0,len-1 do
			if str:sub(len-i,len-i) == '1' then
				value = setbit(value, i)
			end
		end
	else
		for i=0, len-1 do
			if str:sub(i+1,i+1) == '1' then
				value = setbit(value, i)
			end
		end
	end

	return value
end

function bytestobinary(bytes, length, offset, bigendian)
	offset = offset or 0
	nbits = 8

	local res={}

	if bigendian then
		for offset=length-1, 0,-1 do
			table.insert(res, numbertobinary(bytes[offset],nbits, bigendian))
		end

	else
		for offset=0,length-1 do
			table.insert(res, numbertobinary(bytes[offset],nbits, bigendian))
		end
	end

	return table.concat(res)
end

function getbitsvalue(src, lowbit, bitcount)
	lowbit = lowbit or 0
	bitcount = bitcount or 32

	local value = 0
	for i=0,bitcount-1 do
		value = bor(value, band(src, 2^(lowbit+i)))
	end

	return rshift(value,lowbit)
end

function getbitstring(value, lowbit, bitcount)
	return numbertobinary(getbitsvalue(value, lowbit, bitcount))
end

-- Given a bit number, calculate which byte
-- it would be in, and which bit within that
-- byte.
function getbitbyteoffset(bitnumber)
	local byteoffset = math.floor(bitnumber /8)
	local bitoffset = bitnumber % 8

	return byteoffset, bitoffset
end


function getbitsfrombytes(bytes, startbit, bitcount)
	if not bytes then return nil end

	local value = 0

	for i=1,bitcount do
		local byteoffset, bitoffset = getbitbyteoffset(startbit+i-1)
		local bitval = isset(bytes[byteoffset], bitoffset)
--print(byteoffset, bitoffset, bitval);
		if bitval then
			value = setbit(value, i-1);
		end
	end

	return value
end

function setbitstobytes(bytes, startbit, bitcount, value, bigendian)

	local byteoffset=0;
	local bitoffset=0;
	local bitval = false

	if bigendian then
		for i=0,bitcount-1 do
			byteoffset, bitoffset = getbitbyteoffset(startbit+i)
			bitval = isset(value, i)
			if bitval then
				bytes[byteoffset] = setbit(bytes[byteoffset], bitoffset);
			end
		end
	else
		for i=0,bitcount-1 do
			byteoffset, bitoffset = getbitbyteoffset(startbit+i)
			bitval = isset(value, i)
			if bitval then
				bytes[byteoffset] = setbit(bytes[byteoffset], bitoffset);
			end
		end
	end

	return bytes
end












function test_booleanstring()
    print("4: ", numbertobinary(4, 8))
    print("8: ", numbertobinary(8, 8))
    print("0x0f: ", numbertobinary(0x0f, 16))
    print("0xff: ", numbertobinary(0xff, 16))
end

function test_stringtonumber()
	print(binarytonumber(numbertobinary(4,8)))
	print(binarytonumber(numbertobinary(8,8)))
	print(binarytonumber(numbertobinary(0x0f,16)))
	print(binarytonumber(numbertobinary(0xff,16)))
end

function test_bitstring()
    print("1: ", getbitstring(1, 0,4))
    print("2: ", getbitstring(3, 0,2))
	print("6:3 - ",getbitstring(6, 1,2))
end

function test_getbitsvalue()
	print(getbitsvalue(0, 0, 8))
	print(getbitsvalue(3, 0, 8))
	print(getbitsvalue(6, 1, 8))
	print(getbitsvalue(0xff, 0, 8))

	local bin1 = "11000000"
	local n1 = binarytonumber(bin1)

	print("Binary 3: ", getbitsvalue(n1, 6, 2))
end

function test_bitbytes()
	local value = 3.7;
	local bt = bittypes();

	bt.f = 3.7;
	print("float 3.7: ", bytestobinary(bt.b, 4, 0))

	bt.Int = 3;
	print("int 3: ", bytestobinary(bt.b, 4, 0))

	bt.Short = -10;
	print("Short -10: ", bytestobinary(bt.b, 2, 0))

	bt.Short = bit.arshift(-10,2);
	print("arshift Short -10, 2: ", bytestobinary(bt.b, 2, 0))

	bt.Short = bit.rshift(-10,2);
	print("rshift Short -10, 2: ", bytestobinary(bt.b, 2, 0))

	bt.Short = 10;
	print("Short 10: ", bytestobinary(bt.b, 2, 0))

	bt.Short = rshift(10,1);
	print("rshift Short 10,1: ", bytestobinary(bt.b, 2, 0))

	bt.Short = bit.arshift(10,2);
	print("arshift Short 10,2: ", bytestobinary(bt.b, 2, 0))

end

function test_modulus()
	print("1 % 8: ", 1 % 8);
	print("2 % 8: ", 2 % 8);
	print("7 % 8: ", 7 % 8);
	print("8 % 8: ", 8 % 8);

	for i=0,32 do
		print("i: ", i, getbitbyteoffset(i))
	end
end

function test_bitsfrombytes()
	-- Construct a string that looks like this
	-- 4 bits - version    (3)
	-- 4 bits - subversion (3)
	-- 24 bits - 523
--	local bitstr = "00100100101010101010101010101010"
--	local num = binarytonumber(bitstr)
--	local bt = bittypes();
--	bt.UInt32 = num

--	print("Bits: ", bytestobinary(bt.b, 4, 0))
	local bytes = ffi.new("uint8_t[4]")
	--setbitstobytes(bytes, startbit, bitcount, value)
	setbitstobytes(bytes, 0, 4, 4)
	setbitstobytes(bytes, 4, 4, 2)
	setbitstobytes(bytes, 8, 24, 5592405);
	print(bytestobinary(bytes, 4))


	local version = getbitsfrombytes(bytes, 0, 4)
	local subversion = getbitsfrombytes(bytes, 4, 4)
	local randval = getbitsfrombytes(bytes, 8, 24)

	print("Version: ", version);
	print("Sub: ", subversion);
	print("Radval: ", randval);

end




--test_booleanstring()
--test_stringtonumber()
--test_bitstring();
--test_getbitsvalue();
--test_bitbytes();
--test_modulus();
test_bitsfrombytes();

--print(math.ceil(13/8))

