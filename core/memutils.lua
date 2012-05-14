local ffi = require "ffi"
local bit = require "bit"
local band = bit.band
local bor = bit.bor
local rshift = bit.rshift
local lshift = bit.lshift

--[[
	binary functions

	ARRAY_SIZE
	NewStruct
	isbyte
	bzero
	bcopy
	bcmp
--]]

function ARRAY_SIZE(array)
	local typestr = tostring(ffi.typeof(array))

	--local elemtype, nelem = string.match(typestr, "ctype<(%w+)%s+%[(%d+)%]>")
	local nelem = string.match(typestr, "(%d+)")

	return tonumber(nelem)
end


function NewStruct(structname)
	if not cast then return nil end

	local size = ffi.sizeof(structname)
	return ffi.cast(structname,ffi.new("uint8_t["..size.."]"));
end


function isbyte(n)
	return band(n,0xff) == n
end

function bzero(dest, nbytes)
	ffi.fill(dest, nbytes)
	return dest
end

function bcopy(src, dest, nbytes)
	ffi.copy(dest, src, nbytes)
end

function bcmp(ptr1, ptr2, nbytes)
	for i=0,nbytes do
		if ptr1[i] ~= ptr2[i] then return -1 end
	end

	return 0
end

--[[
	Memory functions

	memchr(const void *buf, int val, size_t maxCount);
	memcmp(const void *buf1, const void *buf2, size_t size);
	memcpy_s(void *dst, int dstSize, const void *src, size_t maxCount)
	memset(void * dst, int val, size_t size)
--]]

function memset(dest, c, len)
	ffi.fill(dest, len, c)
	return dest
end

function memcpy(dest, src, nbytes)
	ffi.copy(dest, src, nbytes)
end

function memcmp(ptr1, ptr2, nbytes)
	local p1 = ffi.cast("uint8_t *", ptr1)
	local p2 = ffi.cast("uint8_t *", ptr2)

	for i=0,nbytes do
		if p1[i] ~= p2[i] then return -1 end
	end

	return 0
end

function memchr(ptr, value, num)
	ptr = ffi.cast("uint8_t *", ptr)
	for i=0,num-1 do
		if ptr[i] == value then return ptr+i end
	end

	return nil
end

function memmove(dst, src, num)
	local srcptr = ffi.cast("uint8_t*", src)

	-- If equal, just return
	if dst == srcptr then return dst end


	if srcptr < dst then
		-- copy from end
		for i=num-1,0, -1 do
			dst[i] = srcptr[i];
		end
	else
		-- copy from beginning
		for i=0,num-1 do
			dst[i] = srcptr[i];
		end
	end
	return dst
end



--[[
	String Functions

	strlen
	strndup
	strdup
	strcpy
	strlcpy
	strlcat

	strchr
	strcmp
	strncmp
	strcasecmp
	strncasecmp

	strrchr
	strstr

	strpbrk

	bin2str
--]]



function strcmp(s1, s2)
	local s1ptr = ffi.cast("uint8_t *", s1);
	local s2ptr = ffi.cast("uint8_t *", s2);

	-- uint8_t
	local uc1;
	local uc2;

	-- Move s1 and s2 to the first differing characters
	-- in each string, or the ends of the strings if they
	-- are identical.
	while (s1ptr[0] ~= 0 and s1ptr[0] == s2ptr[0]) do
		s1ptr = s1ptr + 1
		s2ptr = s2ptr + 1
	end

     -- Compare the characters as unsigned char and
     --   return the difference.
     uc1 = s1ptr[0];
     uc2 = s2ptr[0];

	if (uc1 < uc2) then
		return -1
	elseif (uc1 > uc2) then
		return 1
	end

	return 0
end


function strncmp(str1, str2, num)
	local ptr1 = ffi.cast("uint8_t*", str1)
	local ptr2 = ffi.cast("uint8_t*", str2)

	for i=0,num-1 do
		if str1[i] == 0 or str2[i] == 0 then return 0 end

		if ptr1[i] > ptr2[i] then return 1 end
		if ptr1[i] < ptr2[i] then return -1 end
	end

	return 0
end

