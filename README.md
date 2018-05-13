## cmakeの準備
brew install cmake

## Dlibの準備
https://github.com/davisking/dlib

1. ダウンロード  
https://github.com/davisking/dlib/archive/v19.10.zip

2. ターミナル  
$ cd /パス/dlib-19.10/examples  
$ mkdir build  
$ cd build  
$ cmake -G Xcode ..  
$ cmake --build . --config Release