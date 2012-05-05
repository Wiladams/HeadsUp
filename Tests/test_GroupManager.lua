require "GroupManager"


local b1 = blob():new(1024);

local gm = GroupManager()

gm:Join(23, 44);
gm:Join(24, 45);
gm:Join(25, 46);

gm:EnumerateJoined();

gm:Depart(24, 45);

gm:EnumerateJoined();
