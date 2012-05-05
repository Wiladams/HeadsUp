require "LuaScriptThread"

local codechunk = [[
print(_ThreadParam);
print("Hello, Lua, Again!!");
]]

local thread;

for i=1,100 do
	thread = LuaScriptThread(codechunk, i);
end
