//use global tempo
BPM tempo;
tempo.setTempo(0.625);

200 => float loFreq;
50 => float freqDist;

0 => int LEFT;
1 => int RIGHT;
2 => int CENTER;
3 => int LEFT_CENTER;
4 => int RIGHT_CENTER;

// load click objects into array

Click clicks[5];

clicks[LEFT].setBeat(tempo.quarterNote);
clicks[LEFT].setPans(-0.9, -1.0);
clicks[LEFT].setRateRange(0.48, 0.52);

clicks[RIGHT].setBeat(tempo.quarterNote);
clicks[RIGHT].setPans(0.9, 1.0);
clicks[RIGHT].setRateRange(1.48, 1.52);

clicks[CENTER].setBeat(tempo.quarterNote);
clicks[CENTER].setPans(-0.1, 0.1);
clicks[CENTER].setRateRange(0.98, 1.02);

clicks[LEFT_CENTER].setBeat(tempo.quarterNote);
clicks[LEFT_CENTER].setPans(-0.45, -0.55);
clicks[LEFT_CENTER].setRateRange(1.23, 1.27);

clicks[RIGHT_CENTER].setBeat(tempo.quarterNote);
clicks[RIGHT_CENTER].setPans(0.45, 0.55);
clicks[RIGHT_CENTER].setRateRange(0.73, 0.77);

// helper function to play all clicks together
fun void playAllSingle()
{
    for (0 => int i; i < clicks.cap(); i++)
    {
        clicks[i].playSingle();
    }
}

// turn on all clickers in array
fun void allOn()
{
    for (0 => int i; i < clicks.cap(); i++)
    {
        clicks[i].on();
    }
}

// turn off all clickers in array
fun void allOff()
{
    for (0 => int i; i < clicks.cap(); i++)
    {
        clicks[i].off();
    }
}

fun void setAllDelayGain(float gain)
{
    for (0 => int i; i < clicks.cap(); i++)
    {
        clicks[i].setDelayGain(gain);
    }
}

playAllSingle();
tempo.quarterNote * 2 => now;

playAllSingle();
tempo.quarterNote * 3 => now;

// play left
clicks[LEFT].on();

tempo.quarterNote * 8 => now;

// introduce right
clicks[RIGHT].playSingle();
tempo.quarterNote * 2 => now;

// play right
clicks[RIGHT].on();

tempo.quarterNote * 8 => now;

// introduce center
clicks[CENTER].playSingle();
tempo.quarterNote * 2 => now;

// play center
clicks[CENTER].on();

tempo.quarterNote * 8 => now;

allOff();

// four single notes from all
for (0 => int i; i < 4; i++)
{
    playAllSingle();
    tempo.eighthNote => now;
}

// play mids
clicks[RIGHT_CENTER].on();
clicks[LEFT_CENTER].on();

tempo.quarterNote * 8 => now;

allOff();

// four single notes from all
for (0 => int i; i < 4; i++)
{
    playAllSingle();
    tempo.eighthNote => now;
}

// all play
allOn();

tempo.quarterNote * 4 => now;

allOff();

// four single notes from all
for (0 => int i; i < 4; i++)
{
    playAllSingle();
    tempo.eighthNote => now;
}

allOn();

// play all
tempo.quarterNote * 16 => now;

allOff();

tempo.quarterNote => now;

// four single notes from all
for (0 => int i; i < 4; i++)
{
    playAllSingle();
    tempo.eighthNote => now;
}

tempo.quarterNote => now;

// four single notes from all
for (0 => int i; i < 5; i++)
{
    playAllSingle();
    tempo.eighthNote => now;
}

tempo.quarterNote * 2 => now;