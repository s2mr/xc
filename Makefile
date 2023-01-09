build-cp:
	swift build --configuration release --arch arm64 --arch x86_64
	sudo rm /usr/local/bin/xc
	sudo cp .build/apple/Products/Release/xc /usr/local/bin/xc