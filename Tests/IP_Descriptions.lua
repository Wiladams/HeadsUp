IPv4Header_Info = {
	name = "IPv4Header";
	fields = {
		{name = "version", basetype = "uint8_t", subtype="bit", repeating = 4};
		{name = "headerlength", basetype = "uint8_t", subtype="bit", repeating = 4};
		{name = "typeofservice", basetype = "uint8_t"};
		{name = "totallength", basetype = "uint16_t"};
		{name = "identification", basetype = "uint16_t"};
		{name = "blank", basetype = "uint16_t", subtype="bit", repeating = 1};
		{name = "DF", basetype = "uint16_t", subtype="bit", repeating = 1};
		{name = "MF", basetype = "uint16_t", subtype="bit", repeating = 1};
		{name = "fragmentoffset", basetype = "uint16_t", subtype="bit", repeating = 13};
		{name = "ttl", basetype = "uint8_t"};
		{name = "protocol", basetype = "uint8_t"};
		{name = "headerchecksum", basetype = "uint16_t"};
		{name = "source", basetype = "uint32_t"};
		{name = "destination", basetype = "uint32_t"};
	};
};

IPv6Header_Info = {
	name = "IPv6Header";
	fields = {
		{name = "version", basetype = "uint32_t", subtype="bit", repeating = 4};
		{name = "priority", basetype = "uint32_t", subtype="bit", repeating = 4};
		{name = "flowlabel", basetype = "uint32_t", subtype="bit", repeating = 24};
		{name = "payloadlength", basetype = "uint16_t"};
		{name = "nextheader", basetype = "uint8_t"};
		{name = "hoplimit", basetype = "uint8_t"};
		{name = "source", basetype = "uint8_t", repeating = 16};
		{name = "destination", basetype = "uint8_t", repeating = 16};
	};
};
