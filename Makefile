SWIFT_BUILD_FLAGS := -c release --disable-sandbox --arch arm64 --arch x86_64
TOOL_NAME := xc
GITHUB_REPO := s2mr/$(TOOL_NAME)

TOOL_BIN_DIR := $(shell swift build $(SWIFT_BUILD_FLAGS) --show-bin-path)
TOOL_BIN := $(TOOL_BIN_DIR)/$(TOOL_NAME)

.PHONY: $(MAKECMDGOALS)

build-cp-zsh: build
	sudo rm -f /usr/local/bin/xc
	sudo cp $(TOOL_BIN) /usr/local/bin/xc
	make install-completion-zsh

install-completion-zsh:
	mkdir -p ~/.zsh/competion
	xc --generate-completion-script zsh > ~/.zsh/completion/_xc

build:
	swift build $(SWIFT_BUILD_FLAGS)
	@echo $(TOOL_BIN)

zip: build
	rm -f $(TOOL_NAME).zip
	zip -j $(TOOL_NAME).zip $(TOOL_BIN)

upload-zip: zip
	@[ -n "$(GITHUB_TOKEN)" ] || (echo "\nERROR: Make sure setting environment variable 'GITHUB_TOKEN'." && exit 1)
	@[ -n "$(GITHUB_RELEASE_ID)" ] || (echo "\nERROR: Make sure setting environment variable 'GITHUB_RELEASE_ID'." && exit 1)
	curl -sSL -X POST \
	  -H "Authorization: token $(GITHUB_TOKEN)" \
	  -H "Content-Type: application/zip" \
	  --upload-file "./$(TOOL_NAME).zip" "https://uploads.github.com/repos/$(GITHUB_REPO)/releases/$(GITHUB_RELEASE_ID)/assets?name=$(TOOL_NAME).zip"
