Google Drive
$Id: mulk gdrive.m 1197 2024-03-31 Sun 21:48:00 kt $
#ja Googleドライブ

*[man]
**#en
.caption SYNOPSIS
	gdrive.init CLIENT_ID CLIENT_SECRET
	gdrive.login [loopback]
	gdrive.mount
.caption DESCRIPTION
Provides a framework for mounting Google Drive to /gdrive, /gdriveb and handling it in the same way as local files.

Files under /gdrive are converted to Unix format on Google Drive.
Files under /gdriveb are treated as binary files.

.caption init
Initialize.

Run an application that supports Google Drive API and authentication on the Google Cloud Platform in advance, and register its CLIENT_ID and CLIENT_SECRET.

.caption login
Perform login processing.

If there is no argument, perform device authentication.
After the user_code and url are displayed, choose to open the browser manually or automatically.
After completing the authorization on the browser, return to Mulk and complete the command to access.

Specifying "loopback" as an argument performs loopback authentication.
This does not require input of user_code, but in order to receive the authentication code by loopback redirection, it is necessary to install the external program oauthlr in a directory in the PATH.
oauthlr is in the mulk source package.

.caption mount
Mount Google Drive.

**#ja
.caption 書式
	gdrive.init CLIENT_ID CLIENT_SECRET
	gdrive.login [loopback]
	gdrive.mount
.caption 説明
Googleドライブを/gdrive, /gdrivebにマウントし、ローカルなファイルと同様に扱う枠組みを提供する。
	
/gdrive下のファイルはGoogleドライブ上ではUnix形式に変換される。
/gdriveb下のファイルはバイナリファイルとして扱う。

.caption init
初期化を行う。

事前にGoogle Cloud PlatformでGoogle Drive APIと認証に対応したアプリケーションを動作させておき、そのCLIENT_IDとCLIENT_SECRETを登録する。

.caption login
ログイン処理を行う。

引数がない場合デバイス認証を行う。
user_codeとurlが表示された後、ブラウザを手動もしくは自動で開くかを選択する。
ブラウザ上での承認完了後Mulkに戻ってコマンドを完了させることでアクセス可能となる。

引数として"loopback"を指定するとloopback認証を行う。
これはuser_codeの入力を必要としないが、loopback redirectionで認証コードを受け取るために、外部プログラムoauthlrをPATHの通ったディレクトリにインストールしておく必要がある。
oauthlrはmulkのソースパッケージにある。

.caption mount
Googleドライブをマウントする。

*import.@
	Mulk import: #("hrlib" "jsonrd" "jsonwr" "pi" "prompt" "pfs")
	
*forward definition.
**GDrive.File class.@
	PseudoFile addSubclass: #GDrive.File instanceVars: "id"
**GDrive.TextFile class.@
	GDrive.File addSubclass: #GDrive.TextFile
	
*GDrive.class class.@
	Object addSubclass: #GDrive.class instanceVars: "settings hr"
**GDrive.class >> settingsFile
	"gdrive.mpi" asWorkFile!
**GDrive.class >> save
	self settingsFile writeObject: settings
**GDrive.class >> load
	self settingsFile readableFile? 
		ifFalse: [self error: "missing gdrive.mpi"];
	self settingsFile readObject ->settings

**GDrive.class >> cmd.init: args
	Dictionary new ->settings;
	settings at: #client_id put: args first;
	settings at: #client_secret put: (args at: 1);
	settings at: #refresh_token put: nil;
	settings at: #access_token put: nil;
	settings at: #expiration put: 0;
	self save
	
**GDrive.class >> createHr
	HttpRequestFactory new create ->hr
**GDrive.class >> runJson
	TempFile create ->:outFile;
	hr outFile: outFile;
	hr run = 0 ifTrue: [nil!];
	outFile readDo: [:fs JsonReader new init: fs, read ->:result];
	outFile remove;
	result!
	
