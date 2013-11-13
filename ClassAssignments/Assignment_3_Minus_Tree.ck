// Assignment_3_Minus_Tree

//define notes in scale
[ 48, 50, 52, 53, 55, 57, 59, 60, 62 ] @=> int scale[];

//define tune for midrange
[ 0, 7, 6, 6, 7, 3, 2, 3 ] @=> int tune[];

//set quarter note
.25 => float quarter_note;

//set up sound buffer for "reversed" sound
SndBuf reverse_hihat => Pan2 rvs_pan => dac;
me.dir() + "/audio/hihat_01.wav" => reverse_hihat.read;
0 => reverse_hihat.gain;
1 => rvs_pan.pan;

//set osc for random base line
SqrOsc rnd_base => Pan2 rnd_base_pan => dac;
0 => rnd_base.gain;

//set master gain and oscs for high note
Gain hi_gain => Pan2 hi_pan => dac;
SinOsc hi1 => hi_gain;
SinOsc hi2 => hi_gain;
.05 => hi1.gain;
.01 => hi2.gain;

0.05 => hi_gain.gain;
-1 => hi_pan.pan;

Std.mtof(scale[0] + 48) => hi1.freq;
Std.mtof(scale[0] + 60) => hi2.freq;

//set master gain and oscs for midrange tune
Gain tune_master => dac;
0 => tune_master.gain;

TriOsc osc1 => tune_master;
SinOsc osc2 => tune_master;
SqrOsc osc3 => tune_master;
.2 => osc1.gain;
.75 => osc2.gain;
.05 => osc3.gain;

//set click sound and fx for intro
SndBuf click => Pan2 click_pan => dac;
SndBuf fx => dac;

//load click sound and fx
me.dir() + "/audio/click_01.wav" => click.read;
me.dir() + "/audio/stereo_fx_02.wav" => fx.read;
.1 => click.gain;

click.samples() => click.pos;
fx.samples() => fx.pos;

-1 => click_pan.pan;

//load drums into master gain and arrays
Gain drums_master => dac;
.8 => drums_master.gain;

SndBuf drums[5];
Pan2 drum_pan[5];

//load hihats
me.dir() + "/audio/hihat_01.wav" => drums[0].read;
.15 => drums[0].gain;
me.dir() + "/audio/hihat_03.wav" => drums[1].read;
.1 => drums[1].gain;

//load snare
me.dir() + "/audio/snare_01.wav" => drums[2].read;

//load kicks
me.dir() + "/audio/kick_03.wav" => drums[3].read;
me.dir() + "/audio/kick_05.wav" => drums[4].read;
.4 => drums[4].gain;

for (0 => int i; i < drums.cap(); i++)
{
    //add all sndbufs to master gain
    drums[i] => drum_pan[i] => drums_master;
    
    //move all sndbufs to end (no sound)
    drums[i].samples() => drums[i].pos;
}

//start the music

//intro
0 => fx.pos;
1::second => now;

for (0 => int i; i < 24; i++)
{
    0 => click.pos;
    click.gain() + .03 => click.gain;
    click_pan.pan() + (i + 1) / 150.0  => click_pan.pan;
    
    fx.gain() - .02 => fx.gain;
    
    (quarter_note / 2.0)::second => now;
}

//start repeating drum pattern

//0 => int counter;