function strncasecmp(str1, str2, num)
	local ptr1 = ffi.cast("uint8_t*", str1)
	local ptr2 = ffi.cast("uint8_t*", str2)

	for i=0,num-1 do
		if str1[i] == 0 or str2[i] == 0 then return 0 end

		if ptr1[i] > ptr2[i] then return 1 end
		if ptr1[i] < ptr2[i] then return -1 end
	end

	return 0
end


function strcasecmp(str1, str2)
	local ptr1 = ffi.cast("uint8_t*", str1)
	local ptr2 = ffi.cast("uint8_t*", str2)

	local num = math.min(strlen(ptr1), strlen(ptr2))
	for i=0,num-1 do
		if str1[i] == 0 or str2[i] == 0 then return 0 end

		if ptr1[i] > ptr2[i] then return 1 end
		if ptr1[i] < ptr2[i] then return -1 end
	end

	return 0
end

function strlen(str)
	local idx = 0
	while str[idx] ~= 0 do
		idx = idx + 1
	end

	return idx
end

function strndup(str,n)
	local len = strlen(str)
	local len = math.min(n,len)

	local newstr = ffi.new("char["..(len+1).."]");
	ffi.copy(newstr, str, len)
	newstr[len] = 0

	return newstr
end

function strdup(str)
	str = ffi.cast("char *", str)
	local len = strlen(str)

	local newstr = ffi.new("char["..(len+1).."]");
	ffi.copy(newstr, str, len)
	newstr[len] = 0

	return newstr
end

function strcpy(dst, src)
	local dstptr = ffi.cast("char *", dst)
	local srcptr = ffi.cast("char *", src)

     -- Do the copying in a loop.
     while (dstptr[0] ~= 0 and srcptr[0] ~= 0) do
		dstptr[0] = srcptr[0];
		dstptr = dstptr + 1;
		srcptr = srcptr + 1;
     end

	-- Return the destination string.
	return dst;
end

function strlcpy(dst, src, size)
	local dstptr = ffi.cast("char *", dst)
	local srcptr = ffi.cast("char *", src)

	local len = strlen(src)
	local len = math.min(size-1,len)

	ffi.copy(dstptr, srcptr, len)
	dstptr[len] = 0

	return len
end

function strlcat(dst, src, size)

	local dstptr = ffi.cast("char *", dst)
	local srcptr = ffi.cast("char *", src)

	local dstlen = strlen(dstptr);
	local dstremaining = size-dstlen-1
	local srclen = strlen(srcptr);
	local len = math.min(dstremaining, srclen)


	for idx=dstlen,dstlen+len do
		dstptr[idx] = srcptr[idx-dstlen];
	end

	return dstlen+len
end



function strchr(s, c)
	while s[0] ~= c do
		if s[0] == 0 then
			return nil
		end
		s = s + 1;
	end

	return s
end


function strstr(str, target)

	if (target == nil or target[0] == 0) then
		return str;
	end

	local p1 = str;

	while (p1[0] ~= 0) do

		local p1Begin = p1;
		local p2 = target;

		while (p1[0]~=0 and p2[0]~=0 and p1[0] == p2[0]) do
			p1 = p1 + 1;
			p2 = p2 + 1;
		end

		if (p2[0] == 0) then
			return p1Begin;
		end

		p1 = p1Begin + 1;
	end

	return nil;
end


--[[
	String Helpers
--]]
function strtoull(x, y, z)
	return strtoul(x, y, z)
end

function strtoll(x, y, z)
	return strtol(x, y, z)
end


-- Given two null terminated strings
function string_same(a, b)
    local bytes = 0;

    while (a[bytes] ~= 0 and b[bytes] ~= 0 and a[bytes] == b[bytes]) do
		bytes = bytes+1
    end

    return bytes;
end

-- Stringify binary data. Output buffer must be twice as big as input,
-- because each byte takes 2 bytes in string representation
local hex = strdup("0123456789abcdef");

function bin2str(to, p, len)
--print("bin2str, len: ", len);
	local off1, off2;
	while (len > 0) do
		off1 = rshift(p[0], 4)

		to[0] = hex[off1];
		to = to + 1;
		off2 = band(p[0], 0x0f);
		to[0] = hex[off2];
		to = to + 1;
		p = p + 1;
		len = len - 1;

--		print(off1, off2);
	end
	to[0] = 0;
end
