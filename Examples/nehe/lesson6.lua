
require ("TargaLoader")
require ("GLTexture")

local CUBE_TEXTURE = 0;
local texobj = nil;


local xrot=0;
local yrot=0;
local zrot=0;
local ratio=0;




function init()
	glShadeModel(GL_SMOOTH);							-- Enable Smooth Shading
	glClearColor(0.0, 0.0, 0.0, 0.5);				-- Black Background
	glEnable ( GL_COLOR_MATERIAL );
	glColorMaterial ( GL_FRONT, GL_AMBIENT_AND_DIFFUSE );

	--glEnable ( gl.GL_TEXTURE_2D );
	glPixelStorei ( GL_UNPACK_ALIGNMENT, 1 );

	local img, imgwidth, imgheight = ReadTargaFromFile("SWIRL.tga")
	texobj = GLTexture.Create(imgwidth, imgheight, GL_RGBA, img, GL_BGR, GL_UNSIGNED_BYTE, 3)

	glEnable ( GL_CULL_FACE );

   --gl.glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
end

function reshape(w, h)

	-- Prevent a divide by zero, when window is too short
	-- (you cant make a window of zero width).
	if(h == 0) then
		h = 1;
	end

	ratio = w / h;

	-- Reset the coordinate system before modifying
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	-- Set the viewport to be the entire window
    glViewport(0, 0, w, h);

	-- Set the clipping volume
	gluPerspective(80,ratio,1,200);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	gluLookAt(0, 0, 30,
		      0,0,10,
			  0.0,1.0,0.0);
end

function display()

	glClear(bor(GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT));
	glLoadIdentity ( );
	glPushMatrix();
	glTranslatef ( 0.0, 0.0, -5.0 );
	glRotatef ( xrot, 1.0, 0.0, 0.0 );
	glRotatef ( yrot, 0.0, 1.0, 0.0 );
	glRotatef ( zrot, 0.0, 0.0, 1.0 );

	texobj:MakeCurrent();

	glBegin ( GL_QUADS );
	-- Front Face
		glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0,  1.0);
		glTexCoord2f(1.0, 0.0); glVertex3f( 1.0, -1.0,  1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f( 1.0,  1.0,  1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f(-1.0,  1.0,  1.0);
		-- Back Face
		glTexCoord2f(1.0, 0.0); glVertex3f(-1.0, -1.0, -1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f(-1.0,  1.0, -1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f( 1.0,  1.0, -1.0);
		glTexCoord2f(0.0, 0.0); glVertex3f( 1.0, -1.0, -1.0);
		-- Top Face
		glTexCoord2f(0.0, 1.0); glVertex3f(-1.0,  1.0, -1.0);
		glTexCoord2f(0.0, 0.0); glVertex3f(-1.0,  1.0,  1.0);
		glTexCoord2f(1.0, 0.0); glVertex3f( 1.0,  1.0,  1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f( 1.0,  1.0, -1.0);
		-- Bottom Face
		glTexCoord2f(1.0, 1.0); glVertex3f(-1.0, -1.0, -1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f( 1.0, -1.0, -1.0);
		glTexCoord2f(0.0, 0.0); glVertex3f( 1.0, -1.0,  1.0);
		glTexCoord2f(1.0, 0.0); glVertex3f(-1.0, -1.0,  1.0);
		-- Right face
		glTexCoord2f(1.0, 0.0); glVertex3f( 1.0, -1.0, -1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f( 1.0,  1.0, -1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f( 1.0,  1.0,  1.0);
		glTexCoord2f(0.0, 0.0); glVertex3f( 1.0, -1.0,  1.0);
		-- Left Face
		glTexCoord2f(0.0, 0.0); glVertex3f(-1.0, -1.0, -1.0);
		glTexCoord2f(1.0, 0.0); glVertex3f(-1.0, -1.0,  1.0);
		glTexCoord2f(1.0, 1.0); glVertex3f(-1.0,  1.0,  1.0);
		glTexCoord2f(0.0, 1.0); glVertex3f(-1.0,  1.0, -1.0);
	glEnd();
	glPopMatrix();

	xrot = xrot + 0.6;
	yrot = yrot + 0.4;
	zrot = zrot + 0.8;
end
