local ffi = require "ffi"

package.path = package.path..";c:/repos/HeadsUp/core/?.lua"

require "BanateCore"
require "DataDescription"



function CreateBufferFieldWriter(field)
	return string.format([[
function set_%s(bytes, value)
	setbitstobytes(bytes, %d, %d, value);
end
]], field.name, field.offset, field.size);
end

function CreateBufferFieldReader(field)
	return string.format([[
function get_%s(bytes)
	return getbitsfrombytes(bytes, %d, %d);
end
]], field.name, field.offset, field.size);
end


function CreateBufferAccessor(desc)
	local funcs = {}

	-- first create the offsets structure
	local offsets = BitOffsetsFromTypeInfo(desc)

	-- go through field by field and create the
	-- bit of code that will write to the buffer
	for _,field in ipairs(offsets) do
		table.insert(funcs, CreateBufferFieldWriter(field))
		table.insert(funcs, "\n");
		table.insert(funcs, CreateBufferFieldReader(field))
		table.insert(funcs, "\n");
	end

	return funcs
end






--[[
	The Rtp header has the following format:

    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |V=2|P|X|  CC   |M|     PT      |       sequence number         |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |                           timestamp                           |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
    |            synchronization source (SSRC) identifier           |
    +=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+=+
    |    contributing source (CSRC) identifiers  (if mixers used)   |
    |                             ....                              |
    +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

     V = Version
     P = Padding
     X = Extensions
     CC = Count of Contributing Sources
     M = Marker
     PT = Payload Type
--]]

RTPHeader_Info = {
	name = "RTPHeader";
	fields = {
		{name = "Version", basetype = "uint8_t", subtype="bit", repeating = 2};
		{name = "Padding", basetype = "uint8_t", subtype="bit", repeating = 1};
		{name = "Extensions", basetype = "uint8_t", subtype="bit", repeating = 1};
		{name = "ContributingCount", basetype = "uint8_t", subtype="bit", repeating=4};
		{name = "Marker", basetype = "uint8_t", subtype="bit", repeating=1};
		{name = "PayloadType", basetype = "uint8_t", subtype="bit", repeating=7};
		{name = "SequenceNumber", basetype = "uint16_t"};
		{name = "TimeStamp", basetype = "uint32_t"};
		{name = "SSRC", basetype = "uint32_t"};
	};
};

function test_CType()
	print(CStructFromTypeInfo(RTPHeader_Info))
end

function test_Offsets()
	local offsets = BitOffsetsFromTypeInfo(RTPHeader_Info)

	for _,field in ipairs(offsets) do
		print(field.offset, field.size, field.name)
	end
end

function test_BufferAccessors()
	local funcs = CreateBufferAccessor(RTPHeader_Info)
	local funcstr = table.concat(funcs)

	print(funcstr)

	-- Now that we have the functions, compile them
	-- so we can try to use them
	local f = loadstring(funcstr)
	f()

	-- Finally, try to set some values
	-- Create a buffer first to act as the header storage
	local buff = ffi.new("uint8_t[2048]")

	set_Version(buff, 2)
	set_Padding(buff,0)
	set_Extensions(buff,1)
	set_ContributingCount(buff, 3)
	set_Marker(buff, 1)
	set_PayloadType(buff, 15)
	set_SequenceNumber(buff, 127)
	set_TimeStamp(buff, 523)
	set_SSRC(buff, 722)


	print("Version: ", get_Version(buff))
	print("Padding: ", get_Padding(buff))
	print("Extensions: ", get_Extensions(buff))
	print("Count: ", get_ContributingCount(buff))
	print("Marker: ", get_Marker(buff))
	print("Payload Type: ", get_PayloadType(buff))
	print("Sequence: ", get_SequenceNumber(buff))
	print("Timestamp: ", get_TimeStamp(buff))
	print("SSRC: ", get_SSRC(buff))
end

function test_BufferClass()
	local buffclass = CreateBufferClass(RTPHeader_Info)

	print(buffclass)

	-- Now that we have the class, compile it
	-- so we can try to use it
	local f = loadstring(buffclass)
	f()

	-- Finally, try to set some values
	-- Create a buffer first to act as the header storage
	local buff = ffi.new("uint8_t[2048]")
	local header = RTPHeader(buff)

	header:set_Version(2)
	header:set_Padding(0)
	header:set_Extensions(1)
	header:set_ContributingCount(3)
	header:set_Marker(1)
	header:set_PayloadType(15)
	header:set_SequenceNumber(127)
	header:set_TimeStamp(523)
	header:set_SSRC(722)


	print("Version: ", header:get_Version())
	print("Padding: ", header:get_Padding())
	print("Extensions: ", header:get_Extensions())
	print("Count: ", header:get_ContributingCount())
	print("Marker: ", header:get_Marker())
	print("Payload Type: ", header:get_PayloadType())
	print("Sequence: ", header:get_SequenceNumber())
	print("Timestamp: ", header:get_TimeStamp())
	print("SSRC: ", header:get_SSRC())
end


--test_CType();
--test_BufferAccessors();
test_BufferClass();

print(package.cpath);
