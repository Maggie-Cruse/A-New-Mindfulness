//Names
//Quincy Lin

//Title
//Sound of Snow
//Instructions
//processing + supercillider


n = NetAddr(127.0.0.1, 57120);
(
SynthDef(\test, {
	arg freq = 400, amp = 1;
	var sig;
	sig = SinOsc.ar(freq) * amp;
	Out.ar(0,sig);
}).add;
)

Synth(\test);

NetAddr.localAddr

(

OSCdef('facelistener', {
	arg myOsc;
	Synth(\test, [\freq, myOsc[1]*400,\amp, 0.01]);

}, "/move");
)