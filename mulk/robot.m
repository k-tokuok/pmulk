run away from robots
$Id: mulk robot.m 1630 2026-08-08 Sat 22:02:48 kt $
#ja ロボットから逃げ回れ

*[man]
**#en
.caption SYNOPSIS
	robot
.caption DESCRIPTION
Keep running around so that you [@] don't get caught by the robots [+].
The robots move straight toward you, but if they collide with each other or hit debris [*], they'll break and turn into debris.

Clear the level by destroying all the robots.

You can move in eight directions centered on [s,5]. 
Press [s,5] to stay in place.

  [q,7][w,8][e,9]
  [a,4][s,5][d,6]
  [z,1][x,2][c,3]
|
  [ ,En] Stop moving -- Remains in place until the level is cleared.
  [j,0] Jump -- Moves two spaces in the direction of the next movement key pressed.
  [t,.] Teleport -- Teleports to a random location on the screen.
.caption LIMITATION
This program runs only under a console with screen control capabilities.
.caption SEE ALSO
.summary sconsole
**#ja
.caption 書式
	robot
.caption 説明
あなた[@]がロボット[+]に捕まらないよう、逃げ回って下さい。
ロボットはあなたに向かって一直線に進んできますが、ロボット同士がぶつかるか、瓦礫
[*]にぶつかると壊れて瓦礫になります。

全てのロボットを壊せば一面クリアです。

[s,5]を中心に8方向へ動けます。[s,5]でその場に留まります。

  [q,7][w,8][e,9]
  [a,4][s,5][d,6]
  [z,1][x,2][c,3]
|
  [ ,En] 移動終了 -- 面クリアまでその場に留まります。
  [j,0] ジャンプ -- 次に押した移動方向へ2コマ進みます。
  [t,.] テレポート -- 画面内の何処かにテレポートします。
.caption 制限事項
画面制御機能を有したConsole下でのみ動作可。
.caption 関連項目
.summary sconsole

*robot game.@
	Mulk import: #("console" "random" "pi" "point");
	Object addSubclass: #Cmd.robot
		instanceVars:
			"width height vector hiScore"
			+ " robots ruins man score scoreDelta jump? wait?"
**Cmd.robot >> init
	Console width min: 80 ->width;
	Console height - 1 min: 24 ->height;
	Array new
		addLast: -1 @ -1, addLast: 0 @ -1, addLast: 1 @ -1,
		addLast: -1 @ 0, addLast: 0 @ 0, addLast: 1 @ 0,
		addLast: -1 @ 1, addLast: 0 @ 1, addLast: 1 @ 1 ->vector
**Cmd.robot >> createPoint
	[(Random until: width) @ (Random until: height) ->:point;
	robots includes?: point] whileTrue;
	point!
**Cmd.robot >> print: ch at: point
	Console gotoX: point x Y: point y, put: ch
**Cmd.robot >> printScore
	"Score: " + score + " HiScore: " + hiScore + ' ' ->:s;
	Console gotoX: 0 Y: height, put: s;
	width - 1 - s size timesRepeat: [Console put: '-']
**Cmd.robot >> score
	score + scoreDelta ->score;
	scoreDelta + 1 ->scoreDelta;
	self printScore
**Cmd.robot >> initGame: nRobot
	Console clear;
	Console width <> width ifTrue:
		[height timesDo: 
			[:y
			Console gotoX: width Y: y, put: '|']];
	false ->wait?;
	self printScore;
	Ring new ->robots;
	Ring new ->ruins;
	nRobot timesRepeat:
		[self createPoint ->:p;
		robots addLast: p;
		self print: '+' at: p];
	self createPoint ->man;
	self print: '@' at: man
**Cmd.robot >> keyIn
	false ->jump?;
	[Console fetch ->:key;
	"q7w8e9a4s5d6z1x2c3t. \rj0" indexOf: key ->:code;
	code notNil? ifTrue:
		[code // 2 ->code;
		code = 10 ifTrue:
			[true ->wait?;
			4 ->code];
		code = 11 ifTrue:
			[true ->jump?;
			nil ->code]];
	code nil?] whileTrue;
	code!
**Cmd.robot >> turn
	wait?
		ifTrue: [4 ->:code]
		ifFalse:
			[1 ->scoreDelta;
			self keyIn ->code];

	self print: ' ' at: man;
	code between: 0 and: 8,
		ifTrue:
			[man + (vector at: code) ->:nextMan;
			jump? ifTrue: [nextMan + (vector at: code) ->nextMan]]
		ifFalse:
			[self createPoint ->nextMan];
	nextMan x between: 0 until: width,
		and: [nextMan y between: 0 until: height],
		and: [ruins includes?: nextMan, not],
		ifTrue: [nextMan ->man];
	self print: '@' at: man;

	Ring new ->:nextRobots;
	robots do:
		[:r
		nextRobots includes?: r, not and: [ruins includes?: r, not], ifTrue:
			[self print: ' ' at: r];
		r + ((man x compareTo: r x) @ (man y compareTo: r y)) ->r;

		r = man ifTrue:
			[self print: "XUaaaaahhhhh!" at: man;
			nil ->man;
			self!];

		ruins includes?: r, ifTrue:
			[self score;
			nil ->r];

		nextRobots nodeOf: r ->:rpos, notNil? ifTrue:
			[ruins addLast: r;
			self print: '*' at: r;
			rpos remove;
			self score;
			self score;
			nil ->r];

		r notNil? ifTrue:
			[self print: '+' at: r;
			nextRobots addLast: r]];
	nextRobots ->robots
**Cmd.robot >> game: level
	self initGame: 10 * level + 10;
	[self turn;
	robots empty? ifTrue: [true!];
	man nil? ifTrue:
		[self printScore;
		score > hiScore ifTrue:
			[score ->hiScore;
			Console put: " -Congratulations! You update hi score."];
		Console putLn;
		false!]] loop
**Cmd.robot >> main: args
	"robot.mpi" asWorkFile ->:file;
	file none?
		ifTrue: [0]
		ifFalse: [file readObject] ->hiScore;
	0 ->:level;
	0 ->score;
	[self game: level] whileTrue: [level + 1 ->level];
	file writeObject: hiScore
