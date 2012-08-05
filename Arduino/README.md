CAC Arduino Sketch
--------------------

This is the Arduino sketch for Computer Augmented Crafts.
It is written and tested in the Arduino 1.0 IDE. 

### Cut length measurement

A pair of digital calipers connects to the Arduino with a level shifter. A detailed description of the software and hardware involved can be found on the Nut & Bolt blog: [ Reading digital calipers with an Arduino ](http://nut-bolt.nl/2012/reading-digital-calipers-with-an-arduino/)


### Strip presence detection, cut detection

Strip detection is done with a CNY70 optical sensor. 

### Weld detection

The lever of the spot welder depresses a tactile switch when it is pressed down. This is not the preffered way to go - a next version should employ current measurement using a current transformer on the spot welder's AC line. Non-contact current measurement is more reliable and safer.

### Circular position sensor

36 infrared LEDs light up in sequence using four 74HC4017 ICs hooked up to the anodes (+) of the LEDs. Cathodes (-) are all hooked together and go through a current limiting resistor into an Arduino pin. The Arduino pin is pulsed at 36kHz using Arduino's built-in tone() function. A 36kHz infrared receiver looks down at the infrared LEDs. A covered infrared LED will not be seen by the infrared receiver, thus indicating that a strip is registered at this position.

Licensing
---------

The sketch is released under the MIT License.

The code that reads out the calipers is based on [ **Digital caliper readout code for the MSP430** by Robocombo ](http://robocombo.blogspot.nl/2010/12/using-tis-launchpad-to-interface.html)