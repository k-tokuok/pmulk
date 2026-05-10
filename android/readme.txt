Android version
$Id: mulk/android readme.txt 1594 2026-05-03 Sun 19:40:51 kt $

*Basic Build Procedure
**Prerequisite
The Mulk system for host OS must be built in the ../mulk directory.

**Creating mulka0.zip
In the android directory,

	]cmd build.mc

will create mulka0.zip as an asset.
This consists of a minimal image and the mulka0 package.

**Running from Android Studio
If you open android/Mulk as an Android Studio project, you can run it normally.

**Creating an APK
Prepare a suitable keystore, then create a signed APK using 'build/generate signed bundle/apk...'.

Install it using ADB or a file manager on the device.

*Startup and Operation
When you install and launch the APK, a minimal system is deployed to the application's FilesDir, typically
	/data/user/0/com.github.k_tokuok.mulk/files/mulka0
and the REPL starts up.
From there, you can type using either a physical keyboard or the on-screen keyboard.

**Software screen keyboard
The software keyboard functions as follows:

Top-right blank button (left) -- Toggle between numeric keypad and full keyboard
Top-right blank button (right) -- Display menu

The full keyboard allows you to enter symbols and control characters using flick input.
The key labels are as follows:

	U	L/R
	N	D
	
N -- A character entered by pressing the key.
U -- Swipe up. Omitted for uppercase letters.
D -- Swipe down.
L -- Swipe left. Omitted for control characters (control keys).
R -- Swipe right. Other characters.

Tb -- tab
Sp -- space
Bs -- backspace
En -- enter

**Menu
  	^c -- Send ^c.
  	reset -- Reboot Mulk.
  	prefs... -- Open the settings screen.
  	
**Setting screen
	imageFile -- Specifies the boot image file.
	useKeymap -- Whether to use a keymap file.
 	keymapFile -- The location of the keymap file.
    	A keymap file is required when using special shift modes.
    enableSoftwareKeyboard -- Shows or hides the software keyboard.
	extractMulka0 -- Extract the system from the APK on the next startup and boot from base.mi.

*Production environment
Since mulka0 is basically just capable of running a REPL, you need to set up a separate environment for actual production use.

	>Mulk load: "setupa.m" asSystemFile
	
Then, download the latest release from GitHub and set up an environment like the one shown below.

/data/user/0/com.github.k_tokuok.mulk/files
	mulka0 -- apk builtin system
  	mulk.mi -- image for production use
  	mulk -- Mulk.systemDirectory
  	work -- Mulk.workDirectory
  	h -- home directory
  	
Since mulk.mi (the smallest image required to run the command interpreter) is set as the boot image here, the command interpreter will run starting with the next boot.

*Hints
**mulka0
Even with the mulka0 configuration, you can use a minimal set of tools such as icmd, zip, and gdrive.

You can launch icmd from the REPL with:

	>Mulk at: #Cmd.icmd in: "icmd", new main: #()

**Storage
	]aset.dir
	
Since you can check which directories are available, you can set up your environment on an SD card or under the "Documents" folder.

You can use the "FilesDir" directory freely, but your data will be lost if you uninstall Mulk.

For other directories, depending on your environment, you may need to grant media access permissions via "Settings/Apps/Mulk/Permissions," or you may not be able to access them at all.

**Update or Overwrite Installation
If you perform an overwrite installation, the system will boot from the preconfigured image.
However, if the contents of 'base.m' change significantly or the specifications of the primitives change, the system will no longer function properly.
In this case, check the 'extractMulk0' setting and click "Reset"; this will re-extract 'mulka0', and the system will boot from the 'mulka0' image.

If there is a significant discrepancy between the VM and the boot image, the system may fail to start the GUI and crash.
In that case, go to the "Mulk" section under "Settings/Applications," select "Clear Data," and then reboot.
If you check "extractMulka0" before installing the APK, mulka0 will be extracted when the system boots after installation, allowing you to avoid this situation.
