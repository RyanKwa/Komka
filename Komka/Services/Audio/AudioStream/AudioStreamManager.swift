//
//  AudioStreamManager.swift
//  Komka
//
//  Created by Evelin Evelin on 07/11/22.
//

import AVFoundation
import Foundation
import SoundAnalysis

class AudioStreamManager {
    private var audioEngine: AVAudioEngine?
    private var inputBus: AVAudioNodeBus?
    private var micInputFormat: AVAudioFormat?
    
    private var soundAnalyzer: SNAudioStreamAnalyzer?
    private var soundClassifierRequest: SNClassifySoundRequest?

    init(){
        audioEngine = AVAudioEngine()
        inputBus = AVAudioNodeBus(0)
        
        guard let inputBus = inputBus else {
            print("ERROR: Input bus unavailable")
            return
        }
        
        micInputFormat = audioEngine?.inputNode.inputFormat(forBus: inputBus)
        
        guard let micInputFormat = micInputFormat else {
            print("ERROR: Mic input format unavailable")
            return
        }
        
        prepareAudioEngine()
        
        soundAnalyzer = SNAudioStreamAnalyzer(format: micInputFormat)
        
        
        prepareSoundClassifier()
    }
    
    private func prepareAudioEngine(){
        guard let audioEngine = audioEngine else {
            print("ERROR: AudioEngine Unavailable")
            return
        }
        do{
            try audioEngine.start()
        }
        catch{
            print("ERROR: \(error.localizedDescription)")
        }
    }
    
    func startLiveAudio(){
        guard let audioEngine = audioEngine else {
            print("ERROR: AudioEngine Unavailable")
            return
        }
        guard let inputBus = inputBus else {
            print("ERROR: Input bus unavailable")
            return
        }
        guard let micInputFormat = micInputFormat else {
            print("ERROR: Mic input format unavailable")
            return
        }
        
        audioEngine.inputNode.removeTap(onBus: inputBus)
        audioEngine.inputNode.installTap(onBus: inputBus, bufferSize: 1024, format: micInputFormat) {
            [unowned self] (buffer, time) in
            DispatchQueue.global(qos: .userInitiated).async {
                self.soundAnalyzer?.analyze(buffer, atAudioFramePosition: time.sampleTime)
            }
        }
    }
    
    func stopLiveAudio(){
        guard let audioEngine = audioEngine else {
            print("ERROR: AudioEngine Unavailable")
            return
        }
        guard let inputBus = inputBus else {
            print("ERROR: Input bus unavailable")
            return
        }
        audioEngine.inputNode.removeTap(onBus: inputBus)
    }
    
    private func prepareSoundClassifier(){
        let config = MLModelConfiguration()
        let soundClassifier = try? SoundPracticeModel(configuration: config)
        
        guard let soundClassifier = soundClassifier else{
            print("ERROR: Model doesn't Exist")
            return
        }
        soundClassifierRequest = try? SNClassifySoundRequest(mlModel: soundClassifier.model)
    }
    
    func addResultObservation(with observer: SNResultsObserving) {
        guard let soundClassifierRequest = soundClassifierRequest else {
            print("ERROR: Sound Classification Request unavailable")
            return
        }
        guard let soundAnalyzer = soundAnalyzer else {
            print("ERROR: Sound Analyzer unavailable")
            return
        }
        
        do {
            try soundAnalyzer.add(soundClassifierRequest, withObserver: observer)
        }
        catch {
            print("ERROR: observer for the sound classification results: \(error.localizedDescription)")
        }
        
    }
}

