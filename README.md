## Info
This tool designed to process build automatically
It can be used for every device.


## Usage

```
bash build.sh <device> <branch> <extra>
```

- <device> : Type your devices codename. Example : bash build.sh ugglite <branch> <extra>

- <branch> : Type desired OS version. Example : bash build.sh <device> cm-14.1 <extra>

- <extra> : This is optional. You can do 4 different process with this option.

You can build:
boot
recovery
module

or you may wanna do a clean up. For this run with "clean" command

boot -> Compiles boot.img
recovery -> Compiles recovery.img
module -> Youcan build every single particular module. Like "libart" - "SystemUI.apk" or any other file.
clean -> This command cleans up the output folders.


## Example
```
bash build.sh ugglite cm-14.1 boot
```


OR


```
bash build.sh clean
```
