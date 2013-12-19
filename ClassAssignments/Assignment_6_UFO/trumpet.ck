/*
    Assignment_6_UFO
    trumpet.ck

    This is slightly longer than 30 seconds, because, well, it
    needed to be. For art!
*/

[ 42, 44, 46, 48, 49, 51, 53, 54, 56, 58, 60 ] @=> int scale[];
0.625 => float beat;

// the STK for this week is a "trumpet"
Brass trumpet => NRev rev => Pan2 pan => dac;

0.25 => pan.pan;
0.1 => rev.mix;
.5 => trumpet.gain;

fun void trumpetRun(int numberOfNotes)
{
    // repeat fast trumpet notes depending on parameter
    for(0 => int i; i < numberOfNotes; i++)
    {
        scale[Math.random2(0, scale.cap() - 1)] + 24 => int midi_note;
        Std.mtof(midi_note) => trumpet.freq;

        Math.random2f(0.0, 0.2) => trumpet.lip;
        Math.random2f(0.5, 1.0) => trumpet.rate;
        
        Math.random2f(.5, .9) => trumpet.noteOn;
        
        // play eight notes per beat
        (beat / 8)::second => now;
        0.6 => trumpet.noteOff;
    }
    beat::second => now;
    1.0 => trumpet.noteOff;
}

trumpetRun(17);
trumpetRun(5);
trumpetRun(3);
trumpetRun(15);

(beat * 8)::second => now;

trumpetRun(3);
trumpetRun(5);
trumpetRun(2);
trumpetRun(7);

(beat * 8)::second => now;

trumpetRun(17);
trumpetRun(7);
trumpetRun(7);
trumpetRun(15);

beat::second => now;

// play last high note
Std.mtof(84) => trumpet.freq;

1.0 => trumpet.noteOn;
(beat * 4)::second => now;
1.0 => trumpet.noteOff;
(beat * 2)::second => now;