//
//  AudioPermission.swift
//  Komka
//
//  Created by Evelin Evelin on 08/11/22.
//

import Foundation
import AVFoundation

class AudioPermission {
    func requestPermission(){
        switch AVAudioSession.sharedInstance().recordPermission {
            case .granted:
                print("Permission granted")
            case .denied:
                print("Permission denied")
            case .undetermined:
                print("Request permission here")
                AVAudioSession.sharedInstance().requestRecordPermission({ granted in
                    // Handle granted
                })
            @unknown default:
                print("Unknown case")
            }
    }
}
