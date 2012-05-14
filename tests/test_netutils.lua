package.path = package.path..";..\\core\\?.lua";

local ffi = require "ffi"

require "netutils"
require "rest_util"
require "Buffer"

function test_long()
	local var = 0xAABBCCDD
	local netvar = htonl(var)
	local back = ntohl(netvar)

	print(string.format("Native: 0x%X", var))
	print(string.format("   Net: 0x%X", netvar))
	print(string.format("  Back: 0x%X", back))
end

function test_short()
	local var = 0x1234
	local netvar = htons(var)
	local back = ntohs(netvar)

	print("Native: ", numbertobinary(var, 16, true), var)
	print("   Net: ", numbertobinary(netvar, 16, true), netvar)
	print("  Back: ", numbertobinary(back, 16, true), back)
end

function test_BufferInt()
	local buff = Buffer():Initialize(512)
	print("Buff Size: %d", buff.Size)

	local written = write_variable_int(buff.Data+buff.Index, 0xff)
	print("Written (0xff): ", written)

	written = write_variable_int(buff.Data+buff.Index, 0xffff)
	print("Written (0xffff): ", written)

	written = write_variable_int(buff.Data+buff.Index, 0xffffff)
	print("Written (0xffffff): ", written)

	written = write_variable_int(buff.Data+buff.Index, 0xffffffff)
	print("Written (0xffffff): ", written)

end

function test_URL()
	local url = "http://www.william.com"
	local encoded = url_encode(url)

	print("encoded: ", encoded)
end

function test_hextodecimal()

--[[
print(HEXTOI("a"))
print(HEXTOI("b"))
print(HEXTOI("c"))
print(HEXTOI("d"))
print(HEXTOI("e"))
print(HEXTOI("f"))

print(HEXTOI("3"))
--]]

	local buff = Buffer():Initialize(512)
	buff.Data[0] = string.byte("f")
	buff.Data[1] = string.byte("F")
	buff.Data[2] = string.byte("g")
	buff.Data[3] = string.byte("1")

	for i=0,3 do
--		print(i, isxdigit(buff.Data[i]))
		print(i, string.char(buff.Data[i]), isxdigit(buff.Data[i]))
	end
end


function test_get_variable()
	--print(strncmp("hello", "hello", 4))

	local buffer = "name=William "
	local bufflen = string.len(buffer)

	local output = ffi.new("char[256]")
	local output_len = 256
	local is_form = false

	local res = get_variable("name", buffer, bufflen, output, output_len, is_form)

	print("get_variable, res: ", res)
	print("output: ", ffi.string(output))
end

function test_memchr()
	name = "William"
	ptr = ffi.cast("char *", name)
	len = string.len(name)
	print("length: ", len)
	for i=0,len-1 do
		print(string.char(ptr[i]))
	end
end

function test_uri_parse()
-- scheme://domain:port/path?query_string#fragment_id
	local strs = {
		"http://www.google.com:8080",
		--"www.google.com",
	}


	for _,str in ipairs(strs) do
		local scheme, port, therest = parse_uri(str);
--[[
		print("==== URI ====");
		print("scheme: ", scheme);
		print("port: ", port);
		print("remain: ", therest);
--]]
	end


	--portpart = parse_httpurl("www.google.com:80/");
	--print("port: ", portpart);
end

--test_hextodecimal()
--test_BufferInt()
--test_URL()
--test_short()
--test_long()
--test_loop
--test_get_variable()
test_uri_parse();
