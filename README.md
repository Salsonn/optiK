# Ringdown optiK 
### Peripheral management made efficient
___
Ringdown optiK allows for a user to have a specific configuration set up for each peripheral in use, that activates and deactivates based on if the device is connected. It supports having multiple devices under one profile, and profiles can be associated with any program of your choosing.

Any time a device is connected or disconnected, optiK performs a check on all connected USB and Bluetooth input peripherals, then cross-references that with its configuration and executes (or kills) any software associated with that device.

## Installation
Download `optiKsetup.exe` from the latest release tab, and run to install.
For best results, allow optiK to run on startup. It uses 3MB of RAM and uses no CPU when idle.

Ringdown optiK installs in `AppData -> Roaming -> Programs -> optiK` by default.

Useful command line flags include `/silent` and `/dir=$PATH` for better automation.

Ringdown optiK can also be used as a completely portable app by downloading and extracting the .zip file found in Releases.

## Usage
To add your own device profile, edit `devices.ini` inside the `config` folder. Use the following template:

```
profile:"[profile-name]"
    "[device-name]":[VendorID]&[ProductID]
```
Both `profile-name` and `device-name` are both cosmetic names for displaying and organizing. They can be basically whatever you want.
`VendorID` and `ProductID` are the HID identifiers for the device you want under the given profile. 

In the case of wired devices, they can be easily retrieved by checking `Device Manager -> [device-in-question] -> Properties -> Details -> Device Instance Path`. Bluetooth devices are slightly different, instead of `Device Instance Path` it seems to hide under `Bus relations`. 

In the case of wireless USB devices (with a dongle), the process can be more difficult, as the same USB wireless receiver hardware tends to be used for multiple different wireless peripherals. If you only have one device that uses a given dongle, this issue won't likely crop up. If it does, my solution for Logitech is to use their proprietary HID++ protocol to communicate with the devices _through_ their dongle, and get their ProductID that way.

## Background

Ringdown optiK began as "Zealot", an AutoHotkey script that handled a basic scrolling macro for my Zelotes T80 gaming mouse (a generic Chinese model) that I got for a whopping $10 back before I was even in High School. As my proficiency with AutoHotkey expanded, so did Zealot, and eventually I got a LUOM G10 mouse (also generic) which had more buttons, so I expanded my script to handle more. That mouse was well-loved to the point that it began falling apart, so I replaced it with a Redragon M902 gaming mouse, which I had for about a week before snagging a Logitech G502 Hero SE on sale. While I _do_ still have the LUOM G10 hiding somewhere, the G502 is my true daily driver, with a G602 that I keep in my backpack on the same key bindings.

Here I am on a software page talking about hardware...

For a time, I was actively using both the Zelotes and LUOM mice, so I added code to both their scripts that let me manually switch between the two, and while I wanted to automate the switching process, I couldn't find a way to do so. Eventually, I gave the Zelotes mouse to my cousin, but the idea of automatic profile switching still stuck with me.

Fast forward to when I got the G502, I added some code that would loop frequently to check for certain conditions. It was sloppy, and I knew it was sloppy, but I didn't know enough about AutoHotkey to make it less so. In lieu of that I looked back at my idea of automatically switching profiles and realized that whatever mechanism I'd potentially find to implement _that_ feature could likely make my code less sloppy, so I did more digging, but ultimately got nowhere.

Fast forward to my Junior year of college, and a off-the-cuff Google search led me to exactly the information I needed to make both of my ideas happen, so I set to overhauling my little optiK script into a fully-fledged, lightweight application...and then pivoted into making it something that just initiated and managed what _had_ been optiK. Because it is now a wrapper, it has the potential to go beyond AutoHotkey scripts and manage larger programs like Logitech's GHub and Corsair's iCUE, which are immensely powerful, but also massive memory hogs. A lightweight utility to start and stop such programs on lower-memory systems has a lot of utility.

## Loose Plans
Now that I have a dedicated installer (thank you INNO for having an easy mode), I'm likely to take a break from working on this in any significant way.

### Current Plans
* Take a stab at adding to WinGet
* `compile.ahk` currently only works if run from within VSCode? Why?
* Separate optiK-Hero and relevant code to its own repository
    * Or...maybe just adding automatic update functionality
    * Add download link to devices.ini?
* Only optiK-HERO is actually included with finished product
    * Low priority, as I haven't used the other profiles in _ages_
* Better child-process management
    * Current method doesn't actually use child process functionality
        * Is that even possible to implement?
    * Current method falls apart if the profile's program restarts itself (and gets a new Process ID)
* Overhaul of profile management
    * Currently pretty not-smart, just enables a profile when one or more devices are connected, and disables when all devices are disconnected.
    * No way to override that lasts beyond a re-detect of devices

## Credits

Clément Vuchener's work on making sense of Logitech's HID++ protocol, and creating the hidpp utilites over at [cvuchener/hidpp](https://github.com/cvuchener/hidpp). I went through the rather painful process of compiling his code for Windows, and those fruits can be found at `hidpp-list-devices.exe` and `libhidpp.dll` in the `bin` folder.
