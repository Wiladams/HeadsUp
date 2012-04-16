


local	rtri=0;							-- Angle For The Triangle
local	rquad=0;						-- Angle For The Quad

function init ()     -- Create Some Everyday Functions
	glShadeModel(GL_SMOOTH);							-- Enable Smooth Shading
	glClearColor(0.0, 0.0, 0.0, 0.5);				-- Black Background
	glClearDepth(1.0);									-- Depth Buffer Setup
	glEnable(GL_DEPTH_TEST);							-- Enables Depth Testing
	glDepthFunc(GL_LEQUAL);								-- The Type Of Depth Testing To Do
	glEnable ( GL_COLOR_MATERIAL );
	glHint(GL_PERSPECTIVE_CORRECTION_HINT, GL_NICEST);
end

function display ()   -- Create The Display Function
	glClear(bor(GL_COLOR_BUFFER_BIT, GL_DEPTH_BUFFER_BIT));	-- Clear Screen And Depth Buffer
	glLoadIdentity();									-- Reset The Current Modelview Matrix
	glPushMatrix();
	glTranslatef(-1.5,0.0,-6.0);						-- Move Left 1.5 Units And Into The Screen 6.0
	glRotatef(rtri,0.0,1.0,0.0);				-- Rotate The Triangle On The Y axis
	glBegin(GL_TRIANGLES);								-- Drawing Using Triangles
		glColor3f(1.0,0.0,0.0);						-- Set The Color To Red
		glVertex3f( 0.0, 1.0, 0.0);					-- Top
		glColor3f(0.0,1.0,0.0);						-- Set The Color To Green
		glVertex3f(-1.0,-1.0, 0.0);					-- Bottom Left
		glColor3f(0.0,0.0,1.0);						-- Set The Color To Blue
		glVertex3f( 1.0,-1.0, 0.0);					-- Bottom Right
	glEnd();											-- Finished Drawing The Triangle

	glLoadIdentity();					-- Reset The Current Modelview Matrix
	glTranslatef(1.5,0.0,-6.0);				-- Move Right 1.5 Units And Into The Screen 6.0
	glRotatef(rquad,1.0,0.0,0.0);			-- Rotate The Quad On The X axis
	glColor3f(0.5,0.5,1.0);							-- Set The Color To Blue One Time Only
	glBegin(GL_QUADS);									-- Draw A Quad
		glVertex3f(-1.0, 1.0, 0.0);					-- Top Left
		glVertex3f( 1.0, 1.0, 0.0);					-- Top Right
		glVertex3f( 1.0,-1.0, 0.0);					-- Bottom Right
		glVertex3f(-1.0,-1.0, 0.0);					-- Bottom Left
	glEnd();											-- Done Drawing The Quad
	glPopMatrix();

	rtri  = rtri + 1;						-- Increase The Rotation Variable For The Triangle ( NEW )
	rquad = rquad - 0.45;						-- Decrease The Rotation Variable For The Quad     ( NEW )

--  glutSwapBuffers ( );
  -- Swap The Buffers To Not Be Left With A Clear Screen
end

function reshape (w, h)   -- Create The Reshape Function (the viewport)

	glViewport     ( 0, 0, w, h );
	glMatrixMode   ( GL_PROJECTION );  -- Select The Projection Matrix
	glLoadIdentity ( );                -- Reset The Projection Matrix

	-- Calculate The Aspect Ratio Of The Window
	if ( h==0 )  then
		gluPerspective ( 80, w, 1.0, 5000.0 );
	else
		gluPerspective ( 80, w / h, 1.0, 5000.0 );
	end

	glMatrixMode   ( GL_MODELVIEW );  -- Select The Model View Matrix
	glLoadIdentity ( );    -- Reset The Model View Matrix
end


-- Create Special Function (required for arrow keys)
function keydown (key, x, y )
print("keydown: ", key);
	-- When Up Arrow Is Pressed...
    if key ==  VK_UP then
		--glutFullScreen ( ); -- Go Into Full Screen Mode
	end

    if key == VK_DOWN then
		-- When Down Arrow Is Pressed...
		-- Go Into A 500 By 500 Window
		--glutReshapeWindow ( 500, 500 );
	end
end



