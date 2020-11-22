//Names
//Cassidy Carson
//Quincy Lin
//Maggie Cruse
//

//Title
//Sound of Snow
//Instructions
//processing + supercillider


n = NetAddr(127.0.0.1, 57120);
(
SynthDef(\test, {
	arg freq = 100, amp = 1, xpos =0;
	var sig;
	sig = Pan2.ar(SinOsc.ar(freq,0,amp),xpos);
	Out.ar([0],sig);
}).add;
)//run first to define synthdef

f = Synth(\test, [\amp,0]);
//then run this to initialize synth

NetAddr.localAddr



(

OSCdef('facelistener', {
	arg myOsc;
	var pos1 = (myOsc[1]-160)/160;
	var idealFreq = (myOsc[1]+120)*2.18;
	postln(idealFreq);
	f.set(
		\amp,0.05,
		\freq,myOsc[1],
		\xpos,pos1
	);

}, "/move");
)//run to make facial sounds

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

~waves release: 10;

