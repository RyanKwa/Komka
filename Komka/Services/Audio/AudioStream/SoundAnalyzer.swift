//
//  SoundAnalyzer.swift
//  Komka
//
//  Created by Evelin Evelin on 08/11/22.
//

import Foundation

import Foundation
import SoundAnalysis

class SoundAnalyzer: NSObject, ObservableObject, SNResultsObserving {    
    var confidence: Double?

    func request(_ request: SNRequest, didProduce result: SNResult) {
        guard let result = result as? SNClassificationResult else{
            return
        }
        
        guard let highestResult = result.classifications.first else{
            return
        }
        
        DispatchQueue.main.async {
            self.confidence = highestResult.confidence
        }
    }
    
}
