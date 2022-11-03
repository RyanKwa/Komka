//
//  SoundEffectService.swift
//  Komka
//
//  Created by Minawati on 23/10/22.
//

import Foundation
import AVFoundation

class SoundEffectService {
    enum SoundEffect: String, CaseIterable {
        case Bubble
        case CompletionPage
        case Correct
        case Incorrect
    }
    
    static let shared = SoundEffectService()
    
    var player: AVAudioPlayer = AVAudioPlayer()
    
    func playSoundEffect(_ soundEffect: SoundEffect){
        guard let url = Bundle.main.url(forResource: soundEffect.rawValue, withExtension: "mp3") else { return }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}
