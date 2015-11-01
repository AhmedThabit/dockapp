# dockapp
Application with a dynamic choice of docker containers to run .

The goal is to make the whole application as dynamic as possible (and
share images as much as possible).

## Getting Started:

1. `setup.sh`: Pull or build necessary starting images.
    Most of our images are currently available via a different tag in malex984/dockapp repository 
    (https://registry.hub.docker.com/u/malex984/dockapp/).
    Since some of them are quite big please do consider building them instead of pulling!
    Run (and change) `setup.sh` in order to pull the base image and build starting images.
    *We assume the host linux to run docker service.*
2. We are experimenting with different customization approaches:
  * `:dummy` contains `customize.sh` which performs customization to the running :dummy container, 
    these customization changes can than be detected with `docker diff` and 
    archived together (e.g. `/tmp/OGL.tgz`) for later use by `:base/setup_ogl.sh`.
  * (*obsolete*) `:up/customize.sh`: Customize each libGL-needing image (e.g. `:x11` and `:test` by default for now):
    Running `:up/customize.sh` such a host will enable one to detect known hardware or kernel modules (e.g. VirtualBox Guest Additions or NVidia driver)
    in order to localize/customize some starting images  
    under corresponding tag name (e.g. `:test.nv.340.76` or `:x11.vb.4.3.26`),
    which than will be tagged with local names (e.g. `test:latest` or `x11:latest`). 
    *We assume host system to be fully pre-configured (and all necessary kernel modules installed and loaded).*
    Therefore we avoid installing/building kernel modules inside docker container (e.g. using `dkms`).
3. `runme.sh`: Launch this dockapp application.
    The shell script `runme.sh` is supposed to be the dockapp's entry point.
    Using host docker it runs `main` (or its alteration if available) image,
    which contains a glue-together script `main.sh` that 
    now overtakes the control (!) over the host system (docker service and `/dev`).    
    Note that `main.sh` (and its helpers, e.g. `run.sh` ad `sv.sh`) is the only piece which is supposed to be aware of docker!
    The glue gives proposes a choice menu (e.g. via `:menu/menu.sh`), which exits with some return code, 
    depending on which the glue script takes some action or quits the main infinite loop.
4. Choose `X11Server` if your host was not running X11 server in order to witch the host monitor into graphical mode.
    NOTE: please don't do that while using the host monitor in text mode since at the moment 
    `menu.sh` is only suitable for console/text mode (but we are working on a GUI alternative). Better to do that via SSH.
5. Now assuming a running X11 (on host or inside a docker container) one can choose any application to run (e.g. `Test`) or Quit.


## The sequence of actions 3..5 looks approximately as follows:

![Approximate Sequence Diagram](http://www.websequencediagrams.com/cgi-bin/cdraw?lz=dGl0bGUgRHluYW1pYyBEb2NrZXIgQXBwbGljYXRpb24KCnBhcnRpY2lwYW50IEhvc3QKbm90ZSBvdmVyAAoFOiAKSG9zdCBMaW51eCB3aXRoAD8HCmVuZCBub3RlCgoAHQUtPisAKgYuL3J1bm1lLnNoCgBQDiI6TWFpbiIAJgkACQc6IDptYWluL21haW4AMAVsb29wIHRoZSBtYWluIGdsdWUgAA4FcnVuIHVudGlsIFF1aXQASxFlbnUiCgoAXgcAWQZlbnUAWgVlbnUvbWVudS5zaAoAIwctLT4tAHgJY2hvc2VuIEFwcC9TZXJ2aWNlIG9yAGAGZGVzdHJveQBXCmFsdCBQdWxsL1J1biBkZWFtb24gOgAvBwCBYBAARgciAIEMCgAKCgCBbwhzdgCBEAYAJAgAghQFABsKZXhlYyAAVgllbHNlAHQKYW5kIEQAgRkHOkFwcEEAgmAQQXBwQQBwDQAMBQCCaQhydQCCawUAIAcAgwwFABkHAHAFAEwFABUIAIIiDGV4aXQgY29kZSAAghMLAGUGAIEbBgCDGQYAgwIILT4tAIRDBgAvCQCCSQwAhAwGZW5kCgplbmQKCgoKCgoK&s=modern-blue)

## Currently we provide the following images:

* [![](https://badge.imagelayers.io/malex984/dockapp:base.svg)](https://imagelayers.io/?images=malex984/dockapp:base'Get your own badge on imagelayers.io')
`:base` serves as the common root for all our images. Thus it is the only image that will update & upgrade all the packages.
* [![](https://badge.imagelayers.io/malex984/dockapp:dd.svg)](https://imagelayers.io/?images=malex984/dockapp:dd'Get your own badge on imagelayers.io')
`:dd` contains the docker cli and thus serves as a basis for `:main` which in turn pulls and launches further images.
* [![](https://badge.imagelayers.io/malex984/dockapp:appchoo.svg)](https://imagelayers.io/?images=malex984/dockapp:appchoo'Get your own badge on imagelayers.io')
`:appchoo` image is a crude shell menu asking the user to choose an option and returns the choice via the return code (201, 202, 203 etc... ).
Depending on `MENU_TRY` it can be either GUI or TEXT style.
* [![](https://badge.imagelayers.io/malex984/dockapp:appa.svg)](https://imagelayers.io/?images=malex984/dockapp:appa'Get your own badge on imagelayers.io')
`:appa` image run simple shell scripts saying AAA... or BBB... together with some host data.
* [![](https://badge.imagelayers.io/malex984/dockapp:alsa.svg)](https://imagelayers.io/?images=malex984/dockapp:alsa'Get your own badge on imagelayers.io')
`:alsa` tests your audio HW using ALSA
* [![](https://badge.imagelayers.io/malex984/dockapp:xeyes.svg)](https://imagelayers.io/?images=malex984/dockapp:xeyes'Get your own badge on imagelayers.io')
`:xeyes` is an image with some X11 client applications (e.g. `xeyes`).
* [![](https://badge.imagelayers.io/malex984/dockapp:gui.svg)](https://imagelayers.io/?images=malex984/dockapp:gui'Get your own badge on imagelayers.io')
`:gui` contains further GUI applications based on GTK and QT. 
* [![](https://badge.imagelayers.io/malex984/dockapp:q3.svg)](https://imagelayers.io/?images=malex984/dockapp:q3'Get your own badge on imagelayers.io')
`:q3` is a standalone (huge!) image with OpenArena (free version of Quake 3 Arena) which works but FPS was a bit low for me :( ALSA sound was good!
* [![](https://badge.imagelayers.io/malex984/dockapp:skype.svg)](https://imagelayers.io/?images=malex984/dockapp:skype'Get your own badge on imagelayers.io')
`:skype` propriatory 32-bit application runs using apulse (emulation of pulseaudio via ALSA), it may also be able to capture video if you are lucky with your camera, its drivers and settings... It starts fine with working sound input/output but may refuse working after a while... :(
* [![](https://badge.imagelayers.io/malex984/dockapp:play.svg)](https://imagelayers.io/?images=malex984/dockapp:play'Get your own badge on imagelayers.io')
`:play` contains several media players like `cmus`, `vlc`, `mplayer`, `xine`.
* [![](https://badge.imagelayers.io/malex984/dockapp:test.svg)](https://imagelayers.io/?images=malex984/dockapp:test'Get your own badge on imagelayers.io')
`:test` for testing HW & GPU and applications that need it
* [![](https://badge.imagelayers.io/malex984/dockapp:webbase.svg)](https://imagelayers.io/?images=malex984/dockapp:webbase'Get your own badge on imagelayers.io')
`:webbase` serves as the common base for all web-browser-related images (hopefully with dbus and multi-touch support).
* [![](https://badge.imagelayers.io/malex984/dockapp:demo.svg)](https://imagelayers.io/?images=malex984/dockapp:demo'Get your own badge on imagelayers.io')
`:demo` provides a choice menu and with luncher of GUI-exhibits
* [![](https://badge.imagelayers.io/malex984/dockapp:kivy.svg)](https://imagelayers.io/?images=malex984/dockapp:kivy'Get your own badge on imagelayers.io')
`:kivy` serves as the common base for all kivy-related images. 
* [![](https://badge.imagelayers.io/malex984/dockapp:iceweasel.svg)](https://imagelayers.io/?images=malex984/dockapp:iceweasel'Get your own badge on imagelayers.io')
`:iceweasel` Firefox & Iceweasel
* [![](https://badge.imagelayers.io/malex984/dockapp:chrome.svg)](https://imagelayers.io/?images=malex984/dockapp:chrome'Get your own badge on imagelayers.io')
`:chrome` Google Chrome
* [![](https://badge.imagelayers.io/malex984/dockapp:kiosk.svg)](https://imagelayers.io/?images=malex984/dockapp:kiosk'Get your own badge on imagelayers.io')
`:kiosk` Kiosk-mode web-wrowser using Electron based on Chromium

### Services:

Some applications may need further deamons to run in background. Here is a list of server images:

* [![](https://badge.imagelayers.io/malex984/dockapp:x11.svg)](https://imagelayers.io/?images=malex984/dockapp:x11'Get your own badge on imagelayers.io')
`:x11` is a basis for Xorg/Xephyr service
* [![](https://badge.imagelayers.io/malex984/dockapp:dummy.svg)](https://imagelayers.io/?images=malex984/dockapp:dummy'Get your own badge on imagelayers.io')
`:dummy` is used for running X11 and HW customization for GPU (OpenGL-library)
* [![](https://badge.imagelayers.io/malex984/dockapp:cups.svg)](https://imagelayers.io/?images=malex984/dockapp:cups'Get your own badge on imagelayers.io')
`:cups` is supposed to run CUPS server (:6631) - seems to start but has to be thoughly tested.
* [![](https://badge.imagelayers.io/malex984/dockapp:x11vnc.svg)](https://imagelayers.io/?images=malex984/dockapp:x11vnc'Get your own badge on imagelayers.io')
`:x11vnc` is an `x11vnc` service
* [![](https://badge.imagelayers.io/malex984/dockapp:x11comp.svg)](https://imagelayers.io/?images=malex984/dockapp:x11comp'Get your own badge on imagelayers.io')
`:x11comp` is a service with composing window manager (xcompmgr or compton)
* [![](https://badge.imagelayers.io/malex984/dockapp:ptmx.svg)](https://imagelayers.io/?images=malex984/dockapp:ptmx'Get your own badge on imagelayers.io')
`:ptmx` is a service to try to workarouind the docker problem of permissions to /dev/pts/ptmx
* [![](https://badge.imagelayers.io/malex984/dockapp:omd.svg)](https://imagelayers.io/?images=malex984/dockapp:omd'Get your own badge on imagelayers.io')
`:omd` containes pre-cofigured OMD service instance (**NOTE:** under development). 

## The dependencies between images are as follows: 
![Dependencies between docker images](deps.png)

## TODO List:

### DONE:

* `runme.sh` can use the currently running X11 of the host machine.
* `runme.sh` and `main/*.sh` correctly handle DISPLAY comming from host or from x11/xephyr container
* user can start `xephyr` in order to run our apps in a windowed mode
* 3rd party tools are currently insorporated into `:test`

### Further steps:

* switch to GUI menu (appchoo) in case of available X11
* make use of composite X11 manager (e.g. compton) and qclosebutton
* test printing via cups!
* test under Mac OS X whether the user still can use `xsocat.sh` e.g. in case of  `boot2docker`
  (e.g. following: (https://github.com/docker/docker/issues/8710), and
  makeing sure to fix your firewall, and X11 settings to accept incoming connections)
* make a nice logo for the app (e.g. whales following each other while being driven by BASH :) )



## Problems:

### X11 would not create a new terminal with the following error message:

```
xterm: Error 32, errno 2: No such file or directory
Reason: get_pty: not enough ptys
```

It seems that somebody clears permissions on `/dev/pts/ptmx` in the
course of the docker mounting `/dev` or using it by containers... 

Since this problem happens rarely it may be related to unexpected "docker rm -vf" for a running container with allocated pty.
Also the following may be related: 
* https://github.com/docker/docker/issues/4605
* https://github.com/docker/docker/pull/4656

Quick Fix is `sudo chmod a+rw /dev/pts/ptmx`

NOTE: what about `/dev/ptmx`?


### "operation not supported" error when trying to RUN something during docker image building

According to http://stackoverflow.com/a/29546560 : if your machine had
a kernel update but you didn't restart yet then docker freaks out like
that.


## Docker shortcuts:
### Cleanup dangling images
```
docker rmi $(docker images -f "dangling=true" -q)
```

### Cleanup dockapp-related images:
```
docker images | grep malex984/dockapp | awk ' { print $1 ":" $2 } ' | xargs docker rmi -f 
docker rmi -f x11 test dummy
```

### Cleanup all containers:
```
docker ps -aq | xargs docker rm -fv
```
