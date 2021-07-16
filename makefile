make install:
	rm -rf ./bin
	mkdir -p ./bin
	rm -rf ./src/__pycache__
	cd src;  zip -r ../bin/dbproj3.zip ./*
	echo '#!/usr/bin/env python3' | cat - ./bin/dbproj3.zip > ./bin/dbproj3
	rm ./bin/dbproj3.zip
	chmod a+x ./bin/dbproj3
	export PATH=$PATH":$HOME/bin"