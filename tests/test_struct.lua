local ffi = require "ffi"

ffi.cdef[[
typedef struct {
	int x;
	int y;
} point;

typedef struct {
	int x;
	int y;
} pointf;
]]
point = ffi.typeof("point");
pointf = ffi.typeof("pointf");

print("type point: ", ffi.typeof(point), ffi.typeof(point()));


Point = {}
Point_mt = {
	__eq = function(self, rhs)
		return self:Equals(rhs);
	end;

	__index = {
		Equals = function(self, rhs)
			return self.x == rhs.x and self.y == rhs.y;
		end;

		PrintSelf = function(self)
			print(self.x, self.y);
		end;
	};
}
Point = ffi.metatype("point", Point_mt);

p1 = point();
p2 = Point(10,20);

print("type Point: ", ffi.typeof(p2));
print("p1 == p2: ", p1:Equals(p2))

p3 = ffi.cast("point *",ffi.new("char[?]", ffi.sizeof("point")));
p4 = ffi.cast("point *",ffi.new("char[?]", ffi.sizeof("point")));

p3.x = 15
p3.y = 30

p4.x = 15
p4.y = 30

print("p3: ", ffi.typeof(p3))

print("p3 == p2: ", p3 == p2)


print("p2 self: ");
p2:PrintSelf();

print("p3 self: ")
p3:PrintSelf();


print("p4 self: ")
p4:PrintSelf();

print("p3 == p4: ", p3 == p4)

p5 = Point(20,30)
p6 = Point(20,30)
p7 = Point(25,35);

print("type 5,6: ", ffi.typeof(p5), ffi.typeof(p6));
print("p3 == p4: ", p3 == p4);
print("p5 == p5: ", p5 == p5);
print("p5 == p6: ", p5 == p6);
print("p5 == p6: ", p5 == p7);

print("p3 == p4: ", p3 == p4);
print("p3:Equals(p4): ", p3:Equals(p4));
