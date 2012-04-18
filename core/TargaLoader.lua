require "BitReader"

--[[
    // Targa Image file handling
    // Some reference documentation can be found here:
    // http://en.wikipedia.org/wiki/Truevision_TGA
--]]

ffi.cdef[[
typedef enum TargaColorMapType
{
	NoPalette = 0,
	Palette = 1
}TargaColorMapType;

enum HorizontalOrientation
{
        LeftToRight,
        RightToLeft
};

enum ImageOrigin
{
        OriginMask = 0x30,
        BottomLeft = 0x00,
        BottomRight = 0x10,
        TopLeft = 0x20,
        TopRight = 0x30
};

typedef enum
{
	NoImageData = 0,
	ColorMapped = 1,
	TrueColor = 2,
	Monochrome = 3,
	ColorMappedCompressed = 9,
	TrueColorCompressed = 10,
	MonochromeCompressed = 11,
}TargaImageType;

struct TargaHeader
{
	uint8_t IDLength;              	/* 00h  Size of Image ID field */
	TargaColorMapType ColorMapType;	/* 01h  Color map type */
	TargaImageType ImageType;   	/* 02h  Image type code */
	short CMapStart;            	/* 03h  Color map origin */
	short CMapLength;           	/* 05h  Color map length */
	uint8_t CMapDepth;             	/* 07h  Depth of color map entries */
	short XOffset;              	/* 08h  X origin of image */
	short YOffset;              	/* 0Ah  Y origin of image */
	short Width;                	// 0Ch  Width of image - Maximum 512
	short Height;               	// 0Eh  Height of image - Maximum 482
	uint8_t PixelDepth;            	/* 10h  Image pixel size */
	uint8_t ImageDescriptor;       	/* 11h  Image descriptor byte */
};

/* Bytes 0-3: The Extension Area Offset */
/* Bytes 4-7: The Developer Directory Offset */
/* Bytes 8-23: The Signature - "TRUEVISION-XFILE" */
/* Byte 24: ASCII Character “.” */
/* Byte 25: Binary zero string terminator (0x00) */

struct TargaFooter
{
	int		ExtensionAreaOffset;
	int 	DeveloperDirectoryOffset;
	char 	Signature[16];
	char 	Period;
	int8_t	BinaryZero;
};
]]

local TargaHeader = ffi.typeof("struct TargaHeader");
local TargaFooter = ffi.typeof("struct TargaFooter");

function printHeader(header)
	print("Color Map Type: ", header.ColorMapType);
	print("Image Type: ", header.ImageType);
	print("XOffset: ", header.XOffset);
	print("YOffset: ", header.YOffset);
	print("Width: ", header.Width);
	print("Height: ", header.Height);
	print("PixelDepth: ", header.PixelDepth);
	print(string.format("Descriptor: 0x%x", header.ImageDescriptor));
end


function CreatePixelArrayFromBytes(bytes)
	local tgaSize;
    local isExtendedFile;

	local fileLength = string.len(bytes);

	-- We'll use a binary reader to make it easier
	-- to get at the specific data types
	reader = BitReader();

	-- Targa images come in many different formats, and there are a couple of different versions
    -- of the specification.
    -- First thing to do is determine if the file is adhereing to version 2.0 of the spcification.
    -- We do that by reading a 'footer', which is the last 26 bytes of the file.

    local targaXFileID = "TRUEVISION-XFILE";
	local footer = nil;

	-- Get the last 26 bytes of the file so we can see if the signature
	-- is in there.
	local targaFooterBytes = bytes:sub(-26, fileLength);
	local targaFooterSignature = targaFooterBytes:sub(9,17);

	print("Targa Footer Bytes: ", targaFooterBytes);

	--local targaFooterSignature = System.Text.ASCIIEncoding.ASCII.GetString(targaFooterBytes, 8, 16);

	-- If the strings compare favorably, then we have a match for an extended
	-- TARGA file type.
	isExtendedFile = targaFooterSignature == targaXFileID;
	if (isExtendedFile) then
