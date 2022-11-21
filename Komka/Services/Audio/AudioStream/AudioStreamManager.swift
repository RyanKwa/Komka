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
    private var micInputFormat: AVAudioFormat?
    
    private var soundAnalyzer: SNAudioStreamAnalyzer?
    private var soundClassifierRequest: SNClassifySoundRequest?
    
    init(){

    }
    
    func stopAudioSession() {
        let audioSession = AVAudioSession.sharedInstance()
        try? audioSession.setActive(false)
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
    
    func startLiveRecord(){
        stopLiveRecord()
        stopAudioSession()
        do {
            let audioSession = AVAudioSession.sharedInstance()
            try audioSession.setCategory(.record, options: .mixWithOthers)
            try audioSession.setActive(true)
        } catch {
            stopAudioSession()
            print("ERROR: Stop Live record")
        }
        do{
            let newAudioEngine = AVAudioEngine()
            audioEngine = newAudioEngine
            let busIndex = AVAudioNodeBus(0)
            let audioFormat = newAudioEngine.inputNode.inputFormat(forBus: busIndex)
            let newSoundAnalyzer = SNAudioStreamAnalyzer(format: audioFormat)
            soundAnalyzer = newSoundAnalyzer
            
            newAudioEngine.inputNode.removeTap(onBus: busIndex)
            newAudioEngine.inputNode.installTap(onBus: busIndex, bufferSize: 1024, format: audioFormat) {
                (buffer, time) in
                DispatchQueue.main.async {
                    newSoundAnalyzer.analyze(buffer, atAudioFramePosition: time.sampleTime)
                }
            }
            try newAudioEngine.start()
            prepareSoundClassifier()
        }
        catch {
           print("ERROR: \(error)")
        }
    }
    
    func stopLiveRecord(){
        guard let audioEngine = audioEngine else {
            print("ERROR: AudioEngine Unavailable")
            return
        }
        audioEngine.inputNode.removeTap(onBus: 0)
        stopAudioSession()
    }
    
    private func prepareSoundClassifier(){
        let config = MLModelConfiguration()
        let soundClassifier = try? SoundPracticeModel_Rev(configuration: config)
        
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
