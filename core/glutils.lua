
function glAlphaFunc (func, ref)
	gl.glAlphaFunc(func, ref);
end

function glBegin (mode)
	gl.glBegin(mode);
end

function glBlendFunc (sfactor, dfactor)
	gl.glBlendFunc(sfactor, dfactor);
end

function glClear(mask)
	gl.glClear(mask);
end

function glClearColor (red, green, blue, alpha)
	gl.glClearColor(red, green, blue, alpha);
end

function glClearDepth (depth)
	gl.glClearDepth(depth);
end

function glColor(...)
local arg={...};
	if #arg == 3 then
		gl.glColor3d(arg[1], arg[2], arg[3]);
	elseif #arg == 4 then
		gl.glColor4d(arg[1], arg[2], arg[3], arg[4]);
	elseif #arg == 2 then
		gl.glColor4d(arg[1], arg[1], arg[1], arg[2]);
	elseif #arg == 1 then
		if type(arg[1] == "number") then
			gl.glColor3d(arg[1], arg[1], arg[1]);
		elseif type(arg[1]) == "table" then
			if #arg[1] == 3 then
				gl.glColor3d(arg[1], arg[2], arg[3]);
			elseif #arg[1] == 4 then
				gl.glColor4d(arg[1], arg[2], arg[3], arg[4]);
			end
		end
	end
end

function glColor3f(r,g,b)
	gl.glColor3f(r,g,b);
end

function glColorMaterial (face, mode)
	gl.glColorMaterial(face, mode);
end

function glCullFace(mode)
	gl.glCullFace(mode);
end

function glDeleteLists (list, range)
	gl.glDeleteLists(list, range);
end

function glDepthFunc(func)
	gl.glDepthFunc (func);
end

function glDepthRange (zNear, zFar)
	gl.glDepthRange(zNear, zFar);
end

function glDisable (cap)
	gl.glDisable(cap);
end

function glDrawPixels(width, height, fmt, btype, pixels)
	gl.glDrawPixels(width, height, fmt, btype, pixels);
end

function glEnable(cap)
	gl.glEnable(cap);
end

function glEnd ()
	gl.glEnd();
end

function glEndList ()
	gl.glEndList();
end

function glFinish (void)
	gl.glFinish();
end

function glFlush (void)
	gl.glFlush();
end

function glFrustum(left, right, bottom, top, zNear, zFar)
	gl.glFrustum(left, right, bottom, top, zNear, zFar);
end

function glGenLists (range)
	return gl.glGenLists(range);
end

function glGetError()
	return gl.glGetError();
end

function glHint(target, mode)
	gl.glHint (target, mode);
end

function glLineWidth(width)
	gl.glLineWidth (width);
end

function glLoadIdentity()
	gl.glLoadIdentity();
end

function glMatrixMode(mode)
	gl.glMatrixMode(mode);
end

function glOrtho(left, right, bottom, top, zNear, zFar)
	gl.glOrtho (left, right, bottom, top, zNear, zFar);
end

function glPixelStorei(pname, param)
	gl.glPixelStorei (pname, param);
end

function glPointSize(size)
	gl.glPointSize(size);
end

function glPolygonMode(face, mode)
	gl.glPolygonMode (face, mode);
end

function glPopMatrix()
	gl.glPopMatrix();
end

function glPushMatrix()
	gl.glPushMatrix();
end

function glRasterPos(x, y)
	gl.glRasterPos2d(x, y);
end

glRasterPos2i = glRasterPos;


function glRotate(angle, x, y, z)
	gl.glRotated(angle, x, y, z);
end

glRotatef = glRotate;


function glScale(x, y, z)
	gl.glScaled (x, y, z);
end


function glShadeModel(mode)
	gl.glShadeModel(mode);
end

function glTexCoord(s, t, r, q)
	gl.glTexCoord2d(s, t);
end

glTexCoord2f = glTexCoord;


function glTranslate(x, y, z)
	gl.glTranslated(x, y, z);
end

glTranslatef = glTranslate;


function glVertex(...)
local arg={...};
	if #arg == 3 then
		gl.glVertex3d(arg[1], arg[2], arg[3]);
	elseif #arg == 4 then
		gl.glVertex4d(arg[1], arg[2], arg[3], arg[4]);
	elseif #arg == 1 then
		if type(arg[1]) == "table" then
			if #arg[1] == 3 then
				gl.glVertex3d(arg[1], arg[2], arg[3]);
			elseif #arg[1] == 4 then
				gl.glVertex4d(arg[1], arg[2], arg[3], arg[4]);
			end
		end
	end
end

function glVertex3f(x,y,z)
	gl.glVertex3f(x,y,z);
end

function glViewport(x, y, width, height)
	gl.glViewport (x, y, width, height);
end

