--[[
	References

	http://mpgedit.org/mpgedit/mpeg_format/mpeghdr.htm#MPEG HEADER
	http://www.codeproject.com/Articles/8295/MPEG-Audio-Frame-Header#ModeExt
	http://www.id3.org/
	http://www.gigamonkeys.com/book/practical-an-id3-parser.html
	http://www.monkeysaudio.com/
	http://www.mp3-tech.org/programmer/frame_header.html
	http://stackoverflow.com/questions/5005476/how-can-i-extract-the-audio-data-from-an-mp3-file

	http://www.mpeg.org/MPEG/audio/askmp3.com.html
--]]


local ffi = require "ffi"

package.path = package.path..";c:/repos/HeadsUp/core/?.lua"

require "BanateCore"
require "DataDescription"

MPEGAudioTypes = {
MPEGAudioHeader_Info = {
	name = "MPEGAudioHeader";
	fields = {
		{name = "FrameSync", basetype = "uint32_t", subtype="bit", repeating = 11};
		{name = "VersionID", basetype = "uint32_t", subtype="bit", repeating = 2};
		{name = "LayerIndex", basetype = "uint32_t", subtype="bit", repeating = 2};
		{name = "Protection", basetype = "uint32_t", subtype="bit", repeating = 1};
		{name = "BitRateIndex", basetype = "uint32_t", subtype="bit", repeating = 4};
		{name = "SampleRateIndex", basetype = "uint32_t", subtype="bit", repeating = 2};
		{name = "Padding", basetype = "uint32_t", subtype="bit", repeating = 1};
		{name = "Private", basetype = "uint32_t", subtype="bit", repeating = 1};
		{name = "ChannelMode", basetype = "uint32_t", subtype="bit", repeating = 2};
		{name = "ModeExtension", basetype = "uint32_t", subtype="bit", repeating = 2};
		{name = "Copyright", basetype = "uint32_t", subtype="bit", repeating = 1};
		{name = "Original", basetype = "uint32_t", subtype="bit", repeating = 1};
		{name = "Emphasis", basetype = "uint32_t", subtype="bit", repeating = 2};
	};
};

ID3_Info = {
	name = "ID3";
	fields = {
		{name = "Signature", basetype = "char", repeating=3},
		{name = "MajorVersion", basetype = "uint8_t"},
		{name = "MinorVersion", basetype = "uint8_t"},
		{name = "Flags", basetype = "uint8_t"},

		{name = "Size1", basetype = "uint8_t", subtype="bit", repeating=7},
		{name = "SizeBlank1", basetype = "uint8_t", subtype="bit", repeating=1},
		{name = "Size2", basetype = "uint8_t", subtype="bit", repeating=7},
		{name = "SizeBlank2", basetype = "uint8_t", subtype="bit", repeating=1},
		{name = "Size3", basetype = "uint8_t", subtype="bit", repeating=7},
		{name = "SizeBlank3", basetype = "uint8_t", subtype="bit", repeating=1},
		{name = "Size4", basetype = "uint8_t", subtype="bit", repeating=7},
		{name = "SizeBlank4", basetype = "uint8_t", subtype="bit", repeating=1},
	};
};
}

function CreateMPEGAudioClasses()
	for name,info in pairs(MPEGAudioTypes) do
		local buffclass = CreateBufferClass(info)

--print(buffclass)

		-- Now that we have the class, compile it
		-- so we can try to use it
		local f = loadstring(buffclass)
		f()
	end
end

CreateMPEGAudioClasses()

function calcID3TagSize(tag)
	local size1 = tag:get_Size1();
	local size2 = tag:get_Size2();
	local size3 = tag:get_Size3();
	local size4 = tag:get_Size4();

	local size = lshift(size1,21)+lshift(size2,14)+lshift(size3,7)+size4

	return size
end

--[[
function calcFrameLength(frame)
	local slotsizes = {
		layer1 = 4,
		layer2 = 1,
		layer3 = 1,
	}

	local bitrate =
	local samplerate =
	local padding =

	local frameLength = 0

	if isLayer1(frame) then
		frameLength = (12*(bitrate/samplerate+padding)*4
	end

	if isLayer2(frame) or isLayer3(frame) then
		frameLength = 144*bitrate/samplerate+padding
	end

end
--]]




