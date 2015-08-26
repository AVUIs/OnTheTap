OnTheTap
=========

Tap reactive audio visual system

The system plays with the tactile, analog feel of tapping surfaces as a digital input device.
The input and it's gestures in turn drive sound and visuals expressively
This is achieved by pairing the moment of tap with the loudness at that moment in time.
Using the loudness as input for the ouput sounds alse creates brief feedback loops.

![OnTheTap Visuals](https://github.com/AVUIs/OnTheTap/raw/master/assets/OnTheTap.gif)

Repository Structure
====================

The **GenAV Performance** folder contains the components used during the Hackathon and performance:
* Input - contains the Tap input Processing sketch and an (optional) Android application (eclipse project)
* Sound - contains the musical setup by Alois and the OSCulator setup used to map OSC messages to MIDI
* Visuals - contains visuals programmed by Sabba

*GenAV Performance Dependencies*

The GenAV Performance Processing code relies on the [oscP5](http://www.sojamo.de/libraries/oscP5/) and [controlP5](http://www.sojamo.de/libraries/controlP5/) libraries.
The easiest way to install this in Processing 2 and newer is via **Sketch > Import Library... > Add Library ...** then search for the above.

The initial sound composition was done in MaxMSP. The latest iteration was done in [Ableton Live](https://www.ableton.com/)
and the OSC to MIDI bridge was done using [OSCulator](http://www.osculator.net/)

In terms of the hackathon brief, this doesn't follow a of the items very closely.
However, there is something interesting to explore starting from the simple concept of a tap

Also note that the includes hard coded ip addresses. 
This is far from ideal and the aim was to have a basic mapping system.
The refactored OSC code got organized a bit into the start of the [OSCTap Processing library](https://github.com/orgicus/OSCTap)
This can be downloaded from the library's [releases page] and source code is available as submodule of this repository.

To explore the tap idea closer to the brief The **TapCA2D** sketch was creating.
It's a self contained Processing sketch which uses only 1 library (Minim), already included with Processing.
The tap input's parameters (x,y,amplitude) are mapped to a 2D Cellular Automata: a circle of live cells is placed at the x,y coordinates and the amplitude determines the radius.
![TapCA2D](https://github.com/AVUIs/OnTheTap/raw/master/assets/tap_ca_brush.gif)

The 2D CA's alive cells are mapped directly to string sounds.
Needless to say many strings plucked fast don't sound very musical.
This is a simple setup that can be easily modified to sound different.

![TapCA2D](https://github.com/AVUIs/OnTheTap/raw/master/assets/TapCA2D.gif)

Contributors
============

* [Sabba Keynejad](http://sabbakeynejad.co.uk)
* [George Profenza](http://lifesine.eu)
* [Alois Yang](http://aloisyang.com/)
