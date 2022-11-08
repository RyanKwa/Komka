//
//  SoundPracticeViewModel.swift
//  Komka
//
//  Created by Evelin Evelin on 07/11/22.
//

import Foundation
import RxSwift

class SoundPracticeViewModel {
    lazy var queueWordCounter: Int = 1
    private (set) lazy var progressFrom = setProgressFrom()
    private (set) lazy var progressTo = setProgressTo()
    
    var audioStreamManager = AudioStreamManager()
    
    var progressPublisher = BehaviorSubject(value: 0.0)
    var audioPublisher = PublishSubject<Double>()
    
    var disposeBag = DisposeBag()
    
    lazy var result = Double()
    
    func setProgressTo() -> Double{
        lazy var tempVar = 0.1
//        audioPublisher.subscribe(onNext: { [self] confidence in
            result = (tempVar * 35.0)/100.0
            
            if result <= 0.0 {
                result = 0.0
            }
            else if result < 0.15 {
                result = 0.15
            }
//        }).disposed(by: disposeBag)

        progressPublisher.onNext(result)
        return result
    }
    
    func setProgressFrom() -> Double{
        progressPublisher.subscribe(onNext: { [self] result in
            progressFrom = result
            print(progressFrom)
            
        }).disposed(by: disposeBag)
        
        return progressFrom
    }
    
    func startSoundPractice(){
        audioStreamManager.startLiveAudio()
        
        //logic dmn, bakal kirim confidence terus menerus (mgkin bisa via publisher, utk trigger si setProgressTo)?
        var confidence = 0.2
        audioPublisher.onNext(confidence)
    }
    
    func stopSoundPractice(){
        audioStreamManager.stopLiveAudio()
    }
    
}
