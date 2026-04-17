# Vortexcore2026

This section covers any additions to added in 2026 to build the firmware for the Vortex Core.

## Environment

This guide was written on linux, but should also work for Mac, Windows given the needed dependencies (like docker).

If there are compile errors for QMK, you may try using the docker container to build the firmware, you must install docker on your system if you do not have it.

### Windows

I wouldn't recommend using Windows because there are complications getting it working. But if you had to...

Popular choices for building QMK is either through WSL or MSYS2. These aren't the only options for building the firmware on Windows, but, each build setup will lead to their own complications (errors).

For instance, libusb support in WSL (as I understand it) [is poor](https://github.com/microsoft/WSL/issues/2195). This doesn't matter for building the QMK firmware, but it will matter if you try to use the `pok3rtool` program through WSL. WSL will need access to the USB host in order to communicate with the Vortex Core keyboard. I did get this working on Windows at one point, but I believe `pok3rtool` was run through MSYS2 (which also had its own trial and error to get working). Anyway, you've been warned.

## Instructions

Get the source code and build the firmware. Here, I have provided forks with any patches to aid in a success build process.

```sh
# Source code of the firmware (make keymap customizations)
git clone https://github.com/vortexcore2026/qmk_pok3r.git

# For flashing the binary onto the board
git clone --recursive https://github.com/vortexcore2026/pok3rtool
```

## Building

```sh
# If this fails, see docker container build
make vortex/pok3r:default
```

After a successful build, you can start modifying `keyboards/vortex/keymaps/default/keymap.c` with your desired customizations. You may also make your own keymap folder.

Upon completion, the binary file may be in a newly created folder, `.build/.build/vortex_core_default.bin`.

### Docker Container Build: Pinned Toolchain

If your host distro ships a newer `arm-none-eabi-gcc` (for example GCC 14), this repository can fail with warning-as-error and linker incompatibilities.

Use the pinned Docker toolchain instead:

    chmod +x util/build-vortex-core-pinned.sh
    ./util/build-vortex-core-pinned.sh

This uses `Dockerfile.pinned`, which pins Arm GNU Toolchain `7-2018-q2-update` for reproducible builds.

If you make your own keymap folder, then be sure to update `./util/build-vortex-core-pinned.sh` with your keymap.

```sh
# Sample output
# <truncated...>
Creating load file for flashing: .build/vortex_core_default.hex                                     [OK]

Size after:
   text    data     bss     dec     hex filename
  28512    3120   13620   45252    b0c4 ./.build/vortex_core_default.elf

Copying vortex_core_default.bin to qmk_firmware folder                                              [OK]
32672 vortex_core_default.bin
make[1]: Leaving directory '/qmk'
```

## Flashing

Follow the step provided at https://github.com/vortexcore2026/pok3rtool.

Once you have built the `pok3rtool` binary, flashing the built binary can be done like so:

```sh
sudo /path/to/pok3rtool -t vortex-core flash QMK_CORE /path/to/qmk/build/vortex_core_default.bin
```

```sh
# sudo ./pok3rtool -t vortex-core info
WARNING: THIS TOOL IS RELATIVELY UNTESTED, AND HAS A VERY REAL RISK OF CORRUPTING YOUR KEYBOARD, MAKING IT UNUSABLE WITHOUT EXPENSIVE DEVELOPMENT TOOLS. PROCEED AT YOUR OWN RISK.
Type "OK" to continue:
OK
Proceeding...
Opened Vortex Core [QMK]
pid: 175, ver: 1
0: qmk_pok3r
1: 2026-04-17-13:14:54
2: 2026-04-17-13:14:54
true

# sudo ./pok3rtool -t vortex-core flash QMK_CORE /path/to/qmk_pok3r/.build/vortex_core_default.bin
WARNING: THIS TOOL IS RELATIVELY UNTESTED, AND HAS A VERY REAL RISK OF CORRUPTING YOUR KEYBOARD, MAKING IT UNUSABLE WITHOUT EXPENSIVE DEVELOPMENT TOOLS. PROCEED AT YOUR OWN RISK.
Type "OK" to continue:
OK
Proceeding...
Opened Vortex Core [QMK]
Update Firmware: /home/quan/dev/qmk_pok3r/.build/vortex_core_default.bin
Reset to Bootloader
Current Version: QMK_CORE
Firmware CRC D: be4930d4
Firmware CRC E: 1238d7ae
crc 1238d7ae
sum 2c3a8a97
Current CRC: 1238d7ae
Erase...
Write...
crc 1238d7ae
sum 2c3a8a97
New CRC: 1238d7ae
Writing Version: QMK_CORE
Reset to Firmware
true
```

# Quantum Mechanical Keyboard Firmware for POK3R

This repository contains keyboard firmware based on the [qmk\_firmware](http://github.com/qmk/qmk_firmware) project for a number of Holtek MCU-based keyboards. See below for supported and planned keyboards.

## Building

    make vortex/pok3r:default vortex/pok3r_rgb:default vortex/core:default

## Installation

WARNING: This firmware only works on [unlocked](https://github.com/pok3r-custom/pok3r_re_firmware/wiki/HT32-Unlocking) keyboards.
On not-unlocked keyboards, the firmware will hard fault at boot, requiring a JTAG programmer to reprogram.

    ./pok3rtool -t pok3r flash "QMK_POK3R" <path_to_qmk_pok3r>/vortex_pok3r_default.bin

## Supported Keyboards

* [Vortex POK3R](/keyboards/vortex/pok3r/)
* [Vortex POK3R RGB](/keyboards/vortex/pok3r_rgb/) (not stable)
* [Vortex Core](/keyboards/vortex/core/) (not stable)
* Vortex RACE3 (planned)
* Vortex ViBE (planned)
* KBP V60 (planned)
* KBP V80 (planned)

## Related

* [pok3rtool](https://github.com/pok3r-custom/pok3rtool) - CLI dev tool for pok3r keyboards
* [Pok3rConf](https://github.com/pok3r-custom/Pok3rConf) - GUI configuration tool for pok3r keyboards
