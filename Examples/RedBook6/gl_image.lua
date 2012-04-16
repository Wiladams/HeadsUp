-- page 335

class.CheckerboardPattern()

function CheckerboardPattern:_init(w, h)
w = w or 64
h = h or 64
	self.Width = w;
	self.Height = h;
	self.Data = Array2D(w, h, "pixel_RGB_b");

	function bitnum(value)
		if value then return 1 else return 0 end
	end

	local i = 0;
	local j = 0;
	local c = 0;

	for i=0, self.Height-1 do
		for j=0, self.Width-1 do
			c = bxor(bitnum((band(i,0x8)==0)), bitnum((band(j,0x8)==0)))  * 255;
			self.Data[i][j] = PixelRGB(c,c,c)
		end
	end

end



local height = 0;
local zoomFactor = 1;
local pattern = CheckerboardPattern(64,64)

function init()
	glClearColor(0,0,0,0);
	glShadeModel(GL_FLAT);
	glPixelStorei(GL_UNPACK_ALIGNMENT, 1);
end

function display()
	glClear(GL_COLOR_BUFFER_BIT);
	glRasterPos2i(0,0);
	gl.glDrawPixels(pattern.Width, pattern.Height, GL_RGB, GL_UNSIGNED_BYTE, pattern.Data);
	glFlush();
end

function reshape(w,h)
	glViewport(0,0,w,h);

	height = h;

	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	gluOrtho2D(0,w, 0,h);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
end

local screeny = 0;

function motion()
	screeny = height - y;
	gl.glRasterPos2i(x, screeny);
	gl.glPixelZoom(zoomFactor, zoomFactor);
	gl.glCopyPixels(0,0,checkImageWidth, checkImageHeight, GL_COLOR);
	gl.glPixelZoom(1, 1);
	glFlush();
end

function keychar(key, x, y)
	if key == 'r' or key == 'R' then
		zoomFactor = 1;
	end

	if key == 'z' then
		zoomFactor = zoomFactor + 0.5;
		if zoomFactor >= 3 then
			zoomFactor = 3
		end
	end

	if key == 'Z' then
		zoomFactor = zoomFactor - 0.5;
		if zoomFactor <= 0.5 then
			zoomFactor = 0.5;
		end
	end
end