--[==[
ffi.cdef[[
void glAccum (GLenum op, GLfloat value);
GLboolean glAreTexturesResident (GLsizei n, const GLuint *textures, GLboolean *residences);
void glArrayElement (GLint i);
void glBindTexture (GLenum target, GLuint texture);
void glBitmap (GLsizei width, GLsizei height, GLfloat xorig, GLfloat yorig, GLfloat xmove, GLfloat ymove, const GLubyte *bitmap);
void glBlendColor (GLclampf red, GLclampf green, GLclampf blue, GLclampf alpha);
void glBlendEquation (GLenum mode);
void glBlendEquationSeparate(GLenum modeRGB, GLenum modeAlpha);
void glCallList (GLuint list);
void glCallLists (GLsizei n, GLenum type, const GLvoid *lists);
void glClearAccum (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void glClearIndex (GLfloat c);
void glClearStencil (GLint s);
void glClipPlane (GLenum plane, const GLdouble *equation);
void glColor3b (GLbyte red, GLbyte green, GLbyte blue);
void glColor3bv (const GLbyte *v);
void glColor3dv (const GLdouble *v);
void glColor3f (GLfloat red, GLfloat green, GLfloat blue);
void glColor3fv (const GLfloat *v);
void glColor3i (GLint red, GLint green, GLint blue);
void glColor3iv (const GLint *v);
void glColor3s (GLshort red, GLshort green, GLshort blue);
void glColor3sv (const GLshort *v);
void glColor3ub (GLubyte red, GLubyte green, GLubyte blue);
void glColor3ubv (const GLubyte *v);
void glColor3ui (GLuint red, GLuint green, GLuint blue);
void glColor3uiv (const GLuint *v);
void glColor3us (GLushort red, GLushort green, GLushort blue);
void glColor3usv (const GLushort *v);
void glColor4b (GLbyte red, GLbyte green, GLbyte blue, GLbyte alpha);
void glColor4bv (const GLbyte *v);
void glColor4dv (const GLdouble *v);
void glColor4f (GLfloat red, GLfloat green, GLfloat blue, GLfloat alpha);
void glColor4fv (const GLfloat *v);
void glColor4i (GLint red, GLint green, GLint blue, GLint alpha);
void glColor4iv (const GLint *v);
void glColor4s (GLshort red, GLshort green, GLshort blue, GLshort alpha);
void glColor4sv (const GLshort *v);
void glColor4ub (GLubyte red, GLubyte green, GLubyte blue, GLubyte alpha);
void glColor4ubv (const GLubyte *v);
void glColor4ui (GLuint red, GLuint green, GLuint blue, GLuint alpha);
void glColor4uiv (const GLuint *v);
void glColor4us (GLushort red, GLushort green, GLushort blue, GLushort alpha);
void glColor4usv (const GLushort *v);
void glColorMask (GLboolean red, GLboolean green, GLboolean blue, GLboolean alpha);
void glColorPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void glColorSubTable (GLenum target, GLsizei start, GLsizei count, GLenum format, GLenum type, const GLvoid *data);
void glColorTable (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, const GLvoid *table);
void glColorTableParameterfv (GLenum target, GLenum pname, const GLfloat *params);
void glColorTableParameteriv (GLenum target, GLenum pname, const GLint *params);
void glConvolutionFilter1D (GLenum target, GLenum internalformat, GLsizei width, GLenum format, GLenum type, const GLvoid *image);
void glConvolutionFilter2D (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *image);
void glConvolutionParameterf (GLenum target, GLenum pname, GLfloat params);
void glConvolutionParameterfv (GLenum target, GLenum pname, const GLfloat *params);
void glConvolutionParameteri (GLenum target, GLenum pname, GLint params);
void glConvolutionParameteriv (GLenum target, GLenum pname, const GLint *params);
void glCopyColorSubTable (GLenum target, GLsizei start, GLint x, GLint y, GLsizei width);
void glCopyColorTable (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width);
void glCopyConvolutionFilter1D (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width);
void glCopyConvolutionFilter2D (GLenum target, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height);
void glCopyPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum type);
void glCopyTexImage1D (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLint border);
void glCopyTexImage2D (GLenum target, GLint level, GLenum internalformat, GLint x, GLint y, GLsizei width, GLsizei height, GLint border);
void glCopyTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLint x, GLint y, GLsizei width);
void glCopyTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint x, GLint y, GLsizei width, GLsizei height);
void glCopyTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLint x, GLint y, GLsizei width, GLsizei height);
void glDeleteTextures (GLsizei n, const GLuint *textures);
void glDepthMask (GLboolean flag);
void glDisableClientState (GLenum array);
void glDrawArrays (GLenum mode, GLint first, GLsizei count);
void glDrawBuffer (GLenum mode);
void glDrawElements (GLenum mode, GLsizei count, GLenum type, const GLvoid *indices);
void glDrawPixels (GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
void glDrawRangeElements (GLenum mode, GLuint start, GLuint end, GLsizei count, GLenum type, const GLvoid *indices);
void glEdgeFlag (GLboolean flag);
void glEdgeFlagPointer (GLsizei stride, const GLvoid *pointer);
void glEdgeFlagv (const GLboolean *flag);
void glEnableClientState (GLenum array);
void glEvalCoord1d (GLdouble u);
void glEvalCoord1dv (const GLdouble *u);
void glEvalCoord1f (GLfloat u);
void glEvalCoord1fv (const GLfloat *u);
void glEvalCoord2d (GLdouble u, GLdouble v);
void glEvalCoord2dv (const GLdouble *u);
void glEvalCoord2f (GLfloat u, GLfloat v);
void glEvalCoord2fv (const GLfloat *u);
void glEvalMesh1 (GLenum mode, GLint i1, GLint i2);
void glEvalMesh2 (GLenum mode, GLint i1, GLint i2, GLint j1, GLint j2);
void glEvalPoint1 (GLint i);
void glEvalPoint2 (GLint i, GLint j);
void glFeedbackBuffer (GLsizei size, GLenum type, GLfloat *buffer);
void glFogf (GLenum pname, GLfloat param);
void glFogfv (GLenum pname, const GLfloat *params);
void glFogi (GLenum pname, GLint param);
void glFogiv (GLenum pname, const GLint *params);
void glFrontFace (GLenum mode);
void glGenTextures (GLsizei n, GLuint *textures);
void glGetBooleanv (GLenum pname, GLboolean *params);
void glGetClipPlane (GLenum plane, GLdouble *equation);
void glGetColorTable (GLenum target, GLenum format, GLenum type, GLvoid *table);
void glGetColorTableParameterfv (GLenum target, GLenum pname, GLfloat *params);
void glGetColorTableParameteriv (GLenum target, GLenum pname, GLint *params);
void glGetConvolutionFilter (GLenum target, GLenum format, GLenum type, GLvoid *image);
void glGetConvolutionParameterfv (GLenum target, GLenum pname, GLfloat *params);
void glGetConvolutionParameteriv (GLenum target, GLenum pname, GLint *params);
void glGetDoublev (GLenum pname, GLdouble *params);
void glGetFloatv (GLenum pname, GLfloat *params);
void glGetHistogram (GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values);
void glGetHistogramParameterfv (GLenum target, GLenum pname, GLfloat *params);
void glGetHistogramParameteriv (GLenum target, GLenum pname, GLint *params);
void glGetIntegerv (GLenum pname, GLint *params);
void glGetLightfv (GLenum light, GLenum pname, GLfloat *params);
void glGetLightiv (GLenum light, GLenum pname, GLint *params);
void glGetMapdv (GLenum target, GLenum query, GLdouble *v);
void glGetMapfv (GLenum target, GLenum query, GLfloat *v);
void glGetMapiv (GLenum target, GLenum query, GLint *v);
void glGetMaterialfv (GLenum face, GLenum pname, GLfloat *params);
void glGetMaterialiv (GLenum face, GLenum pname, GLint *params);
void glGetMinmax (GLenum target, GLboolean reset, GLenum format, GLenum type, GLvoid *values);
void glGetMinmaxParameterfv (GLenum target, GLenum pname, GLfloat *params);
void glGetMinmaxParameteriv (GLenum target, GLenum pname, GLint *params);
void glGetPixelMapfv (GLenum map, GLfloat *values);
void glGetPixelMapuiv (GLenum map, GLuint *values);
void glGetPixelMapusv (GLenum map, GLushort *values);
void glGetPointerv (GLenum pname, GLvoid* *params);
void glGetPolygonStipple (GLubyte *mask);
void glGetSeparableFilter (GLenum target, GLenum format, GLenum type, GLvoid *row, GLvoid *column, GLvoid *span);
const GLubyte * glGetString (GLenum name);
void glGetTexEnvfv (GLenum target, GLenum pname, GLfloat *params);
void glGetTexEnviv (GLenum target, GLenum pname, GLint *params);
void glGetTexGendv (GLenum coord, GLenum pname, GLdouble *params);
void glGetTexGenfv (GLenum coord, GLenum pname, GLfloat *params);
void glGetTexGeniv (GLenum coord, GLenum pname, GLint *params);
void glGetTexImage (GLenum target, GLint level, GLenum format, GLenum type, GLvoid *pixels);
void glGetTexLevelParameterfv (GLenum target, GLint level, GLenum pname, GLfloat *params);
void glGetTexLevelParameteriv (GLenum target, GLint level, GLenum pname, GLint *params);
void glGetTexParameterfv (GLenum target, GLenum pname, GLfloat *params);
void glGetTexParameteriv (GLenum target, GLenum pname, GLint *params);
void glHistogram (GLenum target, GLsizei width, GLenum internalformat, GLboolean sink);
void glIndexMask (GLuint mask);
void glIndexPointer (GLenum type, GLsizei stride, const GLvoid *pointer);
void glIndexd (GLdouble c);
void glIndexdv (const GLdouble *c);
void glIndexf (GLfloat c);
void glIndexfv (const GLfloat *c);
void glIndexi (GLint c);
void glIndexiv (const GLint *c);
void glIndexs (GLshort c);
void glIndexsv (const GLshort *c);
void glIndexub (GLubyte c);
void glIndexubv (const GLubyte *c);
void glInitNames (void);
void glInterleavedArrays (GLenum format, GLsizei stride, const GLvoid *pointer);
GLboolean glIsEnabled (GLenum cap);
GLboolean glIsList (GLuint list);
GLboolean glIsTexture (GLuint texture);
void glLightModelf (GLenum pname, GLfloat param);
void glLightModelfv (GLenum pname, const GLfloat *params);
void glLightModeli (GLenum pname, GLint param);
void glLightModeliv (GLenum pname, const GLint *params);
void glLightf (GLenum light, GLenum pname, GLfloat param);
void glLightfv (GLenum light, GLenum pname, const GLfloat *params);
void glLighti (GLenum light, GLenum pname, GLint param);
void glLightiv (GLenum light, GLenum pname, const GLint *params);
void glLineStipple (GLint factor, GLushort pattern);
void glListBase (GLuint base);
void glLoadMatrixd (const GLdouble *m);
void glLoadMatrixf (const GLfloat *m);
void glLoadName (GLuint name);
void glLogicOp (GLenum opcode);
void glMap1d (GLenum target, GLdouble u1, GLdouble u2, GLint stride, GLint order, const GLdouble *points);
void glMap1f (GLenum target, GLfloat u1, GLfloat u2, GLint stride, GLint order, const GLfloat *points);
void glMap2d (GLenum target, GLdouble u1, GLdouble u2, GLint ustride, GLint uorder, GLdouble v1, GLdouble v2, GLint vstride, GLint vorder, const GLdouble *points);
void glMap2f (GLenum target, GLfloat u1, GLfloat u2, GLint ustride, GLint uorder, GLfloat v1, GLfloat v2, GLint vstride, GLint vorder, const GLfloat *points);
void glMapGrid1d (GLint un, GLdouble u1, GLdouble u2);
void glMapGrid1f (GLint un, GLfloat u1, GLfloat u2);
void glMapGrid2d (GLint un, GLdouble u1, GLdouble u2, GLint vn, GLdouble v1, GLdouble v2);
void glMapGrid2f (GLint un, GLfloat u1, GLfloat u2, GLint vn, GLfloat v1, GLfloat v2);
void glMaterialf (GLenum face, GLenum pname, GLfloat param);
void glMaterialfv (GLenum face, GLenum pname, const GLfloat *params);
void glMateriali (GLenum face, GLenum pname, GLint param);
void glMaterialiv (GLenum face, GLenum pname, const GLint *params);
void glMinmax (GLenum target, GLenum internalformat, GLboolean sink);
void glMultMatrixd (const GLdouble *m);
void glMultMatrixf (const GLfloat *m);
void glNewList (GLuint list, GLenum mode);
void glNormal3b (GLbyte nx, GLbyte ny, GLbyte nz);
void glNormal3bv (const GLbyte *v);
void glNormal3d (GLdouble nx, GLdouble ny, GLdouble nz);
void glNormal3dv (const GLdouble *v);
void glNormal3f (GLfloat nx, GLfloat ny, GLfloat nz);
void glNormal3fv (const GLfloat *v);
void glNormal3i (GLint nx, GLint ny, GLint nz);
void glNormal3iv (const GLint *v);
void glNormal3s (GLshort nx, GLshort ny, GLshort nz);
void glNormal3sv (const GLshort *v);
void glNormalPointer (GLenum type, GLsizei stride, const GLvoid *pointer);
void glPassThrough (GLfloat token);
void glPixelMapfv (GLenum map, GLint mapsize, const GLfloat *values);
void glPixelMapuiv (GLenum map, GLint mapsize, const GLuint *values);
void glPixelMapusv (GLenum map, GLint mapsize, const GLushort *values);
void glPixelStoref (GLenum pname, GLfloat param);
void glPixelStorei (GLenum pname, GLint param);
void glPixelTransferf (GLenum pname, GLfloat param);
void glPixelTransferi (GLenum pname, GLint param);
void glPixelZoom (GLfloat xfactor, GLfloat yfactor);
void glPolygonOffset (GLfloat factor, GLfloat units);
void glPolygonStipple (const GLubyte *mask);
void glPopAttrib (void);
void glPopClientAttrib (void);
void glPopName (void);
void glPrioritizeTextures (GLsizei n, const GLuint *textures, const GLclampf *priorities);
void glPushAttrib (GLbitfield mask);
void glPushClientAttrib (GLbitfield mask);
void glPushName (GLuint name);
void glRasterPos2d (GLdouble x, GLdouble y);
void glRasterPos2dv (const GLdouble *v);
void glRasterPos2f (GLfloat x, GLfloat y);
void glRasterPos2fv (const GLfloat *v);
void glRasterPos2i (GLint x, GLint y);
void glRasterPos2iv (const GLint *v);
void glRasterPos2s (GLshort x, GLshort y);
void glRasterPos2sv (const GLshort *v);
void glRasterPos3d (GLdouble x, GLdouble y, GLdouble z);
void glRasterPos3dv (const GLdouble *v);
void glRasterPos3f (GLfloat x, GLfloat y, GLfloat z);
void glRasterPos3fv (const GLfloat *v);
void glRasterPos3i (GLint x, GLint y, GLint z);
void glRasterPos3iv (const GLint *v);
void glRasterPos3s (GLshort x, GLshort y, GLshort z);
void glRasterPos3sv (const GLshort *v);
void glRasterPos4d (GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void glRasterPos4dv (const GLdouble *v);
void glRasterPos4f (GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void glRasterPos4fv (const GLfloat *v);
void glRasterPos4i (GLint x, GLint y, GLint z, GLint w);
void glRasterPos4iv (const GLint *v);
void glRasterPos4s (GLshort x, GLshort y, GLshort z, GLshort w);
void glRasterPos4sv (const GLshort *v);
void glReadBuffer (GLenum mode);
void glReadPixels (GLint x, GLint y, GLsizei width, GLsizei height, GLenum format, GLenum type, GLvoid *pixels);
void glRectd (GLdouble x1, GLdouble y1, GLdouble x2, GLdouble y2);
void glRectdv (const GLdouble *v1, const GLdouble *v2);
void glRectf (GLfloat x1, GLfloat y1, GLfloat x2, GLfloat y2);
void glRectfv (const GLfloat *v1, const GLfloat *v2);
void glRecti (GLint x1, GLint y1, GLint x2, GLint y2);
void glRectiv (const GLint *v1, const GLint *v2);
void glRects (GLshort x1, GLshort y1, GLshort x2, GLshort y2);
void glRectsv (const GLshort *v1, const GLshort *v2);
GLint glRenderMode (GLenum mode);
void glResetHistogram (GLenum target);
void glResetMinmax (GLenum target);
void glRotatef (GLfloat angle, GLfloat x, GLfloat y, GLfloat z);
void glScalef (GLfloat x, GLfloat y, GLfloat z);
void glScissor (GLint x, GLint y, GLsizei width, GLsizei height);
void glSelectBuffer (GLsizei size, GLuint *buffer);
void glSeparableFilter2D (GLenum target, GLenum internalformat, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *row, const GLvoid *column);
void glStencilFunc (GLenum func, GLint ref, GLuint mask);
void glStencilMask (GLuint mask);
void glStencilOp (GLenum fail, GLenum zfail, GLenum zpass);
void glTexCoord1d (GLdouble s);
void glTexCoord1dv (const GLdouble *v);
void glTexCoord1f (GLfloat s);
void glTexCoord1fv (const GLfloat *v);
void glTexCoord1i (GLint s);
void glTexCoord1iv (const GLint *v);
void glTexCoord1s (GLshort s);
void glTexCoord1sv (const GLshort *v);
void glTexCoord2d (GLdouble s, GLdouble t);
void glTexCoord2dv (const GLdouble *v);
void glTexCoord2f (GLfloat s, GLfloat t);
void glTexCoord2fv (const GLfloat *v);
void glTexCoord2i (GLint s, GLint t);
void glTexCoord2iv (const GLint *v);
void glTexCoord2s (GLshort s, GLshort t);
void glTexCoord2sv (const GLshort *v);
void glTexCoord3d (GLdouble s, GLdouble t, GLdouble r);
void glTexCoord3dv (const GLdouble *v);
void glTexCoord3f (GLfloat s, GLfloat t, GLfloat r);
void glTexCoord3fv (const GLfloat *v);
void glTexCoord3i (GLint s, GLint t, GLint r);
void glTexCoord3iv (const GLint *v);
void glTexCoord3s (GLshort s, GLshort t, GLshort r);
void glTexCoord3sv (const GLshort *v);
void glTexCoord4d (GLdouble s, GLdouble t, GLdouble r, GLdouble q);
void glTexCoord4dv (const GLdouble *v);
void glTexCoord4f (GLfloat s, GLfloat t, GLfloat r, GLfloat q);
void glTexCoord4fv (const GLfloat *v);
void glTexCoord4i (GLint s, GLint t, GLint r, GLint q);
void glTexCoord4iv (const GLint *v);
void glTexCoord4s (GLshort s, GLshort t, GLshort r, GLshort q);
void glTexCoord4sv (const GLshort *v);
void glTexCoordPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void glTexEnvf (GLenum target, GLenum pname, GLfloat param);
void glTexEnvfv (GLenum target, GLenum pname, const GLfloat *params);
void glTexEnvi (GLenum target, GLenum pname, GLint param);
void glTexEnviv (GLenum target, GLenum pname, const GLint *params);
void glTexGend (GLenum coord, GLenum pname, GLdouble param);
void glTexGendv (GLenum coord, GLenum pname, const GLdouble *params);
void glTexGenf (GLenum coord, GLenum pname, GLfloat param);
void glTexGenfv (GLenum coord, GLenum pname, const GLfloat *params);
void glTexGeni (GLenum coord, GLenum pname, GLint param);
void glTexGeniv (GLenum coord, GLenum pname, const GLint *params);
void glTexImage1D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glTexImage2D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glTexImage3D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLenum format, GLenum type, const GLvoid *pixels);
void glTexParameterf (GLenum target, GLenum pname, GLfloat param);
void glTexParameterfv (GLenum target, GLenum pname, const GLfloat *params);
void glTexParameteri (GLenum target, GLenum pname, GLint param);
void glTexParameteriv (GLenum target, GLenum pname, const GLint *params);
void glTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLenum type, const GLvoid *pixels);
void glTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLenum type, const GLvoid *pixels);
void glTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLenum type, const GLvoid *pixels);
void glTranslatef (GLfloat x, GLfloat y, GLfloat z);
void glVertex2d (GLdouble x, GLdouble y);
void glVertex2dv (const GLdouble *v);
void glVertex2f (GLfloat x, GLfloat y);
void glVertex2fv (const GLfloat *v);
void glVertex2i (GLint x, GLint y);
void glVertex2iv (const GLint *v);
void glVertex2s (GLshort x, GLshort y);
void glVertex2sv (const GLshort *v);
void glVertex3d (GLdouble x, GLdouble y, GLdouble z);
void glVertex3dv (const GLdouble *v);
void glVertex3f (GLfloat x, GLfloat y, GLfloat z);
void glVertex3fv (const GLfloat *v);
void glVertex3i (GLint x, GLint y, GLint z);
void glVertex3iv (const GLint *v);
void glVertex3s (GLshort x, GLshort y, GLshort z);
void glVertex3sv (const GLshort *v);
void glVertex4d (GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void glVertex4dv (const GLdouble *v);
void glVertex4f (GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void glVertex4fv (const GLfloat *v);
void glVertex4i (GLint x, GLint y, GLint z, GLint w);
void glVertex4iv (const GLint *v);
void glVertex4s (GLshort x, GLshort y, GLshort z, GLshort w);
void glVertex4sv (const GLshort *v);
void glVertexPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void glSampleCoverage (GLclampf value, GLboolean invert);
void glSamplePass (GLenum pass);
void glLoadTransposeMatrixf (const GLfloat *m);
void glLoadTransposeMatrixd (const GLdouble *m);
void glMultTransposeMatrixf (const GLfloat *m);
void glMultTransposeMatrixd (const GLdouble *m);
void glCompressedTexImage3D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLsizei depth, GLint border, GLsizei imageSize, const GLvoid *data);
void glCompressedTexImage2D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLsizei height, GLint border, GLsizei imageSize, const GLvoid *data);
void glCompressedTexImage1D (GLenum target, GLint level, GLenum internalformat, GLsizei width, GLint border, GLsizei imageSize, const GLvoid *data);
void glCompressedTexSubImage3D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLint zoffset, GLsizei width, GLsizei height, GLsizei depth, GLenum format, GLsizei imageSize, const GLvoid *data);
void glCompressedTexSubImage2D (GLenum target, GLint level, GLint xoffset, GLint yoffset, GLsizei width, GLsizei height, GLenum format, GLsizei imageSize, const GLvoid *data);
void glCompressedTexSubImage1D (GLenum target, GLint level, GLint xoffset, GLsizei width, GLenum format, GLsizei imageSize, const GLvoid *data);
void glGetCompressedTexImage (GLenum target, GLint lod, GLvoid *img);
void glActiveTexture (GLenum texture);
void glClientActiveTexture (GLenum texture);
void glMultiTexCoord1d (GLenum target, GLdouble s);
void glMultiTexCoord1dv (GLenum target, const GLdouble *v);
void glMultiTexCoord1f (GLenum target, GLfloat s);
void glMultiTexCoord1fv (GLenum target, const GLfloat *v);
void glMultiTexCoord1i (GLenum target, GLint s);
void glMultiTexCoord1iv (GLenum target, const GLint *v);
void glMultiTexCoord1s (GLenum target, GLshort s);
void glMultiTexCoord1sv (GLenum target, const GLshort *v);
void glMultiTexCoord2d (GLenum target, GLdouble s, GLdouble t);
void glMultiTexCoord2dv (GLenum target, const GLdouble *v);
void glMultiTexCoord2f (GLenum target, GLfloat s, GLfloat t);
void glMultiTexCoord2fv (GLenum target, const GLfloat *v);
void glMultiTexCoord2i (GLenum target, GLint s, GLint t);
void glMultiTexCoord2iv (GLenum target, const GLint *v);
void glMultiTexCoord2s (GLenum target, GLshort s, GLshort t);
void glMultiTexCoord2sv (GLenum target, const GLshort *v);
void glMultiTexCoord3d (GLenum target, GLdouble s, GLdouble t, GLdouble r);
void glMultiTexCoord3dv (GLenum target, const GLdouble *v);
void glMultiTexCoord3f (GLenum target, GLfloat s, GLfloat t, GLfloat r);
void glMultiTexCoord3fv (GLenum target, const GLfloat *v);
void glMultiTexCoord3i (GLenum target, GLint s, GLint t, GLint r);
void glMultiTexCoord3iv (GLenum target, const GLint *v);
void glMultiTexCoord3s (GLenum target, GLshort s, GLshort t, GLshort r);
void glMultiTexCoord3sv (GLenum target, const GLshort *v);
void glMultiTexCoord4d (GLenum target, GLdouble s, GLdouble t, GLdouble r, GLdouble q);
void glMultiTexCoord4dv (GLenum target, const GLdouble *v);
void glMultiTexCoord4f (GLenum target, GLfloat s, GLfloat t, GLfloat r, GLfloat q);
void glMultiTexCoord4fv (GLenum target, const GLfloat *v);
void glMultiTexCoord4i (GLenum target, GLint, GLint s, GLint t, GLint r);
void glMultiTexCoord4iv (GLenum target, const GLint *v);
void glMultiTexCoord4s (GLenum target, GLshort s, GLshort t, GLshort r, GLshort q);
void glMultiTexCoord4sv (GLenum target, const GLshort *v);
void glFogCoordf (GLfloat coord);
void glFogCoordfv (const GLfloat *coord);
void glFogCoordd (GLdouble coord);
void glFogCoorddv (const GLdouble * coord);
void glFogCoordPointer (GLenum type, GLsizei stride, const GLvoid *pointer);
void glSecondaryColor3b (GLbyte red, GLbyte green, GLbyte blue);
void glSecondaryColor3bv (const GLbyte *v);
void glSecondaryColor3d (GLdouble red, GLdouble green, GLdouble blue);
void glSecondaryColor3dv (const GLdouble *v);
void glSecondaryColor3f (GLfloat red, GLfloat green, GLfloat blue);
void glSecondaryColor3fv (const GLfloat *v);
void glSecondaryColor3i (GLint red, GLint green, GLint blue);
void glSecondaryColor3iv (const GLint *v);
void glSecondaryColor3s (GLshort red, GLshort green, GLshort blue);
void glSecondaryColor3sv (const GLshort *v);
void glSecondaryColor3ub (GLubyte red, GLubyte green, GLubyte blue);
void glSecondaryColor3ubv (const GLubyte *v);
void glSecondaryColor3ui (GLuint red, GLuint green, GLuint blue);
void glSecondaryColor3uiv (const GLuint *v);
void glSecondaryColor3us (GLushort red, GLushort green, GLushort blue);
void glSecondaryColor3usv (const GLushort *v);
void glSecondaryColorPointer (GLint size, GLenum type, GLsizei stride, const GLvoid *pointer);
void glPointParameterf (GLenum pname, GLfloat param);
void glPointParameterfv (GLenum pname, const GLfloat *params);
void glPointParameteri (GLenum pname, GLint param);
void glPointParameteriv (GLenum pname, const GLint *params);
void glBlendFuncSeparate (GLenum srcRGB, GLenum dstRGB, GLenum srcAlpha, GLenum dstAlpha);
void glMultiDrawArrays (GLenum mode, const GLint *first, const GLsizei *count, GLsizei primcount);
void glMultiDrawElements (GLenum mode, const GLsizei *count, GLenum type, const GLvoid* *indices, GLsizei primcount);
void glWindowPos2d (GLdouble x, GLdouble y);
void glWindowPos2dv (const GLdouble *v);
void glWindowPos2f (GLfloat x, GLfloat y);
void glWindowPos2fv (const GLfloat *v);
void glWindowPos2i (GLint x, GLint y);
void glWindowPos2iv (const GLint *v);
void glWindowPos2s (GLshort x, GLshort y);
void glWindowPos2sv (const GLshort *v);
void glWindowPos3d (GLdouble x, GLdouble y, GLdouble z);
void glWindowPos3dv (const GLdouble *v);
void glWindowPos3f (GLfloat x, GLfloat y, GLfloat z);
void glWindowPos3fv (const GLfloat *v);
void glWindowPos3i (GLint x, GLint y, GLint z);
void glWindowPos3iv (const GLint *v);
void glWindowPos3s (GLshort x, GLshort y, GLshort z);
void glWindowPos3sv (const GLshort *v);
void glGenQueries(GLsizei n, GLuint *ids);
void glDeleteQueries(GLsizei n, const GLuint *ids);
GLboolean glIsQuery(GLuint id);
void glBeginQuery(GLenum target, GLuint id);
void glEndQuery(GLenum target);
void glGetQueryiv(GLenum target, GLenum pname, GLint *params);
void glGetQueryObjectiv(GLuint id, GLenum pname, GLint *params);
void glGetQueryObjectuiv(GLuint id, GLenum pname, GLuint *params);
void glBindBuffer (GLenum target, GLuint buffer);
void glDeleteBuffers (GLsizei n, const GLuint *buffers);
void glGenBuffers (GLsizei n, GLuint *buffers);
GLboolean glIsBuffer (GLuint buffer);
void glBufferData (GLenum target, GLsizeiptr size, const GLvoid *data, GLenum usage);
void glBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, const GLvoid *data);
void glGetBufferSubData (GLenum target, GLintptr offset, GLsizeiptr size, GLvoid *data);
GLvoid * glMapBuffer (GLenum target, GLenum access);
GLboolean glUnmapBuffer (GLenum target);
void glGetBufferParameteriv (GLenum target, GLenum pname, GLint *params);
void glGetBufferPointerv (GLenum target, GLenum pname, GLvoid **params);
void glDrawBuffers (GLsizei n, const GLenum *bufs);
void glVertexAttrib1d (GLuint index, GLdouble x);
void glVertexAttrib1dv (GLuint index, const GLdouble *v);
void glVertexAttrib1f (GLuint index, GLfloat x);
void glVertexAttrib1fv (GLuint index, const GLfloat *v);
void glVertexAttrib1s (GLuint index, GLshort x);
void glVertexAttrib1sv (GLuint index, const GLshort *v);
void glVertexAttrib2d (GLuint index, GLdouble x, GLdouble y);
void glVertexAttrib2dv (GLuint index, const GLdouble *v);
void glVertexAttrib2f (GLuint index, GLfloat x, GLfloat y);
void glVertexAttrib2fv (GLuint index, const GLfloat *v);
void glVertexAttrib2s (GLuint index, GLshort x, GLshort y);
void glVertexAttrib2sv (GLuint index, const GLshort *v);
void glVertexAttrib3d (GLuint index, GLdouble x, GLdouble y, GLdouble z);
void glVertexAttrib3dv (GLuint index, const GLdouble *v);
void glVertexAttrib3f (GLuint index, GLfloat x, GLfloat y, GLfloat z);
void glVertexAttrib3fv (GLuint index, const GLfloat *v);
void glVertexAttrib3s (GLuint index, GLshort x, GLshort y, GLshort z);
void glVertexAttrib3sv (GLuint index, const GLshort *v);
void glVertexAttrib4Nbv (GLuint index, const GLbyte *v);
void glVertexAttrib4Niv (GLuint index, const GLint *v);
void glVertexAttrib4Nsv (GLuint index, const GLshort *v);
void glVertexAttrib4Nub (GLuint index, GLubyte x, GLubyte y, GLubyte z, GLubyte w);
void glVertexAttrib4Nubv (GLuint index, const GLubyte *v);
void glVertexAttrib4Nuiv (GLuint index, const GLuint *v);
void glVertexAttrib4Nusv (GLuint index, const GLushort *v);
void glVertexAttrib4bv (GLuint index, const GLbyte *v);
void glVertexAttrib4d (GLuint index, GLdouble x, GLdouble y, GLdouble z, GLdouble w);
void glVertexAttrib4dv (GLuint index, const GLdouble *v);
void glVertexAttrib4f (GLuint index, GLfloat x, GLfloat y, GLfloat z, GLfloat w);
void glVertexAttrib4fv (GLuint index, const GLfloat *v);
void glVertexAttrib4iv (GLuint index, const GLint *v);
void glVertexAttrib4s (GLuint index, GLshort x, GLshort y, GLshort z, GLshort w);
void glVertexAttrib4sv (GLuint index, const GLshort *v);
void glVertexAttrib4ubv (GLuint index, const GLubyte *v);
void glVertexAttrib4uiv (GLuint index, const GLuint *v);
void glVertexAttrib4usv (GLuint index, const GLushort *v);
void glVertexAttribPointer (GLuint index, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid *pointer);
void glEnableVertexAttribArray (GLuint index);
void glDisableVertexAttribArray (GLuint index);
void glGetVertexAttribdv (GLuint index, GLenum pname, GLdouble *params);
void glGetVertexAttribfv (GLuint index, GLenum pname, GLfloat *params);
void glGetVertexAttribiv (GLuint index, GLenum pname, GLint *params);
void glGetVertexAttribPointerv (GLuint index, GLenum pname, GLvoid* *pointer);
]]

