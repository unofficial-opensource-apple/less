##
# Makefile for less
##

# Project info
Project         = less
UserType        = Administration
ToolType        = Commands
GnuAfterInstall = link-more install-man install-plist
Extra_CC_Flags  = -mdynamic-no-pic

# It's a GNU Source project
include $(MAKEFILEPATH)/CoreOS/ReleaseControl/GNUSource.make

# Automatic Extract & Patch
AEP            = YES
AEP_Project    = $(Project)
AEP_Version    = 394
AEP_ProjVers   = $(AEP_Project)-$(AEP_Version)
AEP_Filename   = $(AEP_ProjVers).tar.gz
AEP_ExtractDir = $(AEP_ProjVers)
AEP_Patches    = command.c.diff forwback.c.diff main.c.diff \
                 screen.c.diff search.c.diff signal.c.diff \
                 decode.c.diff funcs.h.diff main.c.diff2 screen.c.diff2 \
                 funcs.h.diff2 command.c.diff2 edit.c.diff \
                 ifile.c.diff main.c.diff3 optfunc.c.diff option.c.diff \
                 opttbl.c.diff tags.c.diff ttyin.c.diff position.c.diff \
                 main.c.diff4

ifeq ($(suffix $(AEP_Filename)),.bz2)
AEP_ExtractOption = j
else
AEP_ExtractOption = z
endif

# Extract the source.
install_source::
ifeq ($(AEP),YES)
	$(TAR) -C $(SRCROOT) -$(AEP_ExtractOption)xf $(SRCROOT)/$(AEP_Filename)
	$(RMDIR) $(SRCROOT)/$(AEP_Project)
	$(MV) $(SRCROOT)/$(AEP_ExtractDir) $(SRCROOT)/$(AEP_Project)
	for patchfile in $(AEP_Patches); do \
		cd $(SRCROOT)/$(Project) && patch -p0 < $(SRCROOT)/patches/$$patchfile; \
	done
endif

link-more:
	$(LN) $(DSTROOT)/usr/bin/less $(DSTROOT)/usr/bin/more
	$(LN) $(DSTROOT)/usr/share/man/man1/less.1 $(DSTROOT)/usr/share/man/man1/more.1

# We install GNU Debian's lessecho.1 man page, because less does not come with one.
install-man:
	$(INSTALL_DIRECTORY) $(DSTROOT)/usr/share/man/man1
	$(INSTALL_FILE) $(SRCROOT)/lessecho.1 $(DSTROOT)/usr/share/man/man1/lessecho.1

OSV     = $(DSTROOT)/usr/local/OpenSourceVersions
OSL     = $(DSTROOT)/usr/local/OpenSourceLicenses

install-plist:
	$(MKDIR) $(OSV)
	$(INSTALL_FILE) $(SRCROOT)/$(Project).plist $(OSV)/$(Project).plist
	$(MKDIR) $(OSL)
	$(INSTALL_FILE) $(Sources)/LICENSE $(OSL)/$(Project).txt
