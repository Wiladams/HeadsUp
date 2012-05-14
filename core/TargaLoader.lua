require "BinaryStreamReader"
require "DataDescription"

--[[
    // Targa Image file handling
    // Some reference documentation can be found here:
    // http://en.wikipedia.org/wiki/Truevision_TGA
--]]

-- ImageType
NoImageData = 0;
ColorMapped = 1;
TrueColor = 2;
Monochrome = 3;
ColorMappedCompressed = 9;
TrueColorCompressed = 10;
MonochromeCompressed = 11;

-- HorizontalOrientation
LeftToRight = 0;
RightToLeft = 1;

-- ImageOrigin
OriginMask 	= 0x30;
BottomLeft 	= 0x00;
BottomRight = 0x10;
TopLeft 	= 0x20;
TopRight 	= 0x30;

-- TargaColorMapType
NoPalette = 0;
Palette = 1;


TargaHead_Info = {
	name = "TargaHead";
	fields = {
		{name = "IDLength", basetype = "uint8_t"};
		{name = "ColorMapType", basetype = "uint8_t"};
		{name = "ImageType", basetype = "uint8_t"};
		{name = "CMapStart", basetype = "uint16_t"};
		{name = "CMapLength", basetype = "uint16_t"};
		{name = "CMapDepth", basetype = "uint8_t"};
		{name = "XOffset", basetype = "uint16_t"};
		{name = "YOffset", basetype = "uint16_t"};
		{name = "Width", basetype = "uint16_t"};
		{name = "Height", basetype = "uint16_t"};
		{name = "PixelDepth", basetype = "uint8_t"};

--		{name = "ImageDescriptor", basetype = "uint8_t"};
		{name = "Attributes", basetype = "uint8_t", subtype="bit", repeating=4};
		{name = "LeftToRight", basetype = "uint8_t", subtype="bit", repeating=1};
		{name = "TopToBottom", basetype = "uint8_t", subtype="bit", repeating=1};
		{name = "Interleave", basetype = "uint8_t", subtype="bit", repeating=2};
	};
};

--[[
/* Bytes 0-3: The Extension Area Offset */
/* Bytes 4-7: The Developer Directory Offset */
/* Bytes 8-23: The Signature - "TRUEVISION-XFILE" */
/* Byte 24: ASCII Character “.” */
/* Byte 25: Binary zero string terminator (0x00) */
--]]

TargaFoot_Info = {
	name = "TargaFoot";
	fields = {
		{name = "ExtensionAreaOffset", basetype = "uint32_t"};
		{name = "DeveloperDirectoryOffset", basetype = "uint32_t"};
		{name = "Signature", basetype = "char", repeating = 16};
		{name = "Period", basetype = "char"};
		{name = "BinaryZero", basetype = "uint8_t"};
	};
};

--[[
 The single byte that is the ImageDescriptor contains the following
 information.
  Bits 3-0 - number of attribute bits associated with each  |
               pixel.  For the Targa 16, this would be 0 or |
               1.  For the Targa 24, it should be 0.  For   |
               Targa 32, it should be 8.                    |
  Bit 4    - controls left/right transfer of pixels to
             the screen.
             0 = left to right
             1 = right to left
  Bit 5    - controls top/bottom transfer of pixels to
             the screen.
             0 = bottom to top
             1 = top to bottom

             In Combination bits 5/4, they would have these values
             00 = bottom left
             01 = bottom right
             10 = top left
             11 = top right

  Bits 7-6 - Data storage interleaving flag.                |
             00 = non-interleaved.                          |
             01 = two-way (even/odd) interleaving.          |
             10 = four way interleaving.                    |
             11 = reserved.
--]]

ImageDescriptor_Info = {
	name = "ImageDescriptor";
	fields = {
		{name = "_bytevalue", basetype = "uint8_t", offset=0};
		{name = "Attributes", basetype = "uint8_t", subtype="bit", repeating=4};
		{name = "LeftToRight", basetype = "uint8_t", subtype="bit", repeating=1};
		{name = "TopToBottom", basetype = "uint8_t", subtype="bit", repeating=1};
		{name = "Interleave", basetype = "uint8_t", subtype="bit", repeating=2};
	};
};


local function CreateTargaClasses()
	local header = CreateBufferClass(TargaHead_Info)
--print(header)
	local f = loadstring(header)
	f()

	local footer = CreateBufferClass(TargaFoot_Info)
	f = loadstring(footer)
	f()

	local descriptor = CreateBufferClass(ImageDescriptor_Info)
	f = loadstring(descriptor)
	f()
end

function printHeader(header)
	print(string.format("Width: %d", header:get_Width()))
	print(string.format("Height: %d", header:get_Height()))
	print(string.format("ImageType: %d", header:get_ImageType()))

	-- Image Description
	print(string.format("Left To Right: %d", header:get_LeftToRight()))
	print(string.format("Top To Bottom: %d", header:get_TopToBottom()))
end


function CreatePixelArrayFromBytes(bytes, size)
	local tgaSize;
    local isExtendedFile;

	local fileLength = size;

	local fHeader = TargaHead(bytes, size)
--printHeader(fHeader)

	local targaXFileID = "TRUEVISION-XFILE";
	-- Get the last 26 bytes of the file so we can see if the signature
	-- is in there.
	local footerPtr = bytes+size - 26;
	local footer = TargaFoot(footerPtr, 26)
	local targaFooterSignature = ffi.string(footer:get_Signature())

	-- If the strings compare favorably, then we have a match for an extended
	-- TARGA file type.
	local isExtendedFile = targaFooterSignature == targaXFileID;



	-- We can't deal with the compressed image types, so if we encounter
	-- any of them, we'll just return null.
	if ((TrueColor ~= fHeader:get_ImageType()) and (Monochrome ~= fHeader:get_ImageType())) then
		return nil;
	end


	local bytesPerPixel = fHeader:get_PixelDepth() / 8;


	-- Skip past the Image Identification field if there is one
	--byte[] ImageIdentification;
	if (fHeader:get_IDLength() > 0) then
		ImageIdentification = reader:ReadBytes(fHeader:get_IDLength());
	end

   -- We'll use a binary reader to make it easier
	-- to get at the specific data types
	local reader = BinaryStreamReader.CreateForBytes(bytes, size)

	-- calculate image size based on bytes per pixel, width and height.
	local bytesPerRow = fHeader:get_Width() * bytesPerPixel;
	local tgaSize = bytesPerRow * fHeader:get_Height();
	local imageData = Array1D(tgaSize, "uint8_t")
	ffi.copy(imageData, reader.Bytes+reader.Position, tgaSize);

	return imageData, fHeader
end


function bytesFromFile(file)
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

function ReadTargaFromFile(filename)
	if ((nil == filename) or ("" == filename)) then
		return nil;
	end

	local f = assert(io.open(filename, "rb"), "unable to open file")

	if not f then return nil end

	local str = f:read("*all")
	local size = string.len(str)
	local bytes = ffi.cast("uint8_t*", str)


	local data, header = CreatePixelArrayFromBytes(bytes, size);

	f:close()


	return data, header:get_Width(), header:get_Height();
end


CreateTargaClasses()