for (0 => int r; r < 6; r++) 
{
    for (0 => int beat; beat < 32; beat++)
    {
        //continue intro click sound for a bit
        if (click.gain() > 0)
        {
            0 => click.pos;
            click.gain() - .05 => click.gain;
            click_pan.pan() - .05 => click_pan.pan;
        }
        
        //closed hihat every eigth except last of "measure"
        if ((beat + 1) % 8 != 0)
        {
            0 => drums[0].pos;
            //add some randomness for hihat volume and rate
            Math.random2f(.90, 1) => drums[0].rate;
            Math.random2f(.08, .1) => drums[0].gain;
        }

        //base kick beats every "measure"
        if (beat % 8 == 0)
        {
            0 => drums[4].pos;
        }
        
        //after one repeat, add open hihat on 2 and 4
        if (r > 0 && (beat + 2) % 4 == 0)
        {
            0 => drums[1].pos;
        }

        //snare beats
        if (beat == 4 || beat == 12 || beat == 20
            || beat == 23 || beat == 28)
        {
            0 => drums[2].pos;
            if (beat == 23)
            {
                1 => drums[2].gain;
            }
            else
            {
                //add some randomness into the snare volume
                Math.random2f(.65, .7) => drums[2].gain;
            }
        }
        
        //kick beats
        if (beat == 0 || beat == 8 || beat == 10
            || beat == 14 || beat == 16 || beat == 25
            || beat == 26)
        {

            0 => drums[3].pos;
            if (beat == 26)
            {
                .9 => drums[3].gain;
            }
            else
            {
                //add randomness to kick volume
                Math.random2f(.6, .7) => drums[3].gain;
            }
        }
        
        //addative effects
        
        //add midrange tune after one repeat
        if (r > 0)
        {
            if (tune_master.gain() < .10)
            {
                tune_master.gain() + .005 => tune_master.gain;
            }

            scale[tune[beat % 8]] => int m_note;
        
            Std.mtof(m_note) + .1 => osc1.freq;
            Std.mtof(m_note) => osc2.freq;
            Std.mtof(m_note) => osc3.freq;
        }
        
        //add random base after two repeats
        if (r > 1)
        {
            if (Math.randomf() < .2)
            {
                0 => rnd_base.gain;
            }
            else
            {
                Math.random2f(.02, .1) => rnd_base.gain;
            }
            
            //select random base notes from scale
            scale[Math.random2(0, 6)] - 24 => int m_note;
            Std.mtof(m_note) => rnd_base.freq;
            //set random pan for base
            Math.random2f(-0.5, .5) => rnd_base_pan.pan;
        }
        
        //fade in reverse hihat
        if (reverse_hihat.gain() < .55)
        {
            //fade in reversed hihat sample
            reverse_hihat.gain() + .05 => reverse_hihat.gain;
        }
        
        if (beat % 4)
        {
            //the whole sample is too long, so clip to just half
            reverse_hihat.samples() / 2 => reverse_hihat.pos;
            -.45 => reverse_hihat.rate;
            //change the pan from right to left
            rvs_pan.pan() - 0.05 => rvs_pan.pan;
        }
        
        //play stereo effect again
        if (r == 3 && beat == 0)
        {
            0 => fx.pos;
            .4 => fx.gain;
        }
        
        //fade in high note after a few repeats 
        if (r > 3)
        {
            // add high pitch
            if (hi_gain.gain() < .2)
            {
                hi_gain.gain() + .05 => hi_gain.gain;
            }
            
            hi_pan.pan() + .05 => hi_pan.pan;
        }
        
        //to get eight notes, half the quarter beat
        (quarter_note / 2.0)::second => now;
        
        //counter++;
    }
}

tune_master.gain() => float g;
0 => tune_master.gain;

0 => reverse_hihat.gain;
0 => rnd_base.gain; 
0 => hi_gain.gain;

for (0 => int i; i < 8; i++)
{
    if (i != 2)
    {
        0 => drums[2].pos;
        1 => drums[2].gain;
    }
    
    (quarter_note / 2.0)::second => now;
}

//hold last note and fade
g => tune_master.gain;
scale[tune[0]] => int m_note;
 
Std.mtof(m_note) + .1 => osc1.freq;
Std.mtof(m_note) => osc2.freq;
Std.mtof(m_note) => osc3.freq;

while (tune_master.gain() > 0)
{
    tune_master.gain() - .005 => tune_master.gain;
    (quarter_note / 2.0)::second => now;
}
