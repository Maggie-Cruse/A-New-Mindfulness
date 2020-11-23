//Names
//Cassidy Carson
//Quincy Lin
//Maggie Cruse

//A New Mindfulness
//Instructions
//processing + supercollider







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


//screen 1

(
SynthDef(\try, {
	arg freq = 440, freq2 = 340, amp = 1, xpos=0;
	var sig;

	//two option of ugen for screen one
	sig = Blip.ar([freq,freq2],10,amp);
	//sig = SinOsc.ar([freq,freq2],0, amp);

	Out.ar(0,sig);
}).add;
)




//screen 2

(
SynthDef(\test, {
	arg freq = 100, amp = 1, xpos =0;
	var sig;
	sig = Pan2.ar(SinOsc.ar(freq+528,0,amp),xpos);
	Out.ar([0],sig);
}).add;
)

d = Synth(\try, [\amp,0]);

f = Synth(\test, [\amp,0]);

NetAddr.localAdd


(
OSCdef('facelistener', {
	arg myOsc;
	var pos1 = (myOsc[1]-160)/160;
	var pos2 = (myOsc[4]-160)/160;
	var makeMiddle = myOsc[4] - 160;



	if(makeMiddle < 0,
		{makeMiddle = makeMiddle*(-1)}
	);

	postln(makeMiddle);

	postln(myOsc);
   //screen 1
	d.set(
		\freq, myOsc[1],
		\freq2, myOsc[2],
		\amp, myOsc[3],
		\xpos, pos1
	);
	//screen 2
	f.set(
		\amp,myOsc[5],
		\freq,makeMiddle,
		\xpos,pos2
	);

}, "/movedis");
)//run to make facial sounds




