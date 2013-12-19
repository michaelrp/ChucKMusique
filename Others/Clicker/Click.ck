// Click.ck
// Assignment_8_Bells_For_Thee

//use a class definition for multiple click objects
public class Click
{
    0 => int isOn;
    0.98 => float loRate;
    1.02 => float hiRate;
    dur clickBeat;
    
    //set up sound chain for buffer and delay
    SndBuf c => NRev rev => Pan2 c_pan => dac;
    c => Delay d => d => Pan2 d_pan => dac;

    0.2 => d.gain;
    
    //load
    me.dir(-1)+"/audio/click_01.wav" => c.read;
    0.1 => rev.mix;
    c.samples() => c.pos;    
    
    fun void setBeat(dur beat)
    {
        beat => clickBeat;
        (clickBeat / 3) => d.max => d.delay;
    }
    
    //set pans for click and delay
    fun void setPans(float clickPan, float delayPan)
    {
        clickPan => c_pan.pan;
        delayPan => d_pan.pan;
    }
    
    //set range for rate of playback of click sample
    fun void setRateRange(float lo, float hi)
    {
        lo => loRate;
        hi => hiRate;
    }
    
    fun void setDelayGain(float gain)
    {
        gain => d.gain;
    }
    
    fun void setRev(float mix)
    {
        mix => rev.mix;
    }
    
    //start the clicking
    fun void on()
    {
        1 => isOn;
        //sporked when called
        spork ~ playBeats(clickBeat);
    }
    
    //end the clicking
    fun void off()
    {
        0 => isOn;
    }
    
    fun void playSingle()
    {
        0 => c.pos;
        Math.random2f(0.3, 0.4) => c.gain;
        Math.random2f(loRate, hiRate) => c.rate;
    }
    
    //this is sporked, but there is only sound when isOn == 1
    fun void playBeats(dur beat)
    {
        while (isOn == 1)
        {
            0 => c.pos;
            Math.random2f(0.3, 0.4) => c.gain;
            Math.random2f(loRate, hiRate) => c.rate;
            (clickBeat / Math.random2(1,3)) => now;
        }
    }
}