// Assignment_2_Shifty
/*
 * Playing with the idea of phase shift in a repeating pattern. The two
 * "base" parts use the same pattern, but played out of phase that is
 * randomly generated.
 */

// required scale (two octaves)
[ 50, 52, 53, 55, 57, 59, 60, 62, 64, 65, 67, 69, 71, 72, 74] @=> int scale[];

// "base" ostinato part
[ 0, 1, 2, 1, 4, 4, 4, 3 ] @=> int part[];

// melody notes
[ 7, 8, 7, 11, 10, 13, 12, 11, 8, 7, 6, 4, 6, 1, 0 ] @=> int melody[];
// melody rhythm -- denotes "beat" to change note
[ 16, 24, 30, 32, 40, 44, 48, 56, 62, 64, 80, 88, 96, 102, 104 ] @=> int melody_change[];

// melody osc
SinOsc m => dac;

0 => m.gain;

// base oscs
SinOsc p1 => Pan2 pan1 => dac;
SinOsc p2 => Pan2 pan2 => dac;

// pan p1 to the right
.9 => float pan1_amt;
.2 => float p1_gain;
p1_gain => p1.gain;
pan1_amt => pan1.pan;

// pan p2 to the left
-.9 => float pan2_amt;
.2 => float p2_gain;
p2_gain => p2.gain;
pan2_amt => pan2.pan;


// defining some variables to help manage notes
.25 => float beat;
int m_note;
int p1_note;
int p2_note;
part.cap() => int length;
0 => int curr_beat;
2 => int phase_shift;
0 => int melody_idx;

// main loop to play
for (0 => int b; b < 15; b++)
{
    //<<< "phase:", phase_shift >>>;
    
    for (0 => int j; j < length; j++)
    {
        //<<< curr_beat >>>;
        
        // determine if the main melody should change its note
        if(melody_idx < melody_change.cap() && melody_change[melody_idx] == curr_beat)
        {
            .25 => m.gain;
            scale[melody[melody_idx]] => m_note;
            Std.mtof(m_note) => m.freq;
            
            //<<< m_note, Std.mtof(m_note) >>>;
            
            // move through the main melody
            melody_idx++;
        }
        
        // p1 always plays the same pattern
        scale[part[j]] => p1_note;
        // p2 plays a "phase shift" of the p1 pattern
        scale[part[(j + phase_shift) % length]] => p2_note;
        
        Std.mtof(p1_note) => p1.freq;
        Std.mtof(p2_note) => p2.freq;
        
        //<<< p1_note, p2_note >>>;
        
        beat::second => now;

        curr_beat++;
    }

    // every 8 beats, reassign the phase shift for the base parts
    if (b % 2 == 0)
    {
        Math.random2(1, 6) => phase_shift;
    }
}

// hold last notes
1::second => now;