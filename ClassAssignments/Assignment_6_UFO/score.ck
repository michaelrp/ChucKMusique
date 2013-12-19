/*
    Assignment_6_UFO
    score.ck

    This is slightly longer than 30 seconds, because, well, it
    needed to be. For art!
*/

0.625 => float beat;

// load files
me.dir() + "/drums.ck" => string drumsFile;
me.dir() + "/bass.ck" => string bassFile;
me.dir() + "/trumpet.ck" => string trumpetFile;
me.dir() + "/ufo.ck" => string ufoFile;

// spork some instruments

// spork the drums
Machine.add(drumsFile) => int drums_intro_ID;

// let the drums intro play
(beat * 7)::second => now;

// spork the bass
Machine.add(bassFile);

(beat * 4)::second => now;

// spork the trumpet;
Machine.add(trumpetFile);

(beat * 12)::second => now;

// and now spork the UFO!
Machine.add(ufoFile);
