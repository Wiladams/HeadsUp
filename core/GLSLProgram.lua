class.GPUShader();

function GPUShader:_init(stype, text)

	self.ShaderType = stype;

	local src_array = ffi.new("char*[1]", ffi.cast("char *",text));
	local lpSuccess = ffi.new("int[1]");

	self.ID = ogm.glCreateShader(stype);
	ogm.glShaderSource(self.ID, 1, src_array, nil);
	ogm.glCompileShader(self.ID);

	ogm.glGetShaderiv(self.ID, GL_COMPILE_STATUS, lpSuccess);

	self.CompileStatus = lpSuccess[0];

		if(success == 0) then
--[[
		int info_len;
		char *info_log;

		glGetObjectParameterivARB(sdr, GL_OBJECT_INFO_LOG_LENGTH_ARB, &info_len);
		if(info_len > 0) {
			if(!(info_log = malloc(info_len + 1))) {
				perror("malloc failed");
				return 0;
			}
			glGetInfoLogARB(sdr, info_len, 0, info_log);
			fprintf(stderr, "shader compilation failed: %s\n", info_log);
			free(info_log);
		} else {
			fprintf(stderr, "shader compilation failed\n");
		}
		return 0;
--]]
	end
end



function CreateShaderFromFile(fname, stype)
	local fp = io.open(fname, "r");
	local src_buf = fp:read("*all");

	local shader = GPUShader(GL_FRAGMENT_SHADER, src_buf)

	fp:close();

	return shader;
end






GPUProgram = {}
GPUProgram_mt = {}

function GPUProgram.new(fragtext, vertext)
	local self = {}

	self.ID = ogm.glCreateProgram();

	if fragtext ~= nil then
		self.FragmentShader = GPUShader(GL_FRAGMENT_SHADER, fragtext);
		GPUProgram.AttachShader(self, self.FragmentShader);
	end

	if vertext ~= nil then
		self.VertexShader = GPUShader(GL_VERTEX_SHADER, vertext);
		GPUProgram.AttachShader(self, self.VertexShader);
	end

	GPUProgram.Link(self)

	setmetatable(self, GPUProgram_mt)

	return self
end

function GPUProgram:AttachShader(shader)
	ogm.glAttachShader(self.ID, shader.ID);
end

function GPUProgram:Link()
	ogm.glLinkProgram(self.ID);

	local lpLinked = ffi.new("int[1]");
	ogm.glGetProgramiv(self.ID, GL_LINK_STATUS, lpLinked);
	self.LinkStatus = lpLinked[0];

	if(0 == linked) then
		print("shader linking failed");
	end
end


function GPUProgram:Use()
	ogm.glUseProgram(self.ID);
end


function GetUniform(self, name)
	local loc = ogm.glGetUniformLocation(self.ID, name);

	if loc < 0 then return nil; end

	local lpsize = ffi.new("int[1]");
	local lputype = ffi.new("int[1]");
	local buff = Array1D(256, "char");
	local bufflen = 255;
	local lplength = ffi.new("int[1]");

	ogm.glGetActiveUniform (self.ID, loc, bufflen, lplength, lpsize, lputype, buff);
	local size = lpsize[0];
	local utype = lputype[0];
	local namelen = lplength[0];
	local iname = ffi.string(buff);
--[[
	print("==========");
	print("Name: ", name);
	print("Location: ", loc);
	print(string.format("Type: 0x%x", utype));
	print("Size: ", size);
	print("IName: ", ffi.string(buff), namelen);
--]]
	return loc, utype, size;
end

-- This table of properties helps in the
-- process of retrieving and setting uniform
-- values of a shader
local uniformprops = {}
uniformprops[GL_FLOAT]		= {1, "float", ogm.glGetUniformfv, ogm.glUniform1fv, 1, "float[1]"};
uniformprops[GL_FLOAT_VEC2]	= {2, "float", ogm.glGetUniformfv, ogm.glUniform2fv, 1, "float[2]"};
uniformprops[GL_FLOAT_VEC3]	= {3, "float", ogm.glGetUniformfv, ogm.glUniform3fv, 1, "float[3]"};
uniformprops[GL_FLOAT_VEC4]	= {4, "float", ogm.glGetUniformfv, ogm.glUniform4fv, 1, "float[4]"};

uniformprops[GL_INT]		= {1, "int", ogm.glGetUniformiv, ogm.glUniform1iv, 1, "int[1]"};
uniformprops[GL_INT_VEC2]	= {2, "int", ogm.glGetUniformiv, ogm.glUniform2iv, 1, "int[2]"};
uniformprops[GL_INT_VEC3]	= {3, "int", ogm.glGetUniformiv, ogm.glUniform3iv, 1, "int[3]"};
uniformprops[GL_INT_VEC4]	= {4, "int", ogm.glGetUniformiv, ogm.glUniform4iv, 1, "int[4]"};

