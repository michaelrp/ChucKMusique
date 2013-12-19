public class BPM
{
    // global variables
    static dur quarterNote, eighthNote, sixteenthNote, thirtysecondNote;
    
    fun void setTempo(float quarter)  {
        // beat is BPM
        
        quarter::second => quarterNote;
        
        quarterNote * 0.5 => eighthNote;
        eighthNote * 0.5 => sixteenthNote;
        sixteenthNote * 0.5 => thirtysecondNote;
    }
}