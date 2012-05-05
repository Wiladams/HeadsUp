local ffi = require "ffi"

require "DataDescription"
require "BanateCore"
require "BinaryStreamWriter"
require "BinaryStreamReader"

GROUP_JOIN = 1;
GROUP_DEPART = 2;

local groupTypeInfo = {}

groupTypeInfo[GROUP_JOIN] = {
	name = "join_command";
	fields = {
		{name="commandid", basetype="int32_t"},
		{name="agentid", basetype="int32_t"},
		{name="threadid", basetype="int16_t"},
	};
};

groupTypeInfo[GROUP_DEPART] = {
	name = "depart_command";
	fields = {
		{name="commandid", basetype="int32_t"},
		{name="agentid", basetype="int32_t"},
		{name="threadid", basetype="int16_t"},
	};
};

function createStructures()
	local typ = CStructFromTypeInfo(groupTypeInfo[GROUP_JOIN])
	print(typ);

	print();
	typ = CStructFromTypeInfo(groupTypeInfo[GROUP_DEPART])
	print(typ);
end

function createSerializers()
	local ser = CTypeSerializer(groupTypeInfo[GROUP_JOIN])
	print(ser);

	print();
	ser = CTypeDeSerializer(groupTypeInfo[GROUP_JOIN])
	print(ser);

	ser = CTypeSerializer(groupTypeInfo[GROUP_DEPART])
	print(ser);

	print();
	ser = CTypeDeSerializer(groupTypeInfo[GROUP_DEPART])
	print(ser);

end

--createStructures();
--createSerializers();

ffi.cdef[[
typedef struct join_command {
	int32_t commandid;
	int32_t agentid;
	int16_t threadid;
} join_command;


typedef struct depart_command {
	int32_t commandid;
	int32_t agentid;
	int16_t threadid;
} depart_command;

typedef struct {
	int size;
	uint8_t *bytes;
} blob;
]]

function print_command(cmd)
	print("Join Command");
	print("Command ID: ", cmd.commandid);
	print("Thread ID: ", cmd.threadid);
	print("Agent ID: ", cmd.agentid);
end

join_command = {}
join_command_mt = {

	__index = {
		new = function(self, threadid, agentid)
			self.commandid = GROUP_JOIN;
			self.threadid = threadid;
			self.agentid = agentid;
			return self;
		end,

		WriteToStream = function(self, stream)
			stream:WriteInt32(self.commandid);
			stream:WriteInt32(self.agentid);
			stream:WriteInt16(self.threadid);
		end,

		ReadFromStream = function(self, stream)
			self.commandid = stream:ReadInt32();
			self.agentid = stream:ReadInt32();
			self.threadid = stream:ReadInt16();
		end,
	}
}
join_command = ffi.metatype("join_command", join_command_mt);


depart_command = {}
depart_command_mt = {
	__index = {
		new = function(self, threadid, agentid)
			self.commandid = GROUP_DEPART;
			self.threadid = threadid;
			self.agentid = agentid;
			return self;
		end,

		WriteToStream = function(self, stream)
			stream:WriteInt32(self.commandid);
			stream:WriteInt32(self.agentid);
			stream:WriteInt16(self.threadid);
		end,

		ReadFromStream = function (self, stream)
			self.commandid = stream:ReadInt32();
			self.agentid = stream:ReadInt32();
			self.threadid = stream:ReadInt16();
		end
	}
}
depart_command = ffi.metatype("depart_command", depart_command_mt);




blob = {}
blob_mt = {
	__index = {
		new = function(self, size)
			self.size = size;
			self.bytes = Array1D(size, "uint8_t");
			return self;
		end,
	},
}
blob = ffi.metatype("blob", blob_mt);






class.GroupManager()

function GroupManager:_init()
	self.Blob = blob():new(1024);
	self.Joined = {};
end

function GroupManager:EnumerateJoined()
print("==== GroupManager:EnumerateJoined() ====");
	for _,threader in ipairs(self.Joined) do
		print_command(threader);
	end
end

function GroupManager:Join(threadid, agentid)
	local cmd = join_command():new(threadid, agentid);
	local stream = BinaryStreamWriter.CreateForBytes(self.Blob.bytes, self.Blob.size);

	stream:WriteInt32(cmd.commandid);
	cmd:WriteToStream(stream);

	self:Deliver(self.Blob);
end

function GroupManager:Depart(threadid, agentid)
	local cmd = depart_command():new(threadid, agentid);
	local stream = BinaryStreamWriter.CreateForBytes(self.Blob.bytes, self.Blob.size);

	stream:WriteInt32(cmd.commandid);
	cmd:WriteToStream(stream);

	self:Deliver(self.Blob);
end


-- deliver the payload to everyone
-- who has joined
function GroupManager:DeliverPayloadToThreads(payload)
	for _,threader in ipairs(self.Joined) do
		user32.PostThreadMessageA(threader.threadid, user32.WM_SYSCOMMAND, payload, 0);
	end
end

function GroupManager:Deliver(payload)
	local reader = BinaryStreamReader.CreateForBytes(payload.bytes, payload.size);

	local cmd = nil;

	-- read the first int32, which is the command identifier
	local commandid = reader:ReadInt32();
	--print("GroupManager:Deliver, commandid: ", commandid);

	if commandid == GROUP_JOIN then
		local cmd = join_command();
		cmd:ReadFromStream(reader)
		table.insert(self.Joined, cmd);
		--print_command(cmd);
	elseif commandid == GROUP_DEPART then
		local cmd = depart_command();
		cmd:ReadFromStream(reader)

		-- go through the list of joined members
		-- if the entry has the same threadid and agentid,
		-- then remove it
		for i,member in ipairs(self.Joined) do
			if member.threadid == cmd.threadid and member.agentid == cmd.agentid then
				table.remove(self.Joined, i);
			end
		end
	else
		DeliverPayloadToThreads(payload)
	end
end
