---
title: "Preparing an LG Ultrawide Monitor"
layout: post
date: 2020-06-06
image: /assets/images/markdown.jpg
headerImage: false
tag:
- hardware
category: blog
author: andrew
description: Preparing to use an LG Ultrawide Monitor with your Mac.
---

I decided to try an ultrawide monitor to bring some change (and even excitement) to my work-from-home daily grind. I
figure that now is the time to try some of the more extreme productivity gear out there, and maybe even have
some fun with it. So I went all-out:
[the 49", 32:9, 5120x1440 curved ultrawide display from LG](https://www.lg.com/us/monitors/lg-49WL95C-W-ultrawide-monitor#)
(its real name is the `49WL95C-W` but I figure that doesn't mean anything to anyone but the manufacturer).

What do I think? It's a luxury item. Totally unnecessary. I couldn't possibly recommend it: the price is exorbitant
and there's just no way a monitor could justify the cost. It does have some really handy features though:
- it operates as a KVM: you can plug in two computers, one keyboard, and one mouse, and control both computers with the
same peripherals.
- you can even split the screen in half: one side for each computer.
- speakers (not great but not terrible)
- a USB-C port (and cable!) that transfers video, audio, USB peripherals, and enough power to charge your MacBook Pro.
- it is *huge*.

An important grievance:
- the power cable is too short to be useful. You'll need to [buy another](https://www.amazon.com/dp/B0728CMZSY).

To summarize: I think it makes sense for enthusiasts who like the way it looks and don't mind spending money on
unnecessary tech.

Now let's get to the real point of this post: what all is involved in setting it up to use with your Mac (note that
this advice should extend across LG's Ultrawide line and will probably help people using other brand monitors as well.
It won't be useful if you're using another OS, though).


# Connection

As I mentioned earlier, the monitor works as a KVM. Even if you're only connecting one machine (e.g. one MacBook Pro),
that still means that you should plug all your peripherals into the monitor and then connect the monitor to your
machine. The monitor's USB-C port and USB-C cable work great for this. It will even charge your MacBook Pro!


# Resolution

This is the tricky part: the monitor's resolution is 5120x1440. That's not exactly a standard. If you use the
default resolution controls on a Mac (*System Preferences -> Displays*):

![default resolution controls on a Mac](/assets/images/default-mac-display.png)

you're probably going to end up with a less-than-ultra width resolution (maybe 3840 instead of the glorious 5120). It's
not going to look good, and it really ruins the appeal of the monitor.

The great news is that it's easy to work around that. Hold the Option (⌥) key and click the `Scaled` radio button. This
should bring up exact resolution options:

![custom resolution controls on a Mac](/assets/images/option-mac-display.png)

There you have it! The glorious 5120x1440 option is just a click away. It's too bad that such a useful menu (selecting
exact resolution) is hidden behind an undocumented modifier key.


# Window Management

macOS already provides some slick window management via fullscreen apps, multiple desktops, and mission control.
Depending on your preferences, those default features may be enough for ultrawide use. For most coding tasks I think
it's sufficient to have a fullscreen split between Chrome and my IDE.

Sometimes you want more than two apps, though, and macOS doesn't provide much support for that. You can manually move
and resize windows to your heart's content, but that gets old fast, and it feels like there should be software to
handle that for you.

LG was thinking the same thing, so they made some window management software to go with their ultrawide monitors. It's
actually really hard to find, which is why I'm writing the link into my blog,
[right here](http://gscs-b2c.lge.com/downloadFile?fileId=D69pl26Ru9P0ZBgWlPnug) (that's a safe link, `lge.com`
redirects to `lg.com`). Enjoy!


# Audio Controls
This monitor comes with speakers. You're not going to love them, but they are certainly more immersive than my
laptop's. Furthermore, you really can't ignore the convenience of the single USB-C port connection serving video,
peripherals, *and* audio.

So I'm using them, and maybe you will too. They do fall prey to the classic Mac trap: the volume controls on your
keyboard won't affect any external speakers, these included.

> Why do Macs do this? I'm not entirely sure in this case because we're talking about a USB-C connection, but I have
heard that it's part of the HDMI spec to leave audio controls to the speakers. That's fair, but there's a solution to
that problem: use HDMI-CEC messages to send volume up/down commands to the speakers. I'm not sure why Apple isn't doing
that.

You can use the monitor's hardware controls to adjust the volume, but that's really inconvenient (your keyboard
controls are already beneath your fingers!). I'd recommend using [SoundSource](https://rogueamoeba.com/soundsource/)
instead.

SoundSource has a lot of features that I've never used before. It's paid software too: a lifetime license costs $30.
That said, "it just works". Install the software, run it on login, and your keyboard controls will operate your
speakers. The financial decision is up to you.


# To Conclude

That's it! You can try playing with the monitor's picture mode if you want. The default ("Vivid") works fine for me.
Hope you enjoy it as much as I do!
