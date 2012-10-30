local ffi = require("ffi")

local hasbold, hasblink = true, true

local function gettcod()
	local COLS, ROWS = 80, 24
	local termtitle = "libtcod terminal"
	local tcod = ffi.load("libtcod-VS")
	local extended

	ffi.cdef [[
	typedef void * TCOD_console_t;
	typedef unsigned char uint8;
	typedef char int8;
	typedef unsigned short uint16;
	typedef short int16;
	typedef unsigned int uint32;
	typedef int int32;

	typedef long intptr;
	typedef unsigned long uintptr;

	typedef uint8 tcodbool;

	typedef struct {
		uint8 r,g,b;
	} TCOD_color_t;

	typedef enum {
		TCODK_NONE,
		TCODK_ESCAPE,
		TCODK_BACKSPACE,
		TCODK_TAB,
		TCODK_ENTER,
		TCODK_SHIFT,
		TCODK_CONTROL,
		TCODK_ALT,
		TCODK_PAUSE,
		TCODK_CAPSLOCK,
		TCODK_PAGEUP,
		TCODK_PAGEDOWN,
		TCODK_END,
		TCODK_HOME,
		TCODK_UP,
		TCODK_LEFT,
		TCODK_RIGHT,
		TCODK_DOWN,
		TCODK_PRINTSCREEN,
		TCODK_INSERT,
		TCODK_DELETE,
		TCODK_LWIN,
		TCODK_RWIN,
		TCODK_APPS,
		TCODK_0,
		TCODK_1,
		TCODK_2,
		TCODK_3,
		TCODK_4,
		TCODK_5,
		TCODK_6,
		TCODK_7,
		TCODK_8,
		TCODK_9,
		TCODK_KP0,
		TCODK_KP1,
		TCODK_KP2,
		TCODK_KP3,
		TCODK_KP4,
		TCODK_KP5,
		TCODK_KP6,
		TCODK_KP7,
		TCODK_KP8,
		TCODK_KP9,
		TCODK_KPADD,
		TCODK_KPSUB,
		TCODK_KPDIV,
		TCODK_KPMUL,
		TCODK_KPDEC,
		TCODK_KPENTER,
		TCODK_F1,
		TCODK_F2,
		TCODK_F3,
		TCODK_F4,
		TCODK_F5,
		TCODK_F6,
		TCODK_F7,
		TCODK_F8,
		TCODK_F9,
		TCODK_F10,
		TCODK_F11,
		TCODK_F12,
		TCODK_NUMLOCK,
		TCODK_SCROLLLOCK,
		TCODK_SPACE,
		TCODK_CHAR
	} TCOD_keycode_t;

	/* key data : special code or character */
	typedef struct {
		TCOD_keycode_t vk; /*  key code */
		char c; /* character if vk == TCODK_CHAR else 0 */
		tcodbool pressed ; /* does this correspond to a key press or key release event ? */
		tcodbool lalt ;
		tcodbool lctrl ;
		tcodbool ralt ;
		tcodbool rctrl ;
		tcodbool shift ;
	} TCOD_key_t;

	typedef enum {
		/* single walls */
		TCOD_CHAR_HLINE=196,
		TCOD_CHAR_VLINE=179,
		TCOD_CHAR_NE=191,
		TCOD_CHAR_NW=218,
		TCOD_CHAR_SE=217,
		TCOD_CHAR_SW=192,
		TCOD_CHAR_TEEW=180,
		TCOD_CHAR_TEEE=195,
		TCOD_CHAR_TEEN=193,
		TCOD_CHAR_TEES=194,
		TCOD_CHAR_CROSS=197,
		/* double walls */
		TCOD_CHAR_DHLINE=205,
		TCOD_CHAR_DVLINE=186,
		TCOD_CHAR_DNE=187,
		TCOD_CHAR_DNW=201,
		TCOD_CHAR_DSE=188,
		TCOD_CHAR_DSW=200,
		TCOD_CHAR_DTEEW=185,
		TCOD_CHAR_DTEEE=204,
		TCOD_CHAR_DTEEN=202,
		TCOD_CHAR_DTEES=203,
		TCOD_CHAR_DCROSS=206,
		/* blocks */
		TCOD_CHAR_BLOCK1=176,
		TCOD_CHAR_BLOCK2=177,
		TCOD_CHAR_BLOCK3=178,
		/* arrows */
		TCOD_CHAR_ARROW_N=24,
		TCOD_CHAR_ARROW_S=25,
		TCOD_CHAR_ARROW_E=26,
		TCOD_CHAR_ARROW_W=27,
		/* arrows without tail */
		TCOD_CHAR_ARROW2_N=30,
		TCOD_CHAR_ARROW2_S=31,
		TCOD_CHAR_ARROW2_E=16,
		TCOD_CHAR_ARROW2_W=17,
		/* double arrows */
		TCOD_CHAR_DARROW_H=29,
		TCOD_CHAR_DARROW_V=18,
		/* GUI stuff */
		TCOD_CHAR_CHECKBOX_UNSET=224,
		TCOD_CHAR_CHECKBOX_SET=225,
		TCOD_CHAR_RADIO_UNSET=9,
		TCOD_CHAR_RADIO_SET=10,
		/* sub-pixel resolution kit */
		TCOD_CHAR_SUBP_NW=226,
		TCOD_CHAR_SUBP_NE=227,
		TCOD_CHAR_SUBP_N=228,
		TCOD_CHAR_SUBP_SE=229,
		TCOD_CHAR_SUBP_DIAG=230,
		TCOD_CHAR_SUBP_E=231,
		TCOD_CHAR_SUBP_SW=232,
		/* miscellaneous */
		TCOD_CHAR_SMILIE = 1,
		TCOD_CHAR_SMILIE_INV = 2,
		TCOD_CHAR_HEART = 3,
		TCOD_CHAR_DIAMOND = 4,
		TCOD_CHAR_CLUB = 5,
		TCOD_CHAR_SPADE = 6,
		TCOD_CHAR_BULLET = 7,
		TCOD_CHAR_BULLET_INV = 8,
		TCOD_CHAR_MALE = 11,
		TCOD_CHAR_FEMALE = 12,
		TCOD_CHAR_NOTE = 13,
		TCOD_CHAR_NOTE_DOUBLE = 14,
		TCOD_CHAR_LIGHT = 15,
		TCOD_CHAR_EXCLAM_DOUBLE = 19,
		TCOD_CHAR_PILCROW = 20,
		TCOD_CHAR_SECTION = 21,
		TCOD_CHAR_POUND = 156,
		TCOD_CHAR_MULTIPLICATION = 158,
		TCOD_CHAR_FUNCTION = 159,
		TCOD_CHAR_RESERVED = 169,
		TCOD_CHAR_HALF = 171,
		TCOD_CHAR_ONE_QUARTER = 172,
		TCOD_CHAR_COPYRIGHT = 184,
		TCOD_CHAR_CENT = 189,
		TCOD_CHAR_YEN = 190,
		TCOD_CHAR_CURRENCY = 207,
		TCOD_CHAR_THREE_QUARTERS = 243,
		TCOD_CHAR_DIVISION = 246,
		TCOD_CHAR_GRADE = 248,
		TCOD_CHAR_UMLAUT = 249,
		TCOD_CHAR_POW1 = 251,
		TCOD_CHAR_POW3 = 252,
		TCOD_CHAR_POW2 = 253,
		TCOD_CHAR_BULLET_SQUARE = 254,
		/* diacritics */
	} TCOD_chars_t;

	typedef enum {
		TCOD_COLCTRL_1 = 1,
		TCOD_COLCTRL_2,
		TCOD_COLCTRL_3,
		TCOD_COLCTRL_4,
		TCOD_COLCTRL_5,
		TCOD_COLCTRL_NUMBER=5,
		TCOD_COLCTRL_FORE_RGB,
		TCOD_COLCTRL_BACK_RGB,
		TCOD_COLCTRL_STOP
	} TCOD_colctrl_t;

	typedef enum {
		TCOD_BKGND_NONE,
		TCOD_BKGND_SET,
		TCOD_BKGND_MULTIPLY,
		TCOD_BKGND_LIGHTEN,
		TCOD_BKGND_DARKEN,
		TCOD_BKGND_SCREEN,
		TCOD_BKGND_COLOR_DODGE,
		TCOD_BKGND_COLOR_BURN,
		TCOD_BKGND_ADD,
		TCOD_BKGND_ADDA,
		TCOD_BKGND_BURN,
		TCOD_BKGND_OVERLAY,
		TCOD_BKGND_ALPH,
		TCOD_BKGND_DEFAULT
	} TCOD_bkgnd_flag_t;

	typedef enum {
		TCOD_KEY_PRESSED=1,
		TCOD_KEY_RELEASED=2,
	} TCOD_key_status_t;

	/* custom font flags */
	typedef enum {
		TCOD_FONT_LAYOUT_ASCII_INCOL=1,
		TCOD_FONT_LAYOUT_ASCII_INROW=2,
		TCOD_FONT_TYPE_GREYSCALE=4,
		TCOD_FONT_TYPE_GRAYSCALE=4,
		TCOD_FONT_LAYOUT_TCOD=8,
	} TCOD_font_flags_t;

	typedef enum {
		TCOD_RENDERER_GLSL,
		TCOD_RENDERER_OPENGL,
		TCOD_RENDERER_SDL,
		TCOD_NB_RENDERERS,
	} TCOD_renderer_t;

	typedef enum {
		TCOD_LEFT, 
		TCOD_RIGHT, 
		TCOD_CENTER 
	} TCOD_alignment_t;

	// image.h

	typedef void *TCOD_image_t;

	TCOD_image_t TCOD_image_new(int width, int height);
	TCOD_image_t TCOD_image_from_console(TCOD_console_t console);
	void TCOD_image_refresh_console(TCOD_image_t image, TCOD_console_t console);
	TCOD_image_t TCOD_image_load(const char *filename);
	void TCOD_image_clear(TCOD_image_t image, TCOD_color_t color);
	void TCOD_image_invert(TCOD_image_t image);
	void TCOD_image_hflip(TCOD_image_t image);
	void TCOD_image_rotate90(TCOD_image_t image, int numRotations);
	void TCOD_image_vflip(TCOD_image_t image);
	void TCOD_image_scale(TCOD_image_t image, int neww, int newh);
	void TCOD_image_save(TCOD_image_t image, const char *filename);
	void TCOD_image_get_size(TCOD_image_t image, int *w,int *h);
	TCOD_color_t TCOD_image_get_pixel(TCOD_image_t image,int x, int y);
	int TCOD_image_get_alpha(TCOD_image_t image,int x, int y);
	TCOD_color_t TCOD_image_get_mipmap_pixel(TCOD_image_t image,float x0,float y0, float x1, float y1);
	void TCOD_image_put_pixel(TCOD_image_t image,int x, int y,TCOD_color_t col);
	void TCOD_image_blit(TCOD_image_t image, TCOD_console_t console, float x, float y, 
		TCOD_bkgnd_flag_t bkgnd_flag, float scalex, float scaley, float angle);
	void TCOD_image_blit_rect(TCOD_image_t image, TCOD_console_t console, int x, int y, int w, int h, 
		TCOD_bkgnd_flag_t bkgnd_flag);
	void TCOD_image_blit_2x(TCOD_image_t image, TCOD_console_t dest, int dx, int dy, int sx, int sy, int w, int h);
	void TCOD_image_delete(TCOD_image_t image);
	void TCOD_image_set_key_color(TCOD_image_t image, TCOD_color_t key_color);
	tcodbool TCOD_image_is_pixel_transparent(TCOD_image_t image, int x, int y);


	// sys.h

	uint32 TCOD_sys_elapsed_milli();
	float TCOD_sys_elapsed_seconds();
	void TCOD_sys_sleep_milli(uint32 val);
	void TCOD_sys_save_screenshot(const char *filename);
	void TCOD_sys_force_fullscreen_resolution(int width, int height);
	void TCOD_sys_set_renderer(TCOD_renderer_t renderer);
	TCOD_renderer_t TCOD_sys_get_renderer();
	void TCOD_sys_set_fps(int val);
	int TCOD_sys_get_fps();
	float TCOD_sys_get_last_frame_length();
	void TCOD_sys_get_current_resolution(int *w, int *h);
	void TCOD_sys_get_fullscreen_offsets(int *offx, int *offy);
	void TCOD_sys_update_char(int asciiCode, int fontx, int fonty, TCOD_image_t img, int x, int y);
	void TCOD_sys_get_char_size(int *w, int *h);


	// console.h

	void TCOD_console_init_root(int w, int h, const char * title, tcodbool fullscreen, TCOD_renderer_t renderer);
	void TCOD_console_set_window_title(const char *title);
	void TCOD_console_set_fullscreen(tcodbool fullscreen);
	tcodbool TCOD_console_is_fullscreen();
	tcodbool TCOD_console_is_window_closed();

	void TCOD_console_set_custom_font(const char *fontFile, int flags,int nb_char_horiz, int nb_char_vertic);
	void TCOD_console_map_ascii_code_to_font(int asciiCode, int fontCharX, int fontCharY);
	void TCOD_console_map_ascii_codes_to_font(int asciiCode, int nbCodes, int fontCharX, int fontCharY);
	void TCOD_console_map_string_to_font(const char *s, int fontCharX, int fontCharY);

	void TCOD_console_set_dirty(int x, int y, int w, int h);
	void TCOD_console_set_default_background(TCOD_console_t con,TCOD_color_t col);
	void TCOD_console_set_default_foreground(TCOD_console_t con,TCOD_color_t col);
	void TCOD_console_clear(TCOD_console_t con);
	void TCOD_console_set_char_background(TCOD_console_t con,int x, int y, TCOD_color_t col, TCOD_bkgnd_flag_t flag);
	void TCOD_console_set_char_foreground(TCOD_console_t con,int x, int y, TCOD_color_t col);
	void TCOD_console_set_char(TCOD_console_t con,int x, int y, int c);
	void TCOD_console_put_char(TCOD_console_t con,int x, int y, int c, TCOD_bkgnd_flag_t flag);
	void TCOD_console_put_char_ex(TCOD_console_t con,int x, int y, int c, TCOD_color_t fore, TCOD_color_t back);

	void TCOD_console_set_background_flag(TCOD_console_t con,TCOD_bkgnd_flag_t flag);
	TCOD_bkgnd_flag_t TCOD_console_get_background_flag(TCOD_console_t con);
	void TCOD_console_set_alignment(TCOD_console_t con,TCOD_alignment_t alignment);
	TCOD_alignment_t TCOD_console_get_alignment(TCOD_console_t con);
	void TCOD_console_print(TCOD_console_t con,int x, int y, const char *fmt, ...);
	void TCOD_console_print_ex(TCOD_console_t con,int x, int y, TCOD_bkgnd_flag_t flag, TCOD_alignment_t alignment, const char *fmt, ...);
	int TCOD_console_print_rect(TCOD_console_t con,int x, int y, int w, int h, const char *fmt, ...);
	int TCOD_console_print_rect_ex(TCOD_console_t con,int x, int y, int w, int h, TCOD_bkgnd_flag_t flag, TCOD_alignment_t alignment, const char *fmt, ...);
	int TCOD_console_get_height_rect(TCOD_console_t con,int x, int y, int w, int h, const char *fmt, ...);

	void TCOD_console_rect(TCOD_console_t con,int x, int y, int w, int h, tcodbool clear, TCOD_bkgnd_flag_t flag);
	void TCOD_console_hline(TCOD_console_t con,int x,int y, int l, TCOD_bkgnd_flag_t flag);
	void TCOD_console_vline(TCOD_console_t con,int x,int y, int l, TCOD_bkgnd_flag_t flag);
	void TCOD_console_print_frame(TCOD_console_t con,int x,int y,int w,int h, tcodbool empty, TCOD_bkgnd_flag_t flag, const char *fmt, ...);

	TCOD_color_t TCOD_console_get_default_background(TCOD_console_t con);
	TCOD_color_t TCOD_console_get_default_foreground(TCOD_console_t con);
	TCOD_color_t TCOD_console_get_char_background(TCOD_console_t con,int x, int y);
	TCOD_color_t TCOD_console_get_char_foreground(TCOD_console_t con,int x, int y);
	int TCOD_console_get_char(TCOD_console_t con,int x, int y);

	void TCOD_console_set_fade(uint8 val, TCOD_color_t fade);
	uint8 TCOD_console_get_fade();
	TCOD_color_t TCOD_console_get_fading_color();

	void TCOD_console_flush();

	void TCOD_console_set_color_control(TCOD_colctrl_t con, TCOD_color_t fore, TCOD_color_t back);

	TCOD_key_t TCOD_console_check_for_keypress(int flags);
	TCOD_key_t TCOD_console_wait_for_keypress(tcodbool flush);
	void TCOD_console_set_keyboard_repeat(int initial_delay, int interval);
	void TCOD_console_disable_keyboard_repeat();
	tcodbool TCOD_console_is_key_pressed(TCOD_keycode_t key);

	TCOD_console_t TCOD_console_new(int w, int h);
	int TCOD_console_get_width(TCOD_console_t con);
	int TCOD_console_get_height(TCOD_console_t con);
	void TCOD_console_set_key_color(TCOD_console_t con,TCOD_color_t col);
	void TCOD_console_blit(TCOD_console_t src,int xSrc, int ySrc, int wSrc, int hSrc, TCOD_console_t dst, int xDst, int yDst, float foreground_alpha, float background_alpha);
	 void TCOD_console_delete(TCOD_console_t console);

	 void TCOD_console_credits();
	 void TCOD_console_credits_reset();
	 tcodbool TCOD_console_credits_render(int x, int y, tcodbool alpha);
	]]

	-- a table of attributes and colors

	local attr = {
		blink = bit.lshift(1, 8 + 11),
		bold = bit.lshift(1, 8 + 13),
		color = {
			black = 0,
			red = 1,
			green = 2,
			yellow = 3,
			blue = 4,
			magenta = 5,
			cyan = 6,
			gray = 7
		},
		colors = {}, 
		palette = {
			{0,0,0},
			{128,0,0},
			{0,128,0},
			{140,128,40},
			{0,0,128},
			{128,0,128},
			{0,128,136},
			{128,128,128},
			
			{96,96,96},
			{255,0,0},
			{0,255,0},
			{255,240,60},
			{0,0,255},
			{255,0,255},
			{0,240,255},
			{255,255,255}
		}
	}

	for k = 0, 15 do
		local v = attr.palette[k + 1]
		--local c = attr.colors[k]

		local c = ffi.new("TCOD_color_t")
		c.r = v[1]
		c.g = v[2]
		c.b = v[3]

		attr.colors[k] = c
	end

	local fontsize
	local widths = {112, 128, 144, 160, 176, 192, 208, 224, 240, 256, 272, 288, 304}
	local heights = {176, 208, 240, 272, 304, 336, 368, 400, 432, 464, 496, 528, 528};


	local function compute_aspect()
		local width, height = ffi.new("int[1]"), ffi.new("int[1]")
		tcod.TCOD_sys_get_char_size(width, height)
		extended.aspect = width[0] / height[0]
	end

	local function start()
		local width, height = ffi.new("int[1]"), ffi.new("int[1]")
		tcod.TCOD_sys_get_current_resolution(width, height)
		width[0] = width[0] - 6
		height[0] = height[0] - 48 -- make some room for title bars or whatever


		fontsize = 13
		while fontsize > 1 and (widths[fontsize] * COLS / 16 >= width[0] or heights[fontsize] * ROWS / 16 >= height[0]) do
			fontsize = fontsize - 1
		end

		local font = "fonts/font-" .. tostring(fontsize) .. ".png"
		-- local font = "fonts/CapNap.bmp"
		--local font = "fonts/Mandrill.bmp"
		
		local renderer = tcod.TCOD_RENDERER_SDL

		tcod.TCOD_console_set_custom_font(font, (tcod.TCOD_FONT_TYPE_GREYSCALE + tcod.TCOD_FONT_LAYOUT_ASCII_INROW), 0, 0);
		tcod.TCOD_console_init_root(COLS, ROWS, termtitle, 0, renderer);
		tcod.TCOD_console_map_ascii_codes_to_font(0, 255, 0, 0);
		tcod.TCOD_console_set_keyboard_repeat(175, 30);

		compute_aspect()
	end

	local function resize(delta)
		fontsize = fontsize + delta
		if fontsize < 1 then fontsize = 1 return end
		if fontsize > 13 then fontsize = 13 return end
		
		tcod.TCOD_console_delete(nil);

		local font = "fonts/font-" .. tostring(fontsize) .. ".png"
		extended.aspect = widths[fontsize] / heights[fontsize]
		local renderer = tcod.TCOD_RENDERER_SDL

		tcod.TCOD_console_set_custom_font(font, (tcod.TCOD_FONT_TYPE_GREYSCALE + tcod.TCOD_FONT_LAYOUT_ASCII_INROW), 0, 0);
		tcod.TCOD_console_init_root(COLS, ROWS, termtitle, 0, renderer);
		tcod.TCOD_console_map_ascii_codes_to_font(0, 255, 0, 0);
		tcod.TCOD_console_set_keyboard_repeat(175, 30);

		compute_aspect()

		tcod.TCOD_console_flush();
	end

	local function settitle(title)
		termtitle = title
		tcod.TCOD_console_set_window_title(title)
	end
	local function refresh()
		tcod.TCOD_console_flush()
	end
	local function erase()
		tcod.TCOD_console_clear(nil)
	end
	local function napms(ms)
		tcod.TCOD_sys_sleep_milli(ms)
	end
	local function getms()
		return tcod.TCOD_sys_elapsed_milli()
	end
	
	local function clean()
		tcod.TCOD_console_delete(nil);
	end

	local tcod_vk = {
		"escape", "backspace", "tab", "enter",
		"shift", "control", "alt", "pause", "capslock",
		"pageup", "pagedown", "end", "home",
		"up", "left", "right", "down",
		"printscreen", "insert", "delete",
		"lwin", "rwin", "apps",
		"0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
		"numpad-0", "numpad-1", "numpad-2",
		"numpad-3", "numpad-4", "numpad-5",
		"numpad-6", "numpad-7", "numpad-8",
		"numpad-9", "numpad-add", "numpad-sub",
		"numpad-div", "numpad-mul", "numpad-dec", "numpad-enter",
		"f1", "f2", "f3", "f4", "f5", "f6",
		"f7", "f8", "f9", "f10", "f11", "f12",
		"numlock", "scrolllock", "space"
	}

	local function name_and_char(key)
		if key.lctrl == 1 or key.rctrl == 1 then
			-- bad special case
			if key.vk == tcod.TCODK_PAGEUP then
				resize(1)
				return "resized", nil
			elseif key.vk == tcod.TCODK_PAGEDOWN then
				resize(-1)
				return "resized", nil
			end
		end

		local prefix = ""
		if key.shift == 1 and key.vk ~= tcod.TCODK_CHAR then
			prefix = "shift-"
		end
		if key.lctrl == 1 or key.rctrl == 1 then
			prefix = "ctrl-" .. prefix
		end
		
		if not key or key.vk == tcod.TCODK_NONE then
			return nil
		elseif key.vk == tcod.TCODK_SPACE then
			return prefix .. "space", " "
		elseif key.vk == tcod.TCODK_CHAR then
			local ch = string.char(key.c)
			return prefix .. ch, ch
		elseif key.vk >= tcod.TCODK_0 and key.vk <= tcod.TCODK_9 then
			return prefix .. tcod_vk[key.vk], string.char(48 + (key.vk - tcod.TCODK_0))
		elseif key.vk >= tcod.TCODK_KP0 and key.vk <= tcod.TCODK_KP9 then
			return prefix .. tcod_vk[key.vk], string.char(48 + (key.vk - tcod.TCODK_KP0))
		else
			return prefix .. tcod_vk[key.vk], nil
		end
	end

	extended = {
		settitle = settitle,
		refresh = refresh,
		erase = erase,
		resize = resize,
		napms = napms,	
		getms = getms,
		LINES = ROWS,
		ROWS = ROWS,
		COLS = COLS,
		aspect = aspect,
		name_and_char = name_and_char
	}

	os.atexit(clean)
	start()
	
	return tcod, attr, extended
