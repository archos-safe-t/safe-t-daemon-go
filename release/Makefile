all: .windows .linux .macos .copy

FILE="../VERSION"
VERSION=$(shell cat $(FILE))
BUCKET=gs://safe-t-software/bridge

.linux:
	make -C linux all

.macos:
	make -C macos all

.windows:
	make -C windows all

.copy:
	rm -rf installers
	mkdir installers
	cp macos/build/*.pkg installers
	cp windows/build/safe-t-bridge*.exe installers
	cp linux/build/*.deb linux/build/*.rpm installers

.gpg:
	gpg --armor --detach-sig installers/safe-t-bridge*.exe
	gpg --armor --detach-sig installers/*.pkg

deploy:
	echo Copying installers $(VERSION) to storage
	gsutil cp -a public-read installers/*.exe $(BUCKET)/$(VERSION)/
	gsutil cp -a public-read installers/*.pkg $(BUCKET)/$(VERSION)/
	gsutil cp -a public-read installers/*i386* $(BUCKET)/$(VERSION)/
	gsutil cp -a public-read installers/*x86_64* $(BUCKET)/$(VERSION)/
	gsutil cp -a public-read installers/*amd64* $(BUCKET)/$(VERSION)/
	echo Updating latest_version.txt file
	gsutil cp -a public-read ../VERSION $(BUCKET)/latest_version.txt
