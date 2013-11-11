// Assignment_1_Beat_Box

SinOsc s => dac;
SinOsc t => dac;
SinOsc u => dac;
SinOsc v => dac;
SinOsc w => dac;

300 => float s_freq;
300 => float t_freq;

0 => w.gain;
50 => w.freq;

.2 => s.gain;
.2 => t.gain;
0 => u.gain;
0 => v.gain;

s_freq => s.freq;
t_freq => t.freq;

// start s and t together
1::second => now;

// slowly move t osc up
for (0 => int i; i < 50; i++)
{
    t_freq + 1 => t_freq;
    t_freq => t.freq;
    
    100::ms => now;
}

// hold interval
.5::second => now;

// add v osc to current t freq
// with short fade in to avoid popping
t_freq => float v_freq;
v_freq => v.freq;

0 => float v_gain;
while (v_gain < 0.2)
{
    v_gain + 0.01 => v_gain;
    v_gain => v.gain;
    
    10::ms => now;
}

// slowly drop t osc (leaving v osc)
for (0 => int i; i < 50; i++)
{
    t_freq - 1 => t_freq;
    t_freq => t.freq;
    
    // add "quiet" low sound
    if (i == 10)
    {
        .2 => w.gain;
    }
    
    100::ms => now;
}

// hold interval
1::second => now;

// this time drop s
for (0 => int i; i < 50; i++)
{
    s_freq - 1 => s_freq;
    s_freq => s.freq;
    
    100::ms => now;
}

// add u osc to current s freq
// with short fade in to avoid popping
0 => float u_gain;
s_freq => float u_freq;
u_freq => u.freq;
while (u_gain < 0.2)
{
    u_gain + 0.01 => u_gain;
    u_gain => u.gain;
    
    10::ms => now;
}

// return s freq to start
for (0 => int i; i < 50; i++)
{
    s_freq + 1 => s_freq;
    s_freq => s.freq;
    
    100::ms => now;
}

// hold
1::second => now;

// bring u and v back to starting freq
// slowing the transition back ever so
// slightly
for (0 => int i; i < 50; i++)
{
    v_freq - 1 => v_freq;
    u_freq + 1 => u_freq;
    
    v_freq => v.freq;
    u_freq => u.freq;
    
    120::ms => now;
}

// hold
1::second => now;

// fade all
while (v_gain > 0)
{
    v_gain - 0.001 => v_gain;
    v_gain => s.gain;
    v_gain => t.gain;
    v_gain => u.gain;
    v_gain => v.gain;
    v_gain => w.gain;
    
    10::ms => now;
}