print("Extended File");
		-- Since we now know it's an extended file,
		-- we'll create the footer object and fill
		-- in the details.
		footer = TargaFooter();

		-- Of the 26 bytes we read from the end of the file
		-- the bytes are layed out as follows.
		-- Bytes 0-3: The Extension Area Offset
		-- Bytes 4-7: The Developer Directory Offset
		-- Bytes 8-23: The Signature
		-- Byte 24: ASCII Character “.”
		-- Byte 25: Binary zero string terminator (0x00)

		-- We take those raw bytes, and turn them into meaningful fields
		-- in the footer object.
		footer.ExtensionAreaOffset = BitConverter.ToInt32(targaFooterBytes, 0);
		footer.DeveloperDirectoryOffset = BitConverter.ToInt32(targaFooterBytes, 4);
		footer.Signature = targaFooterSignature;
		footer.Period = (byte)'.';
		footer.BinaryZero = 0;
	end

	-- Now create the header that we'll fill in
	fHeader = TargaHeader();

	-- Go to the beginning of the bytes
	local offset = 0;
	local mstream = ffi.cast("uint8_t *", bytes);

	fHeader.IDLength = reader:ReadByte(mstream); mstream = mstream +1;
	fHeader.ColorMapType = reader:ReadByte(mstream);  mstream = mstream +1;
	fHeader.ImageType = reader:ReadByte(mstream);  mstream = mstream +1;
	fHeader.CMapStart = reader:ReadInt16(mstream);  mstream = mstream +2;
	fHeader.CMapLength = reader:ReadInt16(mstream);  mstream = mstream +2;
	fHeader.CMapDepth = reader:ReadByte(mstream);  mstream = mstream +1;

	-- Image description
	fHeader.XOffset = reader:ReadInt16(mstream);  mstream = mstream +2;
	fHeader.YOffset = reader:ReadInt16(mstream);  mstream = mstream +2;
	fHeader.Width = reader:ReadInt16(mstream);  mstream = mstream +2;         -- Width of image in pixels
	fHeader.Height = reader:ReadInt16(mstream);  mstream = mstream +2;        -- Height of image in pixels
	fHeader.PixelDepth = reader:ReadByte(mstream);  mstream = mstream +1;     -- How many bits per pixel
	fHeader.ImageDescriptor = reader:ReadByte(mstream);  mstream = mstream +1;


printHeader(fHeader);

--[[
            /// The single byte that is the ImageDescriptor contains the following
            /// information.
            //  Bits 3-0 - number of attribute bits associated with each  |
            //               pixel.  For the Targa 16, this would be 0 or |
            //               1.  For the Targa 24, it should be 0.  For   |
            //               Targa 32, it should be 8.                    |
            //  Bit 4    - controls left/right transfer of pixels to
            ///             the screen.
            ///             0 = left to right
            ///             1 = right to left
            //  Bit 5    - controls top/bottom transfer of pixels to
            ///             the screen.
            ///             0 = bottom to top
            ///             1 = top to bottom
            ///
            ///             In Combination bits 5/4, they would have these values
            ///             00 = bottom left
            ///             01 = bottom right
            ///             10 = top left
            ///             11 = top right
            ///
            //  Bits 7-6 - Data storage interleaving flag.                |
            //             00 = non-interleaved.                          |
            //             01 = two-way (even/odd) interleaving.          |
            //             10 = four way interleaving.                    |
            //             11 = reserved.
--]]

	local desc = fHeader.ImageDescriptor;
	local attrBits = band(desc, 0x0F);
	local horizontalOrder = rshift(band(desc, 0x10), 4);
	local verticalOrder = rshift(band(desc, 0x20), 5);
	local interleave = rshift(band(desc, 0xC0), 6);


	-- We can't deal with the compressed image types, so if we encounter
	-- any of them, we'll just return null.
	if ((C.TrueColor ~= fHeader.ImageType) and (C.Monochrome ~= fHeader.ImageType)) then
		return nil;
	end

--[[
            PixmapOrientation pixmapOrientation = PixmapOrientation.BottomToTop;
            if (0 == verticalOrder)
                pixmapOrientation = PixmapOrientation.BottomToTop;
            else
                pixmapOrientation = PixmapOrientation.TopToBottom;
--]]

	local bytesPerPixel = fHeader.PixelDepth / 8;


	-- Skip past the Image Identification field if there is one
	--byte[] ImageIdentification;
	if (fHeader.IDLength > 0) then
		ImageIdentification = reader.ReadBytes(fHeader.IDLength);
		mstream = mstream + fHeader.IDLength
	end

	-- calculate image size based on bytes per pixel, width and height.
	local bytesPerRow = fHeader.Width * bytesPerPixel;
	local tgaSize = bytesPerRow * fHeader.Height;
	local imageData = Array1D(tgaSize, "uint8_t")
	ffi.copy(imageData, mstream, tgaSize);

	return imageData, fHeader.Width, fHeader.Height

end


function ReadTargaFromFile(filename)
	if ((nil == filename) or ("" == filename)) then
		return nil;
	end

	-- Open the file.
	local filestream = io.open(filename, 'rb')

	local bytes = filestream:read("*all")


	local data, width, height = CreatePixelArrayFromBytes(bytes);

	filestream:close();

	return data, width, height;
end