**GDrive.class >> cmd.deviceLogin: args
	self load;
	--for reduced input device.
	"https://www.googleapis.com/auth/drive.file" ->:scope;
	self createHr;
	hr url: "https://oauth2.googleapis.com/device/code";
	hr openData;
	hr param: "client_id" value: (settings at: #client_id);
	hr param: "scope" value: scope;
	self runJson ->:json;
	
	Out putLn: "user_code " + (json at: "user_code");
	json at: "verification_url" ->:url;
	Out putLn: "url " + url;
	Prompt getBoolean: "open browser automatically", ifTrue:
		["open " + url, runCmd];
	
	Prompt getString: "verification complete to press enter";
	
	self createHr;
	hr url: "https://oauth2.googleapis.com/token";
	hr header: "Content-Type" value: "application/x-www-form-urlencoded";
	hr openData;
	hr param: "client_id" value: (settings at: #client_id);
	hr param: "client_secret" value: (settings at: #client_secret);
	hr param: "device_code" value: (json at: "device_code");
	hr param: "grant_type" 
		value: "urn%3Aietf%3Aparams%3Aoauth%3Agrant-type%3Adevice_code";
	self runJson ->json;
	settings at: #refresh_token put: (json at: "refresh_token");
	self save
	
**GDrive.class >> cmd.loopbackLogin: args
	self load;
	"https://www.googleapis.com/auth/drive.file" ->:scope;
	"http://localhost:8000" ->:redirect_uri;
	"open "
		+ "https://accounts.google.com/o/oauth2/v2/auth?response_type=code"
		+ "&client_id=" + (settings at: #client_id)
		+ "&redirect_uri=" + redirect_uri 
		+ "&scope=" + scope 
		+ "&access_type=offline", runCmd;
	"os oauthlr 8000 | grep GET" pipe getLn ->:s;
	s indexOf: '=' ->:eqpos;
	s indexOf: '&' ->:ampos;
	s copyFrom: eqpos + 1 until: ampos ->:authorization_code;

	self createHr;
	hr url: "https://www.googleapis.com/oauth2/v4/token";
	hr openData;
	hr param: "code" value: authorization_code;
	hr param: "client_id" value: (settings at: #client_id);
	hr param: "client_secret" value: (settings at: #client_secret);
	hr param: "redirect_uri" value: redirect_uri;
	hr param: "grant_type" value: "authorization_code";
	hr param: "access_type" value: "offline";
	self runJson ->:json;
	settings at: #refresh_token put: (json at: "refresh_token");
	self save

**GDrive.class >> prepareAccessToken
	OS time ->:now;
	settings at: #access_token, nil? or: [(settings at: #expiration) < now],
		ifTrue:
			[self createHr;
			hr url: "https://www.googleapis.com/oauth2/v4/token";
			hr openData;
			hr param: "refresh_token" value: (settings at: #refresh_token);
			hr param: "client_id" value: (settings at: #client_id);
			hr param: "client_secret" value: (settings at: #client_secret);
			hr param: "grant_type" value: "refresh_token";
			self runJson at: "access_token" ->:access_token;
			settings at: #access_token put: access_token;
			settings at: #expiration put: now + 3600 - 180;
			self save]
**GDrive.class >> setAuthorization
	hr header: "Authorization" value: "Bearer " + (settings at: #access_token)
**GDrive.class >> get: idArg
	self prepareAccessToken;
	self createHr;
	"https://www.googleapis.com/drive/v3/files/" + idArg
		+ "?fields=name,id,modifiedTime,size,mimeType,parents" ->:url;
	hr url: url;
	self setAuthorization;
	self runJson!
**GDrive.class >> delete: idArg
	self prepareAccessToken;
	self createHr;
	hr method: "DELETE";
	hr url: "https://www.googleapis.com/drive/v3/files/" + idArg;
	self setAuthorization;
	hr run
**GDrive.class >> makeFolder: nameArg parent: idArg
	self prepareAccessToken;
	self createHr;
	hr url: "https://www.googleapis.com/drive/v3/files";
	hr method: "POST";
	self setAuthorization;
	hr header: "Content-Type" value: "application/json";
	hr openData;
	Dictionary new ->:metadata;
	metadata at: "name" put: nameArg;
	metadata at: "mimeType" put: "application/vnd.google-apps.folder";
	metadata at: "parents" put: (Array new addLast: idArg);
	JsonWriter new init: hr data, put: metadata;
	self runJson!
**GDrive.class >> files: idArg
	self prepareAccessToken;
	nil ->:nextPageToken;
	Array new ->:result;
	[
		self createHr;
		"https://www.googleapis.com/drive/v3/files"
			+ "?fields=nextPageToken,files(name,id,modifiedTime,size,mimeType)"
			+ "&q=%27" + idArg + "%27+in+parents" ->:url;
		nextPageToken notNil? ifTrue:
			[url + "&pageToken=" + nextPageToken ->url];
		hr url: url;
		self setAuthorization;
		self runJson ->:json;
		result addAll: (json at: "files");
		json at: "nextPageToken" ifAbsent: [nil] ->nextPageToken, nil?
	] whileFalse;
	result!
**GDrive.class >> file: nameArg parent: parentIdArg
	self prepareAccessToken;
	self createHr;
	"https://www.googleapis.com/drive/v3/files"
		+ "?fields=files(name,id,modifiedTime,size,mimeType)"
		+ "&q=%27" + parentIdArg + "%27+in+parents+and+name%3d%27" + nameArg
			+ "%27" ->:url;
	hr url: url;
	self setAuthorization;
	self runJson!
**GDrive.class >> getBytes: idArg
	self prepareAccessToken;
	TempFile create ->:f;
	self createHr;
	hr url: "https://www.googleapis.com/drive/v3/files/" + idArg 
		+ "?alt=media";
	hr outFile: f;
	self setAuthorization;
	hr run;
	f resetStat;
	f contentBytes ->:result;
	f remove;
	result!
**GDrive.class >> putBytes: bytesArg file: fileArg
	fileArg kindOf?: GDrive.TextFile, 
		ifTrue: ["text/plain"]
		ifFalse: ["application/octed-stream"] ->:mimeType;
	self prepareAccessToken;
	self createHr;
	hr url: 
	"https://www.googleapis.com/upload/drive/v3/files?uploadType=multipart";
	hr method: "POST";
	self setAuthorization;
	hr header: "Context-Type" value: "multipart/related";
	hr openMultipart;
	
	hr putBoundary;
	hr putLn: "Content-Disposition: form-data; name=\"metadata\"";
	hr putLn: "Content-Type: application/json;charset=UTF-8";
	hr putLn;
	Dictionary new ->:metadata;
	metadata at: "name" put: fileArg name;
	metadata at: "mimeType" put: mimeType;
	metadata at: "parents" put: (Array new addLast: fileArg parent id);
	JsonWriter new init: hr data, put: metadata;
	hr putLn;
	
	hr putBoundary;
	hr putLn: "Content-Disposition: form-data; name=\"file\"";
	hr putLn: "Content-Type: " + mimeType;
	hr putLn;
	hr data write: bytesArg;
	hr putLn;
	hr putBoundary;
		
	self runJson
**GDrive.class >> cmd.mount: args
	self load;
	settings at: #refresh_token, nil? ifTrue: [self error: "require login"];
	File.mount
		at: "gdrive" put: GDrive.TextFile,
		at: "gdriveb" put: GDrive.File
**resident.@
	Mulk addGlobalVar: #GDrive, set: GDrive.class new
	
*GDrive.Stream class.@
	PseudoFileStream addSubclass: #GDrive.Stream
**GDrive.Stream >> readFileBytes
	GDrive getBytes: file id ->buf;
	buf size ->size
**GDrive.Stream >> init: fileArg mode: modeArg
	fileArg ->file;
	modeArg = 1 ->update?;
	modeArg <> 1 & fileArg file? ifTrue:
		[self readFileBytes;
		modeArg = 2 ifTrue: [size] ifFalse: [0] ->pos];
	buf nil? ifTrue: [self initEmpty]
**GDrive.Stream >> writeFileBytes
	self seek: 0;
	GDrive putBytes: self contentBytes file: file
**GDrive.Stream >> close
	update? ifTrue: 
		[file none? ifFalse: [file remove];
		self writeFileBytes;
		file resetStat]

*Mulk.hostOS = #windows >
**GDrive.TextStream class.@
	GDrive.Stream addSubclass: #GDrive.TextStream,
		features: #(NewlineCrlfStream)
***GDrive.TextStream >> readFileBytes
	MemoryStream new write: (GDrive getBytes: file id), seek: 0 ->:rd;
	self initEmpty;
	rd pipe: "ctr u =" to: self;
	false ->update?
***GDrive.TextStream >> writeFileBytes
	self seek: 0;
	MemoryStream new ->:wr;
	self pipe: "ctr u" to: wr;
	wr seek: 0;
	GDrive putBytes: wr contentBytes file: file
	
*GDrive.File class.
**GDrive.File >> initParent: parentArg name: nameArg
	super initParent: parentArg name: nameArg;
	parentArg root? ifTrue:
		["root" ->id;
		4 ->mode]
**GDrive.File >> json: jsonArg
	jsonArg at: "mimeType", = "application/vnd.google-apps.folder",
		ifTrue: [4] ifFalse: [2 + 16 + 32] ->mode;
	jsonArg at: "size" ifAbsent: ["0"], asInteger ->size;
	jsonArg includesKey?: "modifiedTime",
		ifTrue: 
			[jsonArg at: "modifiedTime" ->:str;
			DateAndTime new 
				initUtcYear: (str copyFrom: 0 until: 4) asInteger
				month: (str copyFrom: 5 until: 7) asInteger
				day: (str copyFrom: 8 until: 10) asInteger
				hour: (str copyFrom: 11 until: 13) asInteger
				minute: (str copyFrom: 14 until: 16) asInteger
				second: (str copyFrom: 17 until: 19) asInteger]
		ifFalse: [0] ->mtime;
	jsonArg at: "id" ->id
**GDrive.File >> id
	--if id = nil?
	id!
	
**File compatible.
***GDrive.File >> resetStat
	super resetStat;
	nil ->id
***GDrive.File >> stat
	--Out putLn: "stat " + self + " parent id = " + parent id;
	parent none? ifTrue: [1 ->mode!];
	GDrive file: name parent: parent id, at: "files" ->:jsons;
	jsons empty? 
		ifTrue: [1 ->mode]
		ifFalse: [self json: jsons first]
***GDrive.File >> basicRemove
	GDrive delete: id
***GDrive.File >> basicMkdir
	--Out putLn: "basicMkdir " + self + " parent id = " + parent id;
	self json: (GDrive makeFolder: name parent: parent id)
***GDrive.File >> mkdir
	self directory? ifTrue: [self!];
	self none? ifTrue:
		[parent mkdir;
		self basicMkdir!];
	self error: "mkdir failed"
***GDrive.File >> childFiles
	self assert: self directory?;
	Iterator new init:
		[:b 
		GDrive files: id, do:
			[:json
			self class new initParent: self name: (json at: "name"),
				json: json ->:f;
			b value: f]]!
***GDrive.File >> streamClass
	GDrive.Stream!
***GDrive.File >> openMode: modeArg
	modeArg = 0 ifTrue: [self file?] ifFalse: [self file? | self none?],
		ifFalse: [self openError: modeArg];
	self streamClass new init: self mode: modeArg ->:result;
	--resetstat
	result!

*GDrive.TextFile class.
**Mulk.hostOS = #windows >
***GDrive.TextFile >> streamClass
	GDrive.TextStream!
	
*tool.@
	Object addSubclass: #Cmd.gdrive
**Cmd.gdrive >> main.init: args
	GDrive cmd.init: args
**Cmd.gdrive >> main.login: args
	args empty? ifTrue: [GDrive cmd.deviceLogin: args!];
	args first = "loopback", ifTrue: [GDrive cmd.loopbackLogin: args!];
	Out putLn: "unknown login"
**Cmd.gdrive >> main.mount: args
	[GDrive cmd.mount: args] on: Error do:
		[:e Out putLn: e message]
