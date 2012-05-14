local ffi = require "ffi"
local bit = require "bit"

local band = bit.band
local bswap = bit.bswap
local lshift = bit.lshift
local rshift = bit.rshift

require "BitBang"
require "memutils"

function htonl(var)
	if ffi.abi("be") then
		return var
	else
		return bswap(var)
	end
end

function ntohl(var)
	if ffi.abi("be") then
		return var
	else
		return bswap(var)
	end
end

function htons(var)
	if ffi.abi("be") then
		return band(var, 0xffff)
	else
		var = lshift(band(var, 0xffff), 16)
		return band(bswap(var), 0xffff)
	end
end

function ntohs(var)
	if ffi.abi("be") then
		return band(var, 0xffff)
	else
		var = lshift(band(var, 0xffff), 16)
		return band(bswap(var), 0xffff)
	end
end

function url_encode(str)
  if (str) then
    str = string.gsub (str, "\n", "\r\n")
    str = string.gsub (str, "([^%w ])",
        function (c) return string.format ("%%%02X", string.byte(c)) end)
    str = string.gsub (str, " ", "+")
  end
  return str
end

--[[
-- URL-decode input buffer into destination buffer.
-- 0-terminate the destination buffer. Return the length of decoded data.
-- form-url-encoded data differs from URI encoding in a way that it
-- uses '+' as character for space, see RFC 1866 section 8.2.1
-- http:--ftp.ics.uci.edu/pub/ietf/html/rfc1866.txt
static size_t url_decode(const char *src, size_t src_len, char *dst,
                         size_t dst_len, int is_form_url_encoded) {
  size_t i, j;
  int a, b;
#define HEXTOI(x) (isdigit(x) ? x - '0' : x - 'W')

  for (i = j = 0; i < src_len && j < dst_len - 1; i++, j++) {
    if (src[i] == '%' &&
        isxdigit(* (const unsigned char *) (src + i + 1)) &&
        isxdigit(* (const unsigned char *) (src + i + 2))) {
      a = tolower(* (const unsigned char *) (src + i + 1));
      b = tolower(* (const unsigned char *) (src + i + 2));
      dst[j] = (char) ((HEXTOI(a) << 4) | HEXTOI(b));
      i += 2;
    } else if (is_form_url_encoded && src[i] == '+') {
      dst[j] = ' ';
    } else {
      dst[j] = src[i];
    }
  }

  dst[j] = '\0'; -- nil-terminate the destination

  return j;
}
--]]


function is_valid_uri(uri)
  -- Conform to http:--www.w3.org/Protocols/rfc2616/rfc2616-sec5.html#sec5.1.2
  -- URI can be an asterisk (*) or should start with slash.
	return uri[0] == string.byte('/') or (uri[0] == string.byte('*') and uri[1] == 0);
end


function IS_DIRSEP_CHAR(c)
	return (c == string.byte('/') or c == string.byte('\\'))
end

-- Protect against directory disclosure attack by removing '..',
-- excessive '/' and '\' characters
-- WAA - use string.gsub?
function remove_double_dots_and_double_slashes(s)
	s = ffi.cast("char *", s);
	local p = s;

	while (s[0] ~= 0) do
		p[0] = s[0];
		s = s + 1;
		p = p + 1;
		if (IS_DIRSEP_CHAR(s[-1])) then
			-- Skip all following slashes and backslashes
			while (IS_DIRSEP_CHAR(s[0])) do
				s = s + 1;
			end

			-- Skip all double-dots
			while (s[0] == string.byte('.') and s[1] == string.byte('.')) do
				s = s + 2;
			end
		end
	end

	p[0] = 0;
end


function sockaddr_to_string(buf, len, usa)
  buf[0] = 0;

--  inet_ntop(usa.sa.sa_family, (void *) &usa.sin.sin_addr, buf, len);
end

--
-- scheme://domain:port/path?query_string#fragment_id
--
function parse_uri(uri)
	local schemapatt = "(%a+)://"
	local portpatt = ":(%d+)/?"
	local remainpatt = "(.*)"

	local pattern = schemapatt..remainpatt;

print("pattern: ", pattern);
	local scheme, therest = string.match(uri, pattern)
print("scheme: ", scheme,"  rest: ", therest)
	local portstr = string.match(therest, portpatt)
print("port: ", portstr);

	return scheme, portstr, therest
end

function parse_httpurl(str)
	local domainpart = "(%a*)"
	local portpart = ":(%d+)/?"
	local pattern = domainpart.."(%a*)"

	--for cap in string.gmatch(str, pattern) do
	--	print(cap)
	--end

	local portstr = string.match(str, portpart)

	return portstr;
end
