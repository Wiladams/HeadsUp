require ("TargaLoader")
require ("GLTexture")

MAX_NO_TEXTURES = 3

CUBE_TEXTURE =1
FCUBE_TEXTURE =2
MCUBE_TEXTURE =3

local texture_id={}

local xrot=0;
local yrot=0;
local xspeed=0;			-- X Rotation Speed
local yspeed=0;			-- Y Rotation Speed
local ratio=0;
local z=-5.0;			-- Depth Into The Screen

local LightAmbient  =	float4( 0.5, 0.5, 0.5, 1.0 );
local LightDiffuse  =	float4( 1.0, 1.0, 1.0, 1.0 );
local LightPosition =	float4( 0.0, 0.0, 2.0, 1.0 );

local	filter = 1;			-- Which Filter To Use
local	light = false;		-- Lighting ON/OFF
local 	blend = false;		-- Blending OFF/ON? ( NEW )
local	lp = false;			-- L Pressed?
local	fp = false;			-- F Pressed?
local	bp = false;			-- B Pressed? ( NEW )

function LoadGLTextures()
	local img, imgwidth, imgheight = ReadTargaFromFile("glass.tga")
	texobj = GLTexture(imgwidth, imgheight, GL_RGBA, img, GL_BGR, 3)
	texobj:SetFilters(GL_NEAREST, GL_NEAREST);
	table.insert(texture_id, texobj);

	img, imgwidth, imgheight = ReadTargaFromFile("glass.tga")
	texobj = GLTexture(imgwidth, imgheight, GL_RGBA, img, GL_BGR, 3)
	texobj:SetFilters(GL_LINEAR, GL_LINEAR);
	table.insert(texture_id, texobj);

	img, imgwidth, imgheight = ReadTargaFromFile("glass.tga")
	texobj = GLTexture(imgwidth, imgheight, GL_RGBA, img, GL_BGR, 3)
	texobj:SetFilters(GL_LINEAR_MIPMAP_NEAREST, GL_LINEAR);
	table.insert(texture_id, texobj);
end


function init()
	LoadGLTextures();

	glEnable(GL_TEXTURE_2D);
	glShadeModel(GL_SMOOTH);							-- Enable Smooth Shading
	glClearColor(0.0, 0.0, 0.0, 0.5);				-- Black Background

	glClearDepth(1.0);									-- Depth Buffer Setup
	glEnable(GL_DEPTH_TEST);							-- Enables Depth Testing
	glDepthFunc(GL_LEQUAL);								-- The Type Of Depth Testing To Do
	--ShowCursor(false);
    glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);

	gl.glLightfv(GL_LIGHT1, GL_AMBIENT, LightAmbient);		-- Setup The Ambient Light
	gl.glLightfv(GL_LIGHT1, GL_DIFFUSE, LightDiffuse);		-- Setup The Diffuse Light
	gl.glLightfv(GL_LIGHT1, GL_POSITION,LightPosition);	-- Position The Light
	glEnable(GL_LIGHT1);								-- Enable Light One

	gl.glColor4f(1.0, 1.0, 1.0, 0.5);					-- Full Brightness.  50% Alpha
	glBlendFunc(GL_SRC_ALPHA,GL_ONE);					-- Set The Blending Function For Translucency
end

function reshape(w, h)

	-- Prevent a divide by zero, when window is too short
	-- (you cant make a window of zero width).
	if(h == 0) then
		h = 1;
	end

	ratio = 1.0 * w / h;

	-- Reset the coordinate system before modifying
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();

	-- Set the viewport to be the entire window
    glViewport(0, 0, w, h);

	-- Set the clipping volume
	gluPerspective(80,ratio,1,200);
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	gluLookAt(0,0,30,
		      0,0,10,
			  0,1,0);
end

function display()
	glClear(bor(GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT));
	glLoadIdentity ( );

	glPushMatrix();
	glTranslatef ( 0.0, 0.0, z );
	glRotatef ( xrot, 1.0, 0.0, 0.0 );
	glRotatef ( yrot, 0.0, 1.0, 0.0 );

	texture_id[filter]:MakeCurrent();

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

	xrot = xrot + xspeed;
	yrot = yrot + yspeed;

   --glutSwapBuffers();
end


function keychar (key, x, y)  -- Create Keyboard Function

    if key == 'f' then
		fp=true;
		filter = filter + 1;
		if (filter>3) then
			filter=1;
		end
	end

    if key == 'l' then
    	lp=true;
		light = not light;
		if (not light) then
			glDisable(GL_LIGHTING);
		else
			glEnable(GL_LIGHTING);
		end
	end


    if key == 'b' then
		bp = true;
		blend =  not blend;
		if(blend) then
			glEnable(GL_BLEND);			-- Turn Blending On
			glDisable(GL_DEPTH_TEST);	-- Turn Depth Testing Off

		else
			glDisable(GL_BLEND);		-- Turn Blending Off
			glEnable(GL_DEPTH_TEST);	-- Turn Depth Testing On
		end
	end
end


function keydown ( a_keys, x, y )  -- Create Special Function (required for arrow keys)
	if a_keys == VK_UP then
		xspeed = xspeed - 0.01;
	elseif a_keys == VK_DOWN then
		xspeed = xspeed + 0.01;
	elseif a_keys == VK_RIGHT then
		yspeed = yspeed + 0.01;
	elseif a_keys == VK_LEFT then
    	yspeed = yspeed - 0.01;
	end
end





