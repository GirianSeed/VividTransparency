#
# Makefile for "Vivid Transparency"
# ZONE OF THE ENDERS Toolbox
#

GCC_WIN32 = i686-w64-mingw32-gcc
GXX_WIN32 = i686-w64-mingw32-g++
GCC_WIN64 = x86_64-w64-mingw32-gcc
GXX_WIN64 = x86_64-w64-mingw32-g++
GCC_ARGS  = -Wall -g

#---------------------------------------------------------------------------#

all: \
	archive \
	video \
	texture \
	sound

archive: \
	dat-extract \
	pak-extract

video: \
	pss-demux \
	subtitle-convert

texture: \
	tex-to_image

sound: \
	sdx-extract \
	wvx-extract \
	mdx-splitter \
	efx-splitter \
	mdx-parser

#---------------------------------------------------------------------------#
# Objects
#---------------------------------------------------------------------------#

LODEPNG     = lodepng/lodepng.o
KOJIMASOUND = kojimasound/kojimasound.o

%.o: %.c
	$(CC) $(GCC_ARGS) -o $@ -c $<

#---------------------------------------------------------------------------#
# Targets
#---------------------------------------------------------------------------#

OPT_STATIC_ICONV =
PROC_APPEND_EXT  = mv $@ $@.elf

ifeq ($(OS),Windows_NT)
OPT_STATIC_ICONV = -Wl,-Bstatic -liconv
PROC_APPEND_EXT  =
endif

# --- archive ---
dat-extract: dat-extract.c
	$(CC) $(GCC_ARGS) -o $@ $<
	$(PROC_APPEND_EXT)

pak-extract: pak-extract.c
	$(CC) $(GCC_ARGS) -o $@ $<
	$(PROC_APPEND_EXT)

# --- video ---
pss-demux: pss-demux.c
	$(CC) $(GCC_ARGS) -o $@ $<
	$(PROC_APPEND_EXT)

subtitle-convert: subtitle-convert.c
	$(CC) $(GCC_ARGS) -o $@ $< $(OPT_STATIC_ICONV)
	$(PROC_APPEND_EXT)

# --- texture ---
tex-to_image: $(LODEPNG) tex-to_image.c
	$(CC) $(GCC_ARGS) -o $@ $^
	$(PROC_APPEND_EXT)

# --- sound	 ---
sdx-extract: sdx-extract.c
	$(CC) $(GCC_ARGS) -o $@ $<
	$(PROC_APPEND_EXT)

wvx-extract: $(KOJIMASOUND) wvx-extract.c
	$(CC) $(GCC_ARGS) -o $@ $^
	$(PROC_APPEND_EXT)
	
mdx-splitter: $(KOJIMASOUND) mdx-splitter.c
	$(CC) $(GCC_ARGS) -o $@ $^
	$(PROC_APPEND_EXT)
	
efx-splitter: $(KOJIMASOUND) efx-splitter.c
	$(CC) $(GCC_ARGS) -o $@ $^
	$(PROC_APPEND_EXT)
	
mdx-parser: $(KOJIMASOUND) mdx-parser.c
	$(CC) $(GCC_ARGS) -o $@ $^
	$(PROC_APPEND_EXT)

#---------------------------------------------------------------------------#

clean: \
	clean_obj \
	clean_exe

clean_obj:
	-rm *.o
	-rm $(LODEPNG)
	-rm $(KOJIMASOUND)

clean_exe:
	-rm *.exe *.elf
