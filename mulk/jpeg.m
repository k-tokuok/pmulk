Jpeg.Reader class
$Id: mulk jpeg.m 1433 2025-06-03 Tue 21:15:38 kt $
#ja

*[man]
**#en
.caption DESCRIPTION
It is a wrapper class of jpeg library and provides a function to read jpeg files.
.hierarchy Jpeg.Reader
.caption SEE ALSO
.summary view
**#ja
.caption 説明
jpegライブラリのラッパークラスで、jpegファイルを読み込む機能を提供する。
.hierarchy Jpeg.Reader
.caption 関連項目
.summary view

*import.@
	Mulk import: #("dl" "view")

*import libjpeg.@
	"libjpeg.so" ->:lib;
	Mulk.hostOS = #windows ifTrue: ["libjpeg-9.dll" ->lib];
	DL import: lib procs:
		#(#jpeg_std_error 1 #jpeg_CreateDecompress 3 #jpeg_mem_src 3
		#jpeg_read_header 2 #jpeg_start_decompress 1 #jpeg_read_scanlines 3
		#jpeg_finish_decompress 1 #jpeg_destroy_decompress 1)

*Jpeg.Decompress class.@
	DL.Struct addSubclass: #Jpeg.Decompress
**Jpeg.Decompress >> version
	Mulk.hostOS = #windows ifTrue: [90!];
	Mulk.hostOS = #linux ifTrue: [62!];
	0!
**Jpeg.Decompress >> init
	super init;
	DL.ptrByteSize = 4 ifTrue: [456] ifFalse: [632] ->:size;
	self init: size;

	FixedByteArray basicNew:
		(DL.ptrByteSize = 4 ifTrue: [132] ifFalse: [168]) ->:err;
	nc addChunk: err;
	self at: 0 put: (DL call: #jpeg_std_error with: err);

	DL call: #jpeg_CreateDecompress with: self with: self version 
		with: buffer size
**Jpeg.Decompress >> width
	buffer i32At: (DL.ptrByteSize = 4 ifTrue: [28] ifFalse: [48])!
**Jpeg.Decompress >> height
	buffer i32At: (DL.ptrByteSize = 4 ifTrue: [32] ifFalse: [52])!
**Jpeg.Decompress >> destroy
	DL call: #jpeg_destroy_decompress with: self

*Jpeg.Reader class.@
	Object addSubclass: #Jpeg.Reader
**Jpeg.Reader >> readImage: jpegFile
	Jpeg.Decompress new ->:dinfo;
	jpegFile contentBytes ->:buf;
	DL call: #jpeg_mem_src with: dinfo with: buf address with: buf size;

	DL call: #jpeg_read_header with: dinfo with: 1;
	dinfo width ->:w;
	dinfo height ->:h;

	w * 3 ->:row;
	FixedByteArray basicNew: row * h ->:dbuf;
	dbuf address ->:adr;
	DL.IntPtrBuffer new ->:arg;

	DL call: #jpeg_start_decompress with: dinfo;
	h timesDo:
		[:y
		arg value: adr;
		DL call: #jpeg_read_scanlines with: dinfo with: arg with: 1;
		adr + row ->adr];

	DL call: #jpeg_finish_decompress with: dinfo;
	dinfo destroy;

	View.Image new initWidth: w height: h buffer: dbuf!
***[man.m]
****#en
Read the File jpegFile and return an instance of View.Image.
****#ja
File jpegFileを読み込み、View.Imageのインスタンスを返す。
