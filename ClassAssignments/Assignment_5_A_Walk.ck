// Assignment_5_A_Walk

[ 49, 50, 52, 54, 56, 57, 59, 61 ] @=> int scale[];
.75 => float quarter;
[ 0, 2, 4, 3, 5, 4, 6, 7 ] @=> int melody[];

//set up STK
ModalBar mb => NRev mb_rev => Pan2 mb_pan => dac;
7 => mb.preset;
.02 => mb_rev.mix;

//set up click sound SndBuf
SndBuf click => NRev click_rev => Pan2 click_pan => dac;
me.dir() + "/audio/click_01.wav" => click.read;
0.0 => click.gain;
click.samples() => click.pos;
0.02 => click_rev.mix;

//set up melody osc sound chain
SinOsc m_osc => ADSR env => Chorus m_osc_ch => Pan2 m_osc_pan => dac;
(20::ms, 0::ms, 1, 10::ms) => env.set;
0.3 => m_osc.gain;
2 => m_osc.sync;
0.9 => m_osc_ch.modDepth;
0.05 => m_osc_ch.modFreq;
-0.25 => m_osc_pan.pan;

0 => int curr_melody;

fun void setModalBarValues()
{
    //randomly set frequency from scale (with two octaves either up or down)
    Math.random2(-1, 1) * 12 => int oct;
    Std.mtof(scale[Math.random2(0, 7)] + oct) => mb.freq;
    
    //random stick hardness for modal bar
    Math.random2f(0.5, 0.9) => mb.stickHardness;
    
    //randomly set pan
    Math.random2f(0.5, 0.9) => mb_pan.pan;
}

//plays clicks, modal bar, melody (sometimes) and advances time
fun void repeats(int n, int play_melody)
{
    if(play_melody == 1)
    {
        Std.mtof(scale[melody[curr_melody]]) => m_osc.freq;
        1 => env.keyOn;
    }
    for(0 => int i; i < n; i++)
    {
        //play click on every eigth note
        if(i % (n / 2) == 0)
        {
            0 => click.pos;
        }
        
        //sometimes don't play the modal bar
        if( Math.random2f(0, 1) > .1 )
        {
            setModalBarValues();
            1 => mb.noteOn;
        }
        
        //playing sixteenth-note triples (six per quarter note)
        (quarter / n)::second => now;
    }
    if(play_melody == 1)
    {
        1 => env.keyOff;
        curr_melody++;
    }
    if(curr_melody == melody.cap())
    {
        0 => curr_melody;
    }
}


// MAIN PROGRAM

//click intro
for(0 => int i; i < 8; i++)
{
    0 => click.pos;
    (quarter / 2)::second => now;
    if(click.gain() > .1)
    {
       .1 => click.gain;
    }
    else
    {
        click.gain() + 0.02 => click.gain;
    }
}

//adding modal bar
for(0 => int i; i < 8; i++)
{
    repeats(6, 0);
}

//add melody, slower modal bar
for(0 => int i; i < 4; i++)
{
    repeats(2, 1);
    repeats(4, 1);
    repeats(4, 1);
    repeats(2, 1);
}

//modal bar
for(0 => int i; i < 8; i++)
{
    repeats(6, 0);
}

//end with clicks
while( click.gain() > 0 )
{
    0 => click.pos;
    (quarter / 2)::second => now;
    click.gain() - .01 => click.gain;
}