uniformprops[GL_BOOL]		= {1, "int", ogm.glGetUniformiv, ogm.glUniform1iv, 1, "int[1]"};
uniformprops[GL_BOOL_VEC2]	= {2, "int", ogm.glGetUniformiv, ogm.glUniform2iv, 1, "int[2]"};
uniformprops[GL_BOOL_VEC3]	= {3, "int", ogm.glGetUniformiv, ogm.glUniform3iv, 1, "int[3]"};
uniformprops[GL_BOOL_VEC4]	= {4, "int", ogm.glGetUniformiv, ogm.glUniform4iv, 1, "int[4]"};

uniformprops[GL_FLOAT_MAT2]	= {4, "float", ogm.glGetUniformfv, ogm.glUniformMatrix2fv, 1, "float[4]"};
uniformprops[GL_FLOAT_MAT3]	= {9, "float", ogm.glGetUniformfv, ogm.glUniformMatrix3fv, 1, "float[9]"};
uniformprops[GL_FLOAT_MAT4]	= {16, "float", ogm.glGetUniformfv, ogm.glUniformMatrix4fv, 1, "float[16]"};

uniformprops[GL_SAMPLER_1D]		= {1, "int", ogm.glGetUniformiv, ogm.glUniform1iv, 1, "int[1]"};
uniformprops[GL_SAMPLER_1D_SHADOW]		= {1, "int", ogm.glGetUniformiv, ogm.glUniform1iv, 1, "int[1]"};
uniformprops[GL_SAMPLER_2D]	= {1, "int", ogm.glGetUniformiv, ogm.glUniform1iv, 1, "int[1]"};
uniformprops[GL_SAMPLER_2D_SHADOW]	= {1, "int", ogm.glGetUniformiv, ogm.glUniform1iv, 1, "int[1]"};
uniformprops[GL_SAMPLER_3D]	= {1, "int", ogm.glGetUniformiv, ogm.glUniform1iv, 1, "int[1]"};
uniformprops[GL_SAMPLER_CUBE]	= {1, "int", ogm.glGetUniformiv, ogm.glUniform1iv, 1, "int[1]"};


function GetUniformValue(self, name)
	local loc, utype, size = GetUniform(self, name);

	if loc == nil then return nil end;

	local uprops = uniformprops[utype];
--[[
	print("================")
	print("GPUProgram:GetUniformValue")
	print("Name: ", name);
	print("Loc: ", loc);
	print("Size: ", size);
	print("----");
--]]
	local ncomps = uprops[1]
	local basetype = uprops[2]
	local getfunc = uprops[3]
	local narrelem = uprops[5];
	local typedecl = uprops[6];
--	print(ncomps, basetype, typedecl);

	-- Create a buffer of the appropriate size
	-- to hold the results
	local buff = ffi.new(typedecl);

	-- Call the getter to get the value
	getfunc(self.ID, loc, buff);

	return buff, ncomps;
end


function SetUniformValue(self, name, value)
	local loc, utype, size = GetUniform(self, name);

	if loc == nil then return nil end;

	local uprops = uniformprops[utype];
--[[
	print("================")
	print("GPUProgram:GetUniformValue")
	print("Name: ", name);
	print("Loc: ", loc);
	print("Size: ", size);
	print("----");
--]]
	local ncomps = uprops[1]
	local basetype = uprops[2]
	local setfunc = uprops[4]
	local narrelem = uprops[5];
	local typedecl = uprops[6];
	--print(ncomps, basetype, typedecl);

	-- Create a buffer of the appropriate size
	-- to hold the results
	local buff = ffi.new(typedecl);

	-- copy value into buffer
	if ncomps == 1 then
		buff[0] = value
	else
		for i=0,ncomps-1 do
			buff[i] = value[i];
		end
	end

	-- Call the getter to get the value
	setfunc(loc, narrelem, buff);
end



function glsl_get(self, key)
	-- First, try the object itself as it might
	-- be a simple field access
	local field = rawget(self,key)
	if field ~= nil then
--		print("returning self field: ", field)
		return field
	end

	-- Next, try the class table, as it might be a
	-- function for the class
	field = rawget(GPUProgram,key)
	if field ~= nil then
--		print("returning glsl field: ", field)
		return field
	end

	-- Last, do whatever magic to return a value
	-- or nil

	local value, ncomps =  GetUniformValue(self, key)

	if ncomps == 1 then
		return value[0];
	end

	return value
end

function glsl_set(self, key, value)
	-- See if the field exists in the table
	local field = rawget(self,key)
	if field ~= nil then
		rawset(self, key, value)
	end

	-- Otherwise, try to set the value
	-- in the shader
	SetUniformValue(self, key, value)
end

GPUProgram_mt.__index = glsl_get

GPUProgram_mt.__newindex = glsl_set


function GLSLProgram(fragtext, verttext)
	local prog = GPUProgram.new(fragtext, vertext)

	return prog
end

function CreateGLSLProgramFromFiles(fragname, vertname)
	local fragtext = nil;
	local verttext = nil;
	local fp = nil;

	if fragname then
		fp = io.open(fragname, "r");
		fragtext = fp:read("*all");
		print(fragtext);
		fp:close();
	end

	if vertname then
		fp = io.open(vertname, "r");
		verttext = fp:read("*all");
		fp:close();
	end

	local prog = GLSLProgram(fragtext, verttext);

	return prog;
end
