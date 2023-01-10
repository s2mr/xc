build-cp-zsh:
	swift build --configuration release --arch arm64 --arch x86_64
	sudo rm /usr/local/bin/xc
	sudo cp .build/apple/Products/Release/xc /usr/local/bin/xc
	make install-completion-zsh

install-completion-zsh:
	mkdir -p ~/.zsh/competion
	xc --generate-completion-script zsh > ~/.zsh/completion/_xc