ffi.cdef[[
void glDeleteShader (GLuint shader);
void glDetachShader (GLuint program, GLuint shader);
GLuint glCreateShader (GLenum type);
void glShaderSource (GLuint shader, GLsizei count, const GLchar* *string, const GLint *length);
void glCompileShader (GLuint shader);
GLuint glCreateProgram (void);
void glAttachShader (GLuint program, GLuint shader);
void glLinkProgram (GLuint program);
void glUseProgram (GLuint program);
void glDeleteProgram (GLuint program);
void glValidateProgram (GLuint program);
void glUniform1f (GLint location, GLfloat v0);
void glUniform2f (GLint location, GLfloat v0, GLfloat v1);
void glUniform3f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2);
void glUniform4f (GLint location, GLfloat v0, GLfloat v1, GLfloat v2, GLfloat v3);
void glUniform1i (GLint location, GLint v0);
void glUniform2i (GLint location, GLint v0, GLint v1);
void glUniform3i (GLint location, GLint v0, GLint v1, GLint v2);
void glUniform4i (GLint location, GLint v0, GLint v1, GLint v2, GLint v3);
void glUniform1fv (GLint location, GLsizei count, const GLfloat *value);
void glUniform2fv (GLint location, GLsizei count, const GLfloat *value);
void glUniform3fv (GLint location, GLsizei count, const GLfloat *value);
void glUniform4fv (GLint location, GLsizei count, const GLfloat *value);
void glUniform1iv (GLint location, GLsizei count, const GLint *value);
void glUniform2iv (GLint location, GLsizei count, const GLint *value);
void glUniform3iv (GLint location, GLsizei count, const GLint *value);
void glUniform4iv (GLint location, GLsizei count, const GLint *value);
void glUniformMatrix2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
GLboolean glIsShader (GLuint shader);
GLboolean glIsProgram (GLuint program);
void glGetShaderiv (GLuint shader, GLenum pname, GLint *params);
void glGetProgramiv (GLuint program, GLenum pname, GLint *params);
void glGetAttachedShaders (GLuint program, GLsizei maxCount, GLsizei *count, GLuint *shaders);
void glGetShaderInfoLog (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
void glGetProgramInfoLog (GLuint program, GLsizei bufSize, GLsizei *length, GLchar *infoLog);
GLint glGetUniformLocation (GLuint program, const GLchar *name);
void glGetActiveUniform (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
void glGetUniformfv (GLuint program, GLint location, GLfloat *params);
void glGetUniformiv (GLuint program, GLint location, GLint *params);
void glGetShaderSource (GLuint shader, GLsizei bufSize, GLsizei *length, GLchar *source);
void glBindAttribLocation (GLuint program, GLuint index, const GLchar *name);
void glGetActiveAttrib (GLuint program, GLuint index, GLsizei bufSize, GLsizei *length, GLint *size, GLenum *type, GLchar *name);
GLint glGetAttribLocation (GLuint program, const GLchar *name);
void glStencilFuncSeparate (GLenum face, GLenum func, GLint ref, GLuint mask);
void glStencilOpSeparate (GLenum face, GLenum fail, GLenum zfail, GLenum zpass);
void glStencilMaskSeparate (GLenum face, GLuint mask);
void glUniformMatrix2x3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix3x2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix2x4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix4x2fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix3x4fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
void glUniformMatrix4x3fv (GLint location, GLsizei count, GLboolean transpose, const GLfloat *value);
]]
--]==]
