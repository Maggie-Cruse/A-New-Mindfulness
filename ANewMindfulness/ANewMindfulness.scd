//Team 2
//Cassidy Carson
//Quincy Lin
//Maggie Cruse

//A New Mindfulness
//Instructions
/* First run "waves," the two SynthDefs, as well as the OSCdef before navigating to the Processing sketch (titled "Room of Zen"). Run the processing sketch and hear the sound produced via facial recognition data. To enter meditation mode, click on the blue icon in the upper lefthand side of the sketch.In sync with the movement of shapes, inhale and exhale while hearing the healing frequencies now being produced. To exit meditation mode, press '1' on your keyboard. Press '2' on your keyboard to once again enter meditiation mode when desired.*/



//Run waves
(
~waves = {
	var noise = { WhiteNoise.ar(0.04 + LFNoise1.kr(0.3, 0.03)) };
	var motion = { LFNoise1.kr(0.2).exprange(100, 2000) };
	var hps = { HPF.ar(noise.value, 50) };
	var wave = { LPF.ar(hps.value, motion.value).tanh };
	var sig = wave!10;
	sig = Splay.ar(sig, 0.6).tanh;
	sig = sig * Line.kr(0, 1, 10); // fade in
	LeakDC.ar(sig);
}.play;
)



//Run chaos SynthDef
//screen 1
(
SynthDef(\chaos, {
	arg freq = 440, freq2 = 340, amp = 1, xpos=0;
	var sig;
	//two option of ugen for screen 1
	sig = Blip.ar([freq,freq2],10,amp);
	//sig = SinOsc.ar([freq,freq2],0, amp);
	Out.ar(0,sig);
}).add;
)

//Run center SynthDef
//screen 2 - meditation mode
(
SynthDef(\center, {
	arg freq = 100, amp = 1, xpos =0;
	var sig;
	sig = Pan2.ar(SinOsc.ar(freq+528,0,amp),xpos); //adding 528 makes the base sound the "miracle note" in the center of the screen
	Out.ar([0],sig);
}).add;
)

// Run d & f
d = Synth(\chaos, [\amp,0]);
f = Synth(\center, [\amp,0]);

//Run OSCdef
(
OSCdef('facelistener', {
	arg myOsc;
	
	var pos2 = (myOsc[4]-160)/160; 
	// ^ turns the screen coordinates to range from -1 to 1 for spacialized sound, along X-axis
	
	var makeMiddle = myOsc[4] - 160;
	if(makeMiddle < 0,
		{makeMiddle = makeMiddle*(-1)}
	);
	//similar to pos2, moves the range of the frequency so that 0 is the center on the A axis, before affected by the synthDef
	//the if statement checks if it is negative and makes it positive because you can't have a negative frequency

   //screen 1
	d.set(
		\freq, myOsc[1], //sets frequency for the left ear, based on X position
		\freq2, myOsc[2], //sets frequency for right ear, based on Y position
		\amp, myOsc[3],
	);
	
	//screen 2
	f.set(
		\freq,makeMiddle,
		\amp,myOsc[5],
		\xpos,pos2
	);

}, "/mindfulness");
)

//Open Processing sketch and run
