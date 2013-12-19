/*
    Assignment_6_UFO
    ufo.ck

    This is slightly longer than 30 seconds, because, well, it
    needed to be. For art!
*/

0.625 => float beat;
SinOsc s => SqrOsc sqr_osc => Gain sqr_gain => Chorus chor => Gain master => NRev rev => Pan2 p => dac;

2 => sqr_osc.sync;

//1000 => s.freq;
1000 => s.gain;

0.02 => master.gain;
0.4 => sqr_gain.gain;

// chorus parameters set
0.01 => chor.modDepth;
.1 => chor.modFreq;
0.01 => float chor_modFreq;
0.1 => rev.mix;

// melody note array
[41, 42, 44, 46, 48, 49, 51, 53, 54, 56, 58] @=> int scale[];

for(0 => int i; i < 8; i++)
{
    /* randomize array index for melody notes */
    scale[Math.random2(0, scale.cap()-1)] + 36 => int midi_note;
    Math.random2f(0.0,10.0) => float sqr_osc_phase;
    
    Std.mtof(midi_note) => sqr_osc.freq;
    sqr_osc_phase => sqr_osc.phase;
    Math.random2f(-0.5, 0.5) => p.pan;
    Math.random2f(500, 1000) => s.freq;
    
    // random repeats of the FX per beat
    Math.random2(5, 10) => int reps;
    1 => int is_on;
    
    // toggle the ufo gain on and off a random number of times
    for(0 => int j; j < (reps * 4); j++)
    {
        if(is_on == 1)
        {
            0.1 => master.gain;
        }
        else
        {
            0 => master.gain;
        }
        (beat / reps)::second => now;
        Math.abs(is_on - 1) => is_on;
    }
}

