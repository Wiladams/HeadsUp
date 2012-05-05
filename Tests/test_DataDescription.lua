package.path = package.path..";c:/repos/HeadsUp/core/?.lua"

local ffi = require "ffi"


require "BanateCore"
require "DataDescription"
require "IP_Descriptions"



ffi.cdef(
CStructFromTypeInfo(IPv4Header_Info)..
CStructFromTypeInfo(IPv6Header_Info)
);


IPv4Header = ffi.typeof("IPv4Header");
IPv6Header = ffi.typeof("IPv6Header");

--print(CStructFromTypeInfo(IPv4Header_Info))
--print(CStructFromTypeInfo(IPv6Header_Info))



Person_Info = {
	name = "Person";
	fields = {
		{name = "First", basetype = "char", subtype="string", repeating = 20};
		{name = "Middle", basetype = "char", subtype="string", repeating = 20};
		{name = "Last", basetype = "char", subtype="string", repeating = 20};
		{name = "Age", basetype = "uint16_t"};
		{name = "City", basetype = "char", subtype="string", repeating = 32};
		{name = "State", basetype = "char", subtype="string", repeating = 32};
		{name = "Zip", basetype = "char", subtype="string", repeating = 10};
	};
};


local function CreateClasses()
	local c1 = CreateBufferClass(Person_Info)
print(c1)
	local f = loadstring(c1)
	f()
end


function createPerson()
	-- create an instance of the Class
	-- and fill it up with Data
	local p = Person();

	p:set_First("William");
	p:set_Middle("Albert");
	p:set_Last("Adams");
	p:set_Age(47);
	p:set_City("Bellevue");
	p:set_State("Washington");
	p:set_Zip("98004");

	return p;

end

function printPerson(p)
	print("First: ", p:get_First())
	print("Middle: ", p:get_Middle())
	print("Last: ", p:get_Last())
	print("Age: ", p:get_Age())
	print("City: ", p:get_City())
	print("State: ", p:get_State())
	print("Zip: ", p:get_Zip())

end


CreateClasses();

local p = createPerson();
printPerson(p)