end


local function adapter()
	local tcod, attr, extended = gettcod()
	local fore, back = attr.colors[15], attr.colors[0]
	local fc, bc = ffi.new("TCOD_color_t"), ffi.new("TCOD_color_t")

	local function color4(fg, bg)
		fore, back = attr.colors[fg], attr.colors[bg]
	end

	local function color32(fg, bg)
		fore, back = fc, bc

		fc.r, fc.g, fc.b = fg:clip()
		bc.r, bc.g, bc.b = bg:clip()
	end
	
	local function putch(x, y, ch)
		tcod.TCOD_console_put_char_ex(nil, x, y, ch, fore, back);
	end

	local function getch(noblock)
		do
			local key
			if noblock then
				extended.refresh()
				key = tcod.TCOD_console_check_for_keypress(tcod.TCOD_KEY_PRESSED)
			else
				extended.refresh()
				key = tcod.TCOD_console_wait_for_keypress(0)
			end

			local name, char = extended.name_and_char(key)
			
			if name ~= nil then
				return name, char
			end
		end
	end

	local function getmouse()
		local mouse = TCOD_mouse_get_status();
		return mouse.cx, mouse.cy
	end

	local function getsize()
		return clipwidth or extended.COLS, clipheight or extended.LINES, extended.aspect
	end

	return {
		color4 = color4,
		color32 = color32,
		putch = putch,

		getch = getch,
		getsize = getsize,

		refresh = extended.refresh,
		erase = extended.erase,
		endwin = extended.endwin,
		napms = extended.napms,
		
		getms = extended.getms,
		
		settitle = extended.settitle
	}
end

return adapter()


