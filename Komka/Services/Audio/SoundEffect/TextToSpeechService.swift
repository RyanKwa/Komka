//
//  TextToSpeechService.swift
//  Komka
//
//  Created by Minawati on 13/10/22.
//

import Foundation
import AVFoundation

class TextToSpeechService {    
    let speechSynthesizer = AVSpeechSynthesizer()
    
    func startSpeech(_ queue: [String]){
        
        var utterance: AVSpeechUtterance
        
        for text in queue {
            utterance = AVSpeechUtterance(string: text)
            utterance.rate = 0.4
            utterance.volume = 1
            utterance.preUtteranceDelay = 0.2
            utterance.postUtteranceDelay = 0.4
            utterance.voice = AVSpeechSynthesisVoice(language: "id-ID")
            speechSynthesizer.speak(utterance)
        }
    }
    
    func stopSpeech() {
        speechSynthesizer.stopSpeaking(at: .immediate)
    }
}
