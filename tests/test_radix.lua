package.path = package.path..";..\\core\\?.lua"

local ffi = require "ffi"

require "radix"
require "memutils"

function printvalue(val)
	print(ffi.string(val))
end

function printIterator(iter)
	print("ITERATOR");
	print("iter type: ", ffi.typeof(iter))
	print("Depth: ", iter.depth);
    print("Count: ", iter.count);
    print("Node: ", iter.node);
    print("Next: ", iter.next_node);
end

function printNode(node)
	print("==== NODE ====");
	--print(string.format("%s: %s\n", ffi.string(node.key), ffi.string(node.val)));
	if node.key ~= nil then
		print("Key: ", ffi.string(node.key));
    end

	if node.val ~= nil then
		print("Val: ", ffi.string(node.val));
	else
		print("Val: NULL");
	end

--[[
	print("parent: ", node.parent);
	print("child: ", node.child);
	print("left: ", node.left);
	print("right: ", node.right);
--]]
end

function print_contents(radix)
    local iter = radix_iterator():new(radix)

--printIterator(iter)
    local node = iter:GetNext();
--printIterator(iter)


    while (node ~= nil) do
		printNode(node);
        node = iter:GetNext();
--printIterator(iter);
    end

end

function test_iterator()
	local trie = radix_t():new()
	print("radix: ", ffi.typeof(trie));

	trie:set_key("http://microsoft.com", "192.168.0.1");
	trie:set_key("http://microsoft.com/ftp", "192.168.0.2");
	trie:set_key("http://microsoft.com/web", "192.168.0.3");
	trie:set_key("machine1", "192.168.2.3");
	trie:set_key("machine2", "192.168.2.1");
	trie:set_key("machine22", "192.168.2.2");
	trie:set_key("machine3", "192.168.2.5");
	trie:set_key("machine4", "192.168.2.6");


	print_contents(trie)

end

function test_longestmatch()
	local radix = radix_t():new()

	radix:set_key("http://microsoft.com", "192.168.0.1");
	radix:set_key("http://microsoft.com/ftp", "192.168.0.2");
	radix:set_key("http://microsoft.com/web", "192.168.0.3");
	radix:set_key("machine1", "192.168.2.3");
	radix:set_key("machine2", "192.168.2.1");
	radix:set_key("machine22", "192.168.2.2");
	radix:set_key("machine3", "192.168.2.5");
	radix:set_key("machine4", "192.168.2.6");

	local m1 = radix:get_longest_match("http://microsoft.com")
	local m2 = radix:get_longest_match("http://microsoft.com/web")
	local m3 = radix:get_longest_match("machine2")
	local m4 = radix:get_longest_match("machine3")
	local m5 = radix:get_longest_match("machine4")

	print("m1: ");
	printvalue(m1);

	print("m2: ");
	printvalue(m2);
	printvalue(m3);
	printvalue(m4);

	--_trie_dump_contents(radix);

end

function test_add()
	local trie = radix_t():init("")

	trie:set_key("1", "William")
	trie:set_key("2", "Mubeen")

	assert(trie:get_key("1"),"key == 1")
	assert(trie:get_key("2"),"key == 2")
	assert(trie:get_key("3") == nil,"key == 3")

	--local str = ffi.string(ffi.cast("char *", match))
	--print("match: ", match, str)

	--print("Find 2: ", ffi.string())

--_trie_dump_contents(trie);
end

function test_strings()
	local str1 = ffi.new("char[256]");
	str1[0] = 0

--	print("str1 length: ", strlen(str1))


	local len1 = strlcat(str1, "1234", 256)

	print("Len1: ", len1)

	for i=0,len1-1 do
		io.write(string.char(str1[i]))
	end
	io.write("\n")

	local len2 = strlcat(str1, "6789", 256)
	print("Len2: ", len2)
	print(ffi.string(str1))

end

--test_add()

--test_strings()
test_longestmatch()
--test_iterator()
