local ffi = require "ffi"

require "memutils"
require "netutils"

local byte_0 = string.byte('0')
local byte_9 = string.byte('9')
local byte_A = string.byte('A')

function isdigit(c)
	return c >= byte_0 and c <= byte_9
end

function isxdigit(c)
	return string.find("0123456789abcdefABCDEF", string.char(c),1,true) ~= nil
end

function HEXTOI(x)
	x = string.byte(x:upper())
	if isdigit(x) then
		return x - string.byte('0')
	else
		return  x - byte_A + 10
	end
end


--Copied from mongoose http server
function decode(src, srclen, dst, dstlen, is_form)
	local  i, j;
	local a, b;

	local i=0
	local j=0
	while (i<srclen-1 and j<dstlen-2) do
		if (src[i] == string.byte('%') and
			isxdigit((src + i + 1)) and
			isxdigit((src + i + 2))) then

			a = ((src + i + 1));
			b = ((src + i + 2));
			dst[j] = band(bor(lshift(HEXTOI(a), 4), HEXTOI(b)), 0xff);
			i = i+ 2;
		elseif (is_form and src[i] == string.byte('+')) then
			dst[j] = string.byte(' ');
		else
			dst[j] = src[i];
		end
		j = j + 1
		i = i + 1
	end

	dst[j] = 0;  -- Null-terminate the destination

	return ( i == srclen );
end

function get_variable(name, buffer, buflen, output, output_len, decode_type)
	buffer = ffi.cast("char *", buffer)
	output = ffi.cast("char *", output)

	local end_of_value;

	--initialize the output buffer first
	output[0] = 0;

	local var_len = string.len(name);
	local ending = buffer + buflen;

	local start = buffer
	while start < ending-var_len do
		if (start == buffer or start[-1] == string.byte('&')) and
			start[var_len] == string.byte('=') and
			(strncmp(name, start, var_len)==0) then
			-- Point p to variable value
			start = start + var_len + 1;

			-- Point s to the end of the value
			end_of_value = memchr(start, '&', ending - start);
			if (end_of_value == nil) then
				end_of_value = ending;
			end

			return decode(start, end_of_value - start, output, output_len, decode_type);
		end
		start = start + 1
	end

	return 0;
end


function read_int(buf, size)
	local data = bittypes()

	if (size >= 1 and size <= 4) then
		ffi.copy(data.bytes + 4 - size, buf, size);
	end

	return ntohl(data.UInt32);
end


function write_int(buf, data, size)

	local success = 0;

	if (size >= 1 and size <= 4) then
		local bt = bittypes()
		bt.UInt32 = htonl(data);
		ffi.copy(buf, bt.bytes + 4 - size, size);
		success = size;
	end

	return success;
end


function write_variable_int(buf, data)
	local size = 4;
	if (data <= 0xFF) then
		size = 1;
	elseif (data <= 0xFFFF) then
		size = 2;
	elseif (data <= 0xFFFFFF) then
		size = 3;
	end

	return write_int(buf, data, size);
end


function log_2(value)
	local result = 0;

	repeat
		value = rshift(value,1);
		result = result + 1;
	until (value == 0);

	if result > 0 then return result-1 end

	return result
end
