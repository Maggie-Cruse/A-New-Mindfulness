n = NetAddr(127.0.0.1, 57120);
(
SynthDef(\try, {
	arg freq = 200, amp = 1;
	var sig;
	sig = SinOsc.ar(freq+50,0,amp);
	Out.ar(0,sig);
}).add;
)

d = Synth(\try, [\amp,0]);

f = Synth(\test, [\amp,0]);

NetAddr.localAdd


(
OSCdef('facelistener', {
	arg myOsc;
	var pos1 = (myOsc[1]-160)/160;
	var idealFreq = (myOsc[1]+120)*2.18;
	postln(idealFreq);
	d.set(
		\amp,myOsc[4],
		\freq,myOsc[3],
		\xpos,pos1
	);
	f.set(
		\freq, myOsc[1],
		\amp, myOsc[2]
	);

}, "/movedis");
)//run to make facial sounds




n = NetAddr(127.0.0.1, 57120);
(
SynthDef(\test, {
	arg freq = 200, amp = 1;
	var sig;
	sig = Dust.ar(freq+50,0,amp);
	Out.ar(0,sig);
}).add;
)



NetAddr.localAdd


(

