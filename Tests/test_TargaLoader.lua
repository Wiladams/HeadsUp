local ffi = require "ffi"

package.path = package.path..";c:/repos/HeadsUp/core/?.lua"

require "TargaLoader"

function printHeader(header)
	print("Color Map Type: ", header:get_ColorMapType());
	print("Image Type: ", header:get_ImageType());
	print("XOffset: ", header:get_XOffset());
	print("YOffset: ", header:get_YOffset());
	print("Width: ", header:get_Width());
	print("Height: ", header:get_Height());
	print("PixelDepth: ", header:get_PixelDepth());
	print(string.format("Descriptor: 0x%x", header:get_ImageDescriptor()));
end

function printDescription(descrip)
	print("Attributes: ", descrip:get_Attributes())
	print("LeftToRight: ", descrip:get_LeftToRight())
	print("TopToBottom: ", descrip:get_TopToBottom())
	print("Interleave: ", descrip:get_Interleave())
end

function test_Targa()
	local fHeader = TargaHead()

	fHeader:set_IDLength(0)
	fHeader:set_ColorMapType(0);
	fHeader:set_ImageType(2);
	fHeader:set_CMapStart(0);
	fHeader:set_CMapLength(0);
	fHeader:set_CMapDepth(0);

	-- Image description
	fHeader:set_XOffset(0);
	fHeader:set_YOffset(0);
	fHeader:set_Width(320);        -- Width of image in pixels
	fHeader:set_Height(240);        -- Height of image in pixels
	fHeader:set_PixelDepth(32);     -- How many bits per pixel
	fHeader:set_ImageDescriptor(0);

	--printHeader(fHeader)

	local descrip = ImageDescriptor(fHeader:get_ImageDescriptor())
	descrip:set_TopToBottom(1)
	--printDescription(descrip)
end

test_Targa()
