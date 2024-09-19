SHELL=/bin/bash
PROJ_DIR:=$(shell pwd)

export TARGET_TOOL_PATH  := /opt/xilinx-sdk-2019.1
export PATH := $(PATH)

RM       := rm -rf
CD       := cd
MKDIR    := mkdir -p
LN       := ln -s
CP       := cp -r
LS       := ls
SIZE     := size
CMAKE    := cmake
MV       := mv
CAT      := cat
RELNOTES := ./release/release-notes.md
RNAPP    := ./release/xr-release-notes.md
RNTMP    := $(shell mktemp)
BRANCH   := $(shell git rev-parse --abbrev-ref HEAD)
TAG      := $(shell git describe --abbrev=0)
JCNT     := $$(( `nproc` + 1 ))
JOBS     := -j$(JCNT) -O 
STAGE       := $(PROJ_DIR)/stage
AMCU_DIR    := $(PROJ_DIR)/amcu
DEPLOY_DIR := $(AMCU_DIR)/deploy
RSABIN_DIR := $(AMCU_DIR)/rsakeys
NVRBIN_DIR  := $(AMCU_DIR)/gennvr
JLINK_DIR := $(PROJ_DIR)/tools/dev

ifeq ($(VERBOSE),2)
else ifeq ($(VERBOSE),1)
        Q=@
else
        Q=@
        MAKEFLAGS+=-s
	SILENCE_OUTPUT=>/dev/null
endif

# Determine if dbg symbols should be used
BUILD_TYPE = Release
INSTALL_TYPE=/strip
ifeq ($(DBG),)
else ifeq ($(DBG),0)
else
    BUILD_TYPE=Debug
    INSTALL_TYPE=
endif

export Q

# FIXME JS: 11/29/2021 Need to eventually add building and using of signing
# utilities such that builds can be loaded on secure boot capable board

.PHONY: db sql cleandb

.DEFAULT: all

all: amcu-full

githooks-amcu:
	cd $(AMCU_DIR) ; $(MAKE) git-hooks

.PHONY: covdb covamcu-full clean TAGS

amcu-full:
	@echo "Running amcu build"
	$(CD) $(AMCU_DIR); \
	$(MAKE) amcuapp;

.PHONY: amcu-full-clean

amcu-full-clean:
	@echo "Cleaning AMCU submodule started..."
	$(CD) $(AMCU_DIR); \
	$(MAKE) cleanall; \
	echo "...Cleaning AMCU submodule completed"

clean: amcu-full-clean

# FIXME JS 11-17-22, blindly applying patch, need to move to automated patch finding and application. Ok
# for now just to get PR builds going until we have need of more patches
refresh-libs:
	@echo "Cleaning and refetching libs from servers"
	./cleanReleaseDirs.sh;
	export CY_TOOLS_PATHS=/opt/ModusToolbox/tools_3.0/; \
	$(RM) $(AMCU_DIR)/src/app_cm4/libs/; \
	$(RM) $(AMCU_DIR)/src/app_cm0p/libs/; \
	$(CD) $(AMCU_DIR)/src/app_cm4/; \
	$(MAKE) getlibs; \
	$(CD) libs/TARGET_CY8CKIT-062S2-43012/; \
	git apply ../../../../mtb_shared/infn-patch/TARGET_CY8CKIT-062S2-43012-FW9645-1.patch; \
	$(CD) $(AMCU_DIR)/src/app_cm0p/libs/TARGET_CY8CKIT-062S2-43012/; \
	git apply ../../../../mtb_shared/infn-patch/TARGET_CY8CKIT-062S2-43012-FW9645-1.patch; \
	$(CD) ../../;
	@echo "Creating licenses directory"
	@echo "--------------------------------------------------------------------"
	$(CD)
	$(MKDIR) output/image/licenses
	$(CD) amcu/mtb_shared && find .  \( -name "*EULA*" -o -name "*LIC*" \) -exec cp --parents -v "{}" ../../output/image/licenses/ \;

# FIXME JS 1/10/22 ideally calbin/db would be dependencies, but due to alldev
# building linux versions first, this will fail due to above issues with
# architecture changes mid compile which need new CMake files.
package: amcu-full
	$(CD) $(AMCU_DIR); $(MAKE) gentoc2
	@echo "Creating output staging areas..."
	$(RM) $(PROJ_DIR)/output
	$(MKDIR) $(PROJ_DIR)/output/image
	$(MKDIR) $(PROJ_DIR)/output/dev
	@echo "Fetching components..."
	@echo "...debug files..."
	$(CP) $(AMCU_DIR)/image/share/* $(PROJ_DIR)/output/dev/.
	$(CD) $(PROJ_DIR)/output/dev; \
	tar -czvf ../debug.tar.gz *
	$(CD) $(PROJ_DIR)
	@echo "...target image files..."
	$(CD) $(PROJ_DIR)/output/image; \
	$(CP) $(DEPLOY_DIR)/amcuapp.hex .; \
	$(CP) $(DEPLOY_DIR)/amcuapp.bin .; \
	$(CP) $(DEPLOY_DIR)/amcuappA.bin .; \
	$(CP) $(DEPLOY_DIR)/amcuappB.bin .; \
	$(CP) $(DEPLOY_DIR)/amcuappA.hex .; \
	$(CP) $(DEPLOY_DIR)/amcuappB.hex .; \
	$(CP) $(RSABIN_DIR)/amcu_toc2.bin .; \
	$(CP) $(RSABIN_DIR)/amcu_public_key.bin .; \
	$(CP) $(RSABIN_DIR)/amcu_toc2_zero.bin .; \
	$(CP) $(RSABIN_DIR)/amcu_public_key_zero.bin .; \
	$(CP) $(RSABIN_DIR)/amcu_toc2.hex .; \
	$(CP) $(RSABIN_DIR)/amcu_public_key.hex .; \
	$(CP) $(RSABIN_DIR)/amcu_toc2_zero.hex .; \
	$(CP) $(RSABIN_DIR)/amcu_public_key_zero.hex .; \
	$(CP) $(JLINK_DIR)/amcu.jlink .; \
	$(CP) $(JLINK_DIR)/amcu_zero.jlink .; \
	$(CP) $(JLINK_DIR)/programAmcu.sh .; \
	tar -czvf ../complete_target.tar.gz *;
	@echo "Package complete! Ready for distribution or release"
	@echo "Artifacts found in output/ directory"
