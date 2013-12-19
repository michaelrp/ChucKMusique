/*
    Assignment_6_UFO
    drums.ck

    This is slightly longer than 30 seconds, because, well, it
    needed to be. For art!
*/

0.625 => float beat;

//load hihats
SndBuf hihats[3];
JCRev hihat_rev[3];
Gain hihat_gain;

for(0 => int i; i < hihats.cap(); i++)
{
    me.dir(-1) + "/audio/hihat_0" + (i + 1) +".wav" => hihats[i].read;
    hihats[i] => hihat_rev[i] => hihat_gain => dac;
    hihats[i].samples() => hihats[i].pos;
    .01 => hihat_rev[i].mix;
}
.1 => hihat_gain.gain;

//load kick
SndBuf kick => JCRev kick_rev => Gain kick_gain => dac;
me.dir(-1) + "/audio/kick_02.wav" => kick.read;
kick.samples() => kick.pos;
.01 => kick_rev.mix;
.5 => kick_gain.gain;

//load snare
SndBuf snare => JCRev snare_rev => Gain snare_gain => dac;
me.dir(-1) + "/audio/snare_01.wav" => snare.read;
snare.samples() => snare.pos;
.01 => snare_rev.mix;
.3 => snare_gain.gain;

//hihat intro
.2 => hihat_rev[2].mix;
0.2 => hihats[2].gain;
for(0 => int i; i < 16; i++)
{
    Math.random2f(.98, 1.02) => hihats[2].rate;
    hihats[2].gain() + 0.06 => hihats[2].gain;
    0 => hihats[2].pos;
    (beat / 8.0)::second => now;
}
for(0 => int i; i < 24; i++)
{
    Math.random2f(.97, 1.01) => hihats[2].rate;
    hihats[2].gain() - 0.05 => hihats[2].gain;
    0 => hihats[2].pos;
    (beat / 8.0)::second => now;
}
(beat * 2)::second => now;
.01 => hihat_rev[2].mix;

(beat * .5) => beat;

//for(0 => int i; i < 32; i++)
for(0 => int i; i < 48; i++)
{
    // sometimes play the kick
    if(i == 0 || Math.random2(0, 3) == 0)
    {
        Math.random2f(.95, 1.0) => kick.rate;
        Math.random2f(.9, 1.0) => kick.gain;
        0 => kick.pos;
    }
    if(i > 0)
    {
        //don't play hihat on very first beat
        Math.random2f(.98, 1.02) => hihats[0].rate;
        Math.random2f(.7, .8) => hihats[0].gain;
        0 => hihats[0].pos;
    }
    // attempt to play a "swing" rhythm
    (beat * .61)::second => now;
    
    // sometimes play the snare
    if(Math.random2(0, 4) == 0)
    {
        Math.random2f(.95, 1.0) => snare.rate;
        Math.random2f(.6, .9) => snare.gain;
        0 => snare.pos;
    }
    
    // sometimes play the hihat
    if(Math.random2(0, 1) == 0)
    {
        Math.random2f(.98, 1.02) => hihats[1].rate;
        Math.random2f(.5, .6) => hihats[1].gain;
        0 => hihats[1].pos;
    }
    // attempt to play a "swing" rhythm
    (beat * .39)::second => now;
    
    // sometimes play the snare again
    if(Math.random2(0, 4) == 0)
    {
        Math.random2f(.95, 1.0) => snare.rate;
        1.0 => snare.gain;
        0 => snare.pos;
    }
    
    // always play the hihat here
    Math.random2f(.98, 1.02) => hihats[2].rate;
    Math.random2f(.6, .7) => hihats[2].gain;
    0 => hihats[2].pos;
    (beat * .61)::second => now;

    // sometimes play a snare back beat
    if(Math.random2(0, 1) == 0)
    {
        Math.random2f(.95, 1.0) => snare.rate;
        Math.random2f(.6, .9) => snare.gain;
        0 => snare.pos;
    }
    (beat * .39)::second => now;
    
}

// last
0 => hihats[2].pos;
.7 => hihats[2].gain;
.5 => hihat_rev[2].mix;
(beat * 8)::second => now;
