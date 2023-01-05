build-cp:
	swift build --configuration release
	sudo rm /usr/local/bin/xc
	sudo cp .build/arm64-apple-macosx/release/xc /usr/local/bin/xc

