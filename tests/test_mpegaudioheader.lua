--[[
	References

	http://mpgedit.org/mpgedit/mpeg_format/mpeghdr.htm#MPEG HEADER
	http://www.codeproject.com/Articles/8295/MPEG-Audio-Frame-Header#ModeExt
	http://www.id3.org/
	http://www.gigamonkeys.com/book/practical-an-id3-parser.html
--]]


local ffi = require "ffi"

package.path = package.path..";c:/repos/HeadsUp/core/?.lua"

require "BanateCore"
require "DataDescription"
require "MP3_Description"


function copyFileToMemory(filename)
	local f = assert(io.open(filename, "rb"), "unable to open file")
	local str = f:read("*all")
	local slen = string.len(str)

	-- allocate a chunk of memory
	local arraystr = string.format("uint8_t[%d]", slen)
	local array = ffi.new(arraystr)
	for offset=0, slen-1 do
		array[offset] = string.byte(str:sub(offset+1,offset+1))
	end

	f:close()

	return array, slen
end

function printHeader(header)
	local bigendian = true
	print("== HEADER ==")
	print(string.format("\tFrame Sync: %s, %d", numbertobinary(header:get_FrameSync(), 11, bigendian), header:get_FrameSync()))
	print(string.format("\tVersionID: %s", numbertobinary(header:get_VersionID(), 2, bigendian)))
	print(string.format("\tLayer Index: %s", numbertobinary(header:get_LayerIndex(), 2, bigendian)))
	print(string.format("\tProtection: %s", numbertobinary(header:get_Protection(), 1, bigendian)))
	print(string.format("\tBit Rate Index: %s", numbertobinary(header:get_BitRateIndex(), 4, bigendian)))
	print(string.format("\tSample Rate Index: %s", numbertobinary(header:get_SampleRateIndex(), 2, bigendian)))
	print(string.format("\tChannel Mode: %s", numbertobinary(header:get_ChannelMode(), 2, bigendian)))
	print(string.format("\tMode Extension: %s", numbertobinary(header:get_ModeExtension(), 2, bigendian)))
	print(string.format("\tEmphasis: %s", numbertobinary(header:get_Emphasis(), 1, bigendian)))

	print(string.format("\tPrivate: %s", numbertobinary(header:get_Private(), 1, bigendian)))
	print(string.format("\tCopyright: %s", numbertobinary(header:get_Copyright(), 1, bigendian)))
	print(string.format("\tOriginal: %s", numbertobinary(header:get_Original(), 1, bigendian)))
end


function printID3Tag(tag)
	print("==== TAG ====")
	print("Class Size: ", tag.ClassSize)
	print(string.format("\tSignature: %s", ffi.string(tag:get_Signature())))
	print(string.format("\tMajor Version: %d", tag:get_MajorVersion()))
	print(string.format("\tMinor Version: %d", tag:get_MinorVersion()))
	print(string.format("\tFlags: %s", numbertobinary(tag:get_Flags(), 8, bigendian)))


	print(string.format("\tSize 1: %s", numbertobinary(tag:get_Size1(), 7, bigendian)))
	print(string.format("\tSize 2: %s", numbertobinary(tag:get_Size2(), 7, bigendian)))
	print(string.format("\tSize 3: %s", numbertobinary(tag:get_Size3(), 7, bigendian)))
	print(string.format("\tSize 4: %s", numbertobinary(tag:get_Size4(), 7, bigendian)))

	print("Size: ", calcID3TagSize(tag))
end

function printFileInfo(filename)
	if not filename then return end

	buff, bufflen = copyFileToMemory(filename)

	if not buff or bufflen == 0 then return end

	-- First see if the file starts with a ID tag
	local offset = 0
	local id3tag = ID3(buff, bufflen)
	if ffi.string(id3tag:get_Signature()) == "ID3" then
		printID3Tag(id3tag)

		-- increment the offset
		offset = id3tag.ClassSize + calcID3TagSize(id3tag)
		print(string.format("OFFSET: 0x%x", offset))
	end


	-- Now we have offset to actual audio data
	-- so, construct the first header
	local header = MPEGAudioHeader(buff, bufflen, offset)

	printHeader(header)
end

function test_Headerset()
	header = MPEGAudioHeader()
	header:set_FrameSync(binarytonumber("11111111111", true))
	header:set_VersionID(binarytonumber("10", true))
	header:set_LayerIndex(1)
	header:set_BitRateIndex(binarytonumber("1011", true))
	header:set_SampleRateIndex(binarytonumber("10", true))
	header:set_ChannelMode(binarytonumber("11", true))

	printHeader(header)
end

printFileInfo("OmShantiOm.MP3")
--test_Headerset()
