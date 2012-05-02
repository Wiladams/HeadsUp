--[[
	A prototypical data structure contains the following:

Person = {
	name = "Person",
	fields={
		{name = "id", datatype="int32_t", status="required", ordinal=1};
		{name = "name", datatype="string", status="optional", ordinal=2};
		{name = "email", datatype="string", status="optional", ordinal=3};
	};
};

A field has these basic attributes
    name			- Name of the field.  This is optional
    datatype		- a string of a ctype, or a table of another known type
	repeating		- A count of the number of instances of this type
	status 			- Whether the field is 'optional' or 'required'
	ordinal			- The position within the data structure.  This is optional

So, the description of the field itself would be:

Field = {
	name = "field",
	fields = {
		{name = "name", datatype = "string", required = false, ordinal =1};
		{name = "datatype", datatype = "string", required = true, ordinal =2};
		{name = "repeating", datatype = "int32_t", required = false, ordinal =3};
		{name = "required", datatype = "bool", required = false, ordinal =4};
		{name = "ordinal", datatype = "int32_t", required = false, ordinal =5};
	};
};


--]]





function CStructFieldFromTypeInfo(field)
	if not field.basetype then return nil end;

	if field.subtype == "bit" then
		local repeating = field.repeating or 1
		return string.format("%s %s : %d;", field.basetype, field.name, repeating);
	end

	if field.repeating and field.repeating > 1 then
		return string.format("%s %s[%d];",field.basetype, field.name, field.repeating);
	end

	if field.basetype == "string" then
		return string.format("char* %s;", field.name);
	end

	return string.format("%s %s;", field.basetype, field.name);
end

function CStructFromTypeInfo(desc)
	local strucstr = {};

	table.insert(strucstr, string.format("typedef struct %s {\n", desc.name));
	for _,field in ipairs(desc.fields) do
		table.insert(strucstr, string.format("\t%s\n", CStructFieldFromTypeInfo(field)));
	end
	table.insert(strucstr, string.format("} %s;\n", desc.name));

	return table.concat(strucstr);
end





local FieldSerializerFuncs = {
	int8_t = {reader = "ReadByte", writer= "WriteByte"},
	uint8_t = {reader = "ReadByte", writer= "WriteByte"},
	bool = {reader = "ReadByte", writer= "WriteByte"},
	char = {reader= "ReadByte", writer= "WriteByte"},
	int16_t = {reader= "ReadInt16", writer= "WriteInt16"},
	uint16_t = {reader= "ReadUInt16", writer= "WriteUInt16"},
	int32_t = {reader= "ReadInt32", writer= "WriteInt32"},
	uint32_t = {reader= "ReadUInt32", writer= "WriteUInt32"},
	single = {reader= "ReadSingle", writer= "WriteSingle"},
	double = {reader= "ReadDouble", writer= "WriteDouble"},
	string = {reader= "ReadString", writer= "WriteString"},
};

function CFieldSerializer(field)
	local entry = FieldSerializerFuncs[field.basetype]

	if not entry then return nil end

	local retValue = "stream:"..entry.writer.."(value."..field.name..");\n";
	return retValue;
end

function CFieldDeSerializer(field)
	local entry = FieldSerializerFuncs[field.basetype]

	if not entry then return nil end

	local retValue = "value."..field.name.." = stream:"..entry.reader.."();\n";
	return retValue;
end

function CTypeSerializer(info)
	local strtbl = {}

	table.insert(strtbl, string.format("function write_%s_ToStream(stream, value)\n", info.name));
	for i,field in ipairs(info.fields) do
	    table.insert(strtbl,'\t'..CFieldSerializer(field));
	end
	table.insert(strtbl, string.format("end"));

	return table.concat(strtbl);
end

function CTypeDeSerializer(info)
	local strtbl = {}

	table.insert(strtbl, string.format("function read_%s_FromStream(stream, value)\n", info.name));
	for i,field in ipairs(info.fields) do
	    table.insert(strtbl,'\t'..CFieldDeSerializer(field));
	end
	table.insert(strtbl, string.format("end"));

	return table.concat(strtbl);
end


