#include <iostream>
#include <string>
#include "synthesizer.h"

int audioProcessor()
{
    Synthesizer synthesizer;

    //synthesizer.accessAudio(stream); WIP!!!!!!!1

    synthesizer.adjustPitch(targetPitch);
    synthesizer.playSample();

    return 0;
}