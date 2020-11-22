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
	sig = Decay.ar(SinOsc.ar(freq,0,amp), 10);
	Out.ar(0,sig);
}).add;
)

f = Synth(\test, [\amp,0]);

NetAddr.localAddr



(

OSCdef('facelistener', {
	arg myOsc;
	f.set(
		\amp,1,
		\freq,myOsc[1]
	);

}, "/move");
)


