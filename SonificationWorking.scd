//Names
//Quincy Lin

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
)

f = Synth(\test, [\amp,0]);

NetAddr.localAddr



(

OSCdef('facelistener', {
	arg myOsc;
	var pos1 = (myOsc[1]-160)/160;
	postln(pos1);
	f.set(
		\amp,1,
		\freq,400,
		\xpos,pos1
	);

}, "/move");
)

