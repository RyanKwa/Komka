//
//  SoundAnalyzer.swift
//  Komka
//
//  Created by Evelin Evelin on 08/11/22.
//

import Foundation

import Foundation
import SoundAnalysis
import RxSwift

class SoundAnalyzer: NSObject, ObservableObject, SNResultsObserving {    
    var confidence: Double?
    var confidencePublisher = PublishSubject<Double>()
    
    var currentWord: String = ""
        
    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else{
            return
        }
        
        guard let highestResult = result.classifications.first else{
            return
        }
        
        DispatchQueue.main.async {
            if(self.currentWord == highestResult.identifier){
                self.confidence = highestResult.confidence
                self.confidencePublisher.onNext(self.confidence ?? 0)
            }
        }
    }
    
}
