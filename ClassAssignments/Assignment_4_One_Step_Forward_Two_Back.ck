// Assignment_4_One_Step_Forward_Two_Back

//arrays to hold scale and notes
[ 51, 53, 55, 56, 58, 60, 61, 63 ] @=> int scale[];
[ 6, 1, 5, 2, 1, 1, 0, 6, 1, 5, 3, 4, 4, 0 ] @=> int melody[];
[ 0, 4, 0 ] @=> int base[];

Gain master => dac;

//set up click sound
SndBuf click => Pan2 click_pan => dac;
me.dir() + "/audio/click_01.wav" => click.read;
.1 => click.gain;
click.samples() => click.pos;

//set up hihat sound
SndBuf hihat => master;
me.dir() + "/audio/hihat_01.wav" => hihat.read;
hihat.samples() => hihat.pos;

//set up kick sound
SndBuf kick => master;
me.dir() + "/audio/kick_02.wav" => kick.read;
.2 => kick.gain;
kick.samples() => kick.pos;

//set up melody oscs
Gain m_osc_gain => Pan2 m_osc_pan => dac;
.2 => m_osc_gain.gain;

TriOsc m1 => m_osc_gain;
.3 => m1.gain;
TriOsc m2 => m_osc_gain;
.3 => m2.gain;
TriOsc m3 => m_osc_gain;
.3 => m3.gain;

//set up base oscs
Gain b_osc_gain => dac;
.2 => b_osc_gain.gain;

SinOsc b1 => b_osc_gain;
.5 => b1.gain;
SqrOsc b2 => b_osc_gain;
.05 => b2.gain;

//set up fx
SndBuf fx => Pan2 fx_pan => dac;
me.dir() + "/audio/stereo_fx_03.wav" => fx.read;
fx.samples() => fx.pos;
.5 => fx.rate;

.6 => float beat;

//function to play hihat, click percussive sounds, move time
//  the number of clicks and hihats is dependent on the number of
//  repeats passed in, divided equally into the beat
fun void repeater( int clickRepeats, int hihatMod )
{
    for( 0 => int i; i < clickRepeats; i++)
    {
        0 => click.pos;
        //random click pan
        Math.random2f(-1, 1) => click_pan.pan;
        
        if( i % hihatMod == 0 )
        {
            0 => hihat.pos;
            //random hihat volume and rate
            Math.random2f(.6, 1.2) => hihat.rate;
            Math.random2f(.08, .1) => hihat.gain;
        }
 
        (beat / clickRepeats)::second => now;
    }
}

//function to set detuned melody notes
fun void setMelodyNote( int beatNote )
{
    scale[melody[beatNote]] => int midiNote;
    
    Std.mtof(midiNote) => m1.freq;
    Std.mtof(midiNote) + 2 => m2.freq;
    Std.mtof(midiNote) - 2 => m3.freq;
}

//function to calculate and set detuned base notes
fun void setBaseNote( int beatNote )
{
    scale[base[(beatNote % base.cap())]] - 12 => int midiNote;
    
    Std.mtof(midiNote) => b1.freq;
    Std.mtof(midiNote) + 2 => b2.freq;
}

//variable used to control pan of melody
0 => float pan_marker;

for(0 => int i; i < 4; i++)
{
    //start fx after two repeats of melody
    if(i >= 2)
    {
        0 => fx.pos;
    }
    
    for(0 => int j; j < melody.cap(); j++)
    {
        if( j % 6 == 0 || j % 7 == 0)
        {
            0 => kick.pos;
        }
        
        if(i >= 2)
        {
            //if fx is playing, move pan opposite melody
            Math.sin(pan_marker * -1) => fx_pan.pan;
        }
        
        //set melody note
        setMelodyNote(j);
        Math.sin(pan_marker) => m_osc_pan.pan;
        
        //set base note
        setBaseNote(j);
        
        //add percussion and move time
        repeater(Math.random2(3, 6), Math.random2(2, 3));

        //used to cycle melody pan
        pan_marker + .4 => pan_marker;
    }
}