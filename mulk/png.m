Png.Reader class
$Id: mulk png.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
Provide a function to read a png file in the wrapper class of png library.
.hierarchy Png.Reader
.caption SEE ALSO
.summary view
**#ja
.caption 説明
pngライブラリのラッパークラスで、pngファイルを読み込む機能を提供する。
.hierarchy Png.Reader
.caption 関連項目
.summary view

*import.@
	Mulk import: #("dl" "view")

*import libpng16.dll.@
	"libpng.so" ->:lib;
	Mulk.hostOS = #windows ifTrue: ["libpng16.dll" ->lib];
	Mulk.hostOS = #cygwin ifTrue: ["cygpng16-16.dll" ->lib];
	DL import: lib procs:
		#(#png_image_begin_read_from_file 2 #png_image_finish_read 5)

*Png.Image class.@
	DL.Buffer addSubclass: #Png.Image
**Png.Image >> init
	self init: (DL.ptrByteSize = 4 ifTrue: [96] ifFalse: [104]);
	buffer fill: 0;
	buffer i32At: (DL.ptrByteSize = 4 ifTrue: [4] ifFalse: [8])
		put: 1 -- PNG_VERSION
**Png.Image >> width
	buffer i32At: (DL.ptrByteSize = 4 ifTrue: [8] ifFalse: [12])!
**Png.Image >> height
	buffer i32At: (DL.ptrByteSize = 4 ifTrue: [12] ifFalse: [16])!
**Png.Image >> setRgbFormat
	buffer i32At: (DL.ptrByteSize = 4 ifTrue: [16] ifFalse: [20])
		put: 2 -- format=PNG_FORMAT_RGB

*Png.Reader class.@
	Object addSubclass: #Png.Reader

**Png.Reader >> readImage: pngFile
	Png.Image new ->:image;
	DL call: #png_image_begin_read_from_file with: image with: pngFile hostPath
		->:st;
	self assert: st <> 0;
	FixedByteArray basicNew: image width * image height * 3 ->:buf;
	image setRgbFormat;	
	DL call: #png_image_finish_read with: image with: 0 with: buf with: #(0 0)
		->st;
	self assert: st <> 0;
	View.Image new initWidth: image width height: image height buffer: buf!
***[man.m]
****#en
Read the File pngFile and return an instance of View.Image.
****#ja
File pngFileを読み込み、View.Imageのインスタンスを返す。
