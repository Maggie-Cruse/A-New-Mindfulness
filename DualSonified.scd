//Names
//Cassidy Carson
//Quincy Lin
//Maggie Cruse

//A New Mindfulness
//Instructions
//processing + supercollider


play({LFTri.ar(DegreeToKey.kr(as(Scale.zhi,LocalBuf),Demand.kr(Saw.kr(3.711),0,Dseq((1..7).powerset.flat)),12,3.93,[0.08,95.32]).midicps)})




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
n = NetAddr(127.0.0.1, 57120);
(
SynthDef(\try, {
	arg freq = 200, amp = 1;
	var sig;
	sig = SinOsc.ar(freq*120,0,amp);
	Out.ar(0,sig);
}).add;
)

//screen 2
n = NetAddr(127.0.0.1, 57120);
(
SynthDef(\test, {
	arg freq = 100, amp = 1, xpos =0;
	var sig;
	sig = Pan2.ar(SinOsc.ar(freq,0,amp),xpos);
	Out.ar([0],sig);
}).add;
)

d = Synth(\try, [\amp,0]);

f = Synth(\test, [\amp,0]);

NetAddr.localAdd


(
OSCdef('facelistener', {
	arg myOsc;
	var pos1 = (myOsc[3]-160)/160;
	var idealFreq = (myOsc[3]+120)*2.18;
	postln(myOsc);
   //screen 1
	d.set(
		\freq, myOsc[1],
		\amp, myOsc[2]
	);
	//screen 2
	f.set(
		\amp,myOsc[4],
		\freq,idealFreq,
		\xpos,pos1
	);

}, "/movedis");
)//run to make facial sounds



NetAddr.localAdd


(

