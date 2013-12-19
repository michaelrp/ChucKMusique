/*
    Assignment_6_UFO
    bass.ck

    This is slightly longer than 30 seconds, because, well, it
    needed to be. For art!
*/


[41, 42, 44, 46, 48, 49, 51, 53, 54, 56, 58] @=> int scale[];
0.625 => float beat;

Mandolin base => Chorus chor => NRev rev => Pan2 pan => dac;
0.2 => base.gain;
0.05 => base.bodySize;
0.005 => base.stringDetune;

0.12 => rev.mix;

//slightly left of center
-0.25 => pan.pan;

0.01 => chor.modDepth;
.1 => chor.modFreq;


3 => int note;
for(0 => int i; i < 3; i++)
{
    // pick specific first note for every 16 beats note
    Std.mtof(scale[3] - 12) => base.freq;
    
    for (0 => int j; j < 16; j++)
    {
        if(Math.random2(0,4) == 0)
        {
            // sometimes play a pickup note
            1.0 => base.noteOn;
            (beat * .8)::second => now;
            0.8 => base.noteOff;
            1.0 => base.noteOn;
            (beat * .2)::second => now;
            0.8 => base.noteOff;
        }
        else
        {
            // usually play normal
            1.0 => base.noteOn;
            beat::second => now;
            0.8 => base.noteOff;
        }

        // randomize some settings
        Math.random2f(0.0, 0.9) => base.stringDamping;
        Math.random2f(0.4, 1.0) => base.pluckPos;
        Math.random2(-1, 1) => int rnd;
        
        // pick next note
        if(rnd == 0)
        {
            // sometimes jump away from walking bass
            Math.random2(0, scale.cap() - 1) => note;
        } 
        else
        {
            rnd +=> note;
        }
        
        // don't let the bass walk off the available scale
        if(note < 0)
        {
            2 +=> note;
        }
        if (note > scale.cap() - 1)
        {
            2 -=> note;
        }
        
        Std.mtof(scale[note] - 12) => base.freq;
    }
}

Std.mtof(scale[3] - 12) => base.freq;

1.0 => base.noteOn;
beat * 4::second => now;

.8 => base.noteOff;
