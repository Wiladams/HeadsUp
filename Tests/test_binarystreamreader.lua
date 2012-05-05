require "BinaryStreamReader"
require "BinaryStreamWriter"

function teststringread()
local hello = "Hello, World!";

local reader = BinaryStreamReader.CreateForString(hello);

b = reader:ReadByte()
while (b) do
	io.write(string.char(b));

	b = reader:ReadByte()
end
end

function test_ByteWrite()
	local bytes = ffi.new("char[14]");

	local writer = BinaryStreamWriter.CreateForBytes(bytes,14);
	writer:WriteByte(string.byte('h'));
	writer:WriteByte(string.byte('e'));
	writer:WriteByte(string.byte('l'));
	writer:WriteByte(string.byte('l'));
	writer:WriteByte(string.byte('o'));
	writer:WriteByte(string.byte(' '));
	writer:WriteByte(string.byte('W'));
	writer:WriteByte(string.byte('i'));
	writer:WriteByte(string.byte('l'));
	writer:WriteByte(string.byte('l'));
	writer:WriteByte(string.byte('y'));
	writer:WriteByte(string.byte('!'));
	writer:WriteByte(0);

	local reader2 = BinaryStreamReader.CreateForBytes(bytes, 14);

	b = reader2:ReadByte()
	while(b) do
		io.write(string.char(b));

		b = reader2:ReadByte();
	end
end

function test_Int()
	local len = 1024;
	local bytes = Array1D(len, "uint8_t");
	local writer = BinaryStreamWriter.CreateForBytes(bytes,len);

	writer:WriteInt16(32);
	writer:WriteInt32(958);
	writer:WriteInt16(2301);
	writer:WriteInt32(23);

	local reader = BinaryStreamReader.CreateForBytes(bytes, len);
	assert(reader:ReadInt16() == 32);
	assert(reader:ReadInt32() == 958);
	assert(reader:ReadInt16() == 2301);
	assert(reader:ReadInt32() == 23);
end

function test_Single()
	local len = 1024;
	local bytes = Array1D(len, "uint8_t");
	local writer = BinaryStreamWriter.CreateForBytes(bytes,len);

	writer:WriteSingle(32.1);
	writer:WriteDouble(958.2);
	writer:WriteSingle(2301.3);
	writer:WriteDouble(23.77);

	local reader = BinaryStreamReader.CreateForBytes(bytes, len);
	print(reader:ReadSingle());
	print(reader:ReadDouble());
	print(reader:ReadSingle());
	print(reader:ReadDouble());

--[[
	assert(reader:ReadSingle() == 32.1);
	assert(reader:ReadDouble() == 958.2);
	assert(reader:ReadSingle() == 2301.3);
	assert(reader:ReadDouble() == 23.77);
--]]
end

function test_string()
	local len = 1024;
	local bytes = Array1D(len, "uint8_t");
	local writer = BinaryStreamWriter.CreateForBytes(bytes,len);

	writer:WriteString("this is a whole long string that I want to be written in the buffer");


	local reader = BinaryStreamReader.CreateForBytes(bytes, len);

	local str = reader:ReadString();
	print(str);
end


--test_ByteWrite();
--test_Int();
--test_Single();
test_string();
