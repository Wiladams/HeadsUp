
local rtri=0;						-- Angle For The Triangle
local rquad=0;						-- Angle For The Quad


function init ()     -- Create Some Everyday Functions

	glShadeModel(GL_SMOOTH);							-- Enable Smooth Shading
	glClearColor(0.0, 0.0, 0.0, 0.5);				-- Black Background
	glClearDepth(1.0);									-- Depth Buffer Setup
	glEnable(GL_DEPTH_TEST);							-- Enables Depth Testing
	glDepthFunc(GL_LEQUAL);								-- The Type Of Depth Testing To Do
	glEnable (GL_COLOR_MATERIAL);
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
end

function display ()   -- Create The Display Function

	glClear(bor(GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT));	-- Clear Screen And Depth Buffer
	glLoadIdentity();									-- Reset The Current Modelview Matrix
	glPushMatrix();
	glTranslatef(-1.5,0.0,-6.0);						-- Move Left 1.5 Units And Into The Screen 6.0
	glRotatef(rtri,0.0,1.0,0.0);				-- Rotate The Triangle On The Y axis
	glBegin(GL_TRIANGLES);								-- Drawing Using Triangles
		glColor3f(1.0,0.0,0.0);			-- Red
		glVertex3f( 0.0, 1.0, 0.0);			-- Top Of Triangle (Front)
		glColor3f(0.0,1.0,0.0);			-- Green
		glVertex3f(-1.0,-1.0, 1.0);			-- Left Of Triangle (Front)
		glColor3f(0.0,0.0,1.0);			-- Blue
		glVertex3f( 1.0,-1.0, 1.0);			-- Right Of Triangle (Front)
		glColor3f(1.0,0.0,0.0);			-- Red
		glVertex3f( 0.0, 1.0, 0.0);			-- Top Of Triangle (Right)
		glColor3f(0.0,0.0,1.0);			-- Blue
		glVertex3f( 1.0,-1.0, 1.0);			-- Left Of Triangle (Right)
		glColor3f(0.0,1.0,0.0);			-- Green
		glVertex3f( 1.0,-1.0, -1.0);			-- Right Of Triangle (Right)
      glColor3f(1.0,0.0,0.0);			-- Red
		glVertex3f( 0.0, 1.0, 0.0);			-- Top Of Triangle (Back)
		glColor3f(0.0,1.0,0.0);			-- Green
		glVertex3f( 1.0,-1.0, -1.0);			-- Left Of Triangle (Back)
		glColor3f(0.0,0.0,1.0);			-- Blue
		glVertex3f(-1.0,-1.0, -1.0);			-- Right Of Triangle (Back)
		glColor3f(1.0,0.0,0.0);			-- Red
		glVertex3f( 0.0, 1.0, 0.0);			-- Top Of Triangle (Left)
		glColor3f(0.0,0.0,1.0);			-- Blue
		glVertex3f(-1.0,-1.0,-1.0);			-- Left Of Triangle (Left)
		glColor3f(0.0,1.0,0.0);			-- Green
		glVertex3f(-1.0,-1.0, 1.0);			-- Right Of Triangle (Left)
    glEnd();											-- Finished Drawing The Triangle

	glLoadIdentity();					-- Reset The Current Modelview Matrix
    glTranslatef(1.5,0.0,-6.0);				-- Move Right 1.5 Units And Into The Screen 6.0
	glRotatef(rquad,1.0,0.0,0.0);			-- Rotate The Quad On The X axis
	glColor3f(0.5,0.5,1.0);							-- Set The Color To Blue One Time Only
	glBegin(GL_QUADS);									-- Draw A Quad
		glColor3f(0.0,1.0,0.0);			-- Set The Color To Blue
		glVertex3f( 1.0, 1.0,-1.0);			-- Top Right Of The Quad (Top)
		glVertex3f(-1.0, 1.0,-1.0);			-- Top Left Of The Quad (Top)
		glVertex3f(-1.0, 1.0, 1.0);			-- Bottom Left Of The Quad (Top)
		glVertex3f( 1.0, 1.0, 1.0);			-- Bottom Right Of The Quad (Top)
		glColor3f(1.0,0.5,0.0);			-- Set The Color To Orange
		glVertex3f( 1.0,-1.0, 1.0);			-- Top Right Of The Quad (Bottom)
		glVertex3f(-1.0,-1.0, 1.0);			-- Top Left Of The Quad (Bottom)
		glVertex3f(-1.0,-1.0,-1.0);			-- Bottom Left Of The Quad (Bottom)
		glVertex3f( 1.0,-1.0,-1.0);			-- Bottom Right Of The Quad (Bottom)
		glColor3f(1.0,0.0,0.0);			-- Set The Color To Red
		glVertex3f( 1.0, 1.0, 1.0);			-- Top Right Of The Quad (Front)
		glVertex3f(-1.0, 1.0, 1.0);			-- Top Left Of The Quad (Front)
		glVertex3f(-1.0,-1.0, 1.0);			-- Bottom Left Of The Quad (Front)
		glVertex3f( 1.0,-1.0, 1.0);			-- Bottom Right Of The Quad (Front)
		glColor3f(1.0,1.0,0.0);			-- Set The Color To Yellow
		glVertex3f( 1.0,-1.0,-1.0);			-- Bottom Left Of The Quad (Back)
		glVertex3f(-1.0,-1.0,-1.0);			-- Bottom Right Of The Quad (Back)
		glVertex3f(-1.0, 1.0,-1.0);			-- Top Right Of The Quad (Back)
		glVertex3f( 1.0, 1.0,-1.0);			-- Top Left Of The Quad (Back)
		glColor3f(0.0,0.0,1.0);			-- Set The Color To Blue
		glVertex3f(-1.0, 1.0, 1.0);			-- Top Right Of The Quad (Left)
		glVertex3f(-1.0, 1.0,-1.0);			-- Top Left Of The Quad (Left)
		glVertex3f(-1.0,-1.0,-1.0);			-- Bottom Left Of The Quad (Left)
		glVertex3f(-1.0,-1.0, 1.0);			-- Bottom Right Of The Quad (Left)
		glColor3f(1.0,0.0,1.0);			-- Set The Color To Violet
		glVertex3f( 1.0, 1.0,-1.0);			-- Top Right Of The Quad (Right)
		glVertex3f( 1.0, 1.0, 1.0);			-- Top Left Of The Quad (Right)
		glVertex3f( 1.0,-1.0, 1.0);			-- Bottom Left Of The Quad (Right)
		glVertex3f( 1.0,-1.0,-1.0);			-- Bottom Right Of The Quad (Right)
	glEnd();						-- Done Drawing The Quad
  												-- Done Drawing The Quad
	glPopMatrix();
	rtri  = rtri+0.2;						-- Increase The Rotation Variable For The Triangle ( NEW )
	rquad = rquad-0.5;						-- Decrease The Rotation Variable For The Quad     ( NEW )
end

function reshape (width , height)   -- Create The Reshape Function (the viewport)
	if (height==0) then										-- Prevent A Divide By Zero By
		height=1;										-- Making Height Equal One
	end

	glViewport(0,0,width,height);						-- Reset The Current Viewport

	glMatrixMode(GL_PROJECTION);						-- Select The Projection Matrix
	glLoadIdentity();									-- Reset The Projection Matrix

	-- Calculate The Aspect Ratio Of The Window
	gluPerspective(45.0,width/height,0.1,100.0);

	glMatrixMode(GL_MODELVIEW);							-- Select The Modelview Matrix
	glLoadIdentity();
end



function keydown (key, x, y)  -- Create Special Function (required for arrow keys)
	if key == VK_UP then     -- When Up Arrow Is Pressed...
		-- glutFullScreen ( ); -- Go Into Full Screen Mode
	end
    if key == VK_DOWN then               -- When Down Arrow Is Pressed...
		-- glutReshapeWindow ( 500, 500 ); -- Go Into A 500 By 500 Window
	end
end


