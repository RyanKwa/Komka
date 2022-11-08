//
//  Asset.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 08/11/22.
//

import Foundation

struct Asset {
    enum Step: String {
        case Cover
        case MultipleChoice
        case FullSentence
        case ArrangeWord
    }
    enum Part: String, CaseIterable {
        case scenarioCover
        case multipleChoiceCharacter
        case leftChoice
        case rightChoice
        case wrongChoice
        case correctChoice
        case fullSentenceCharacter
        case soundPracticeCharacter
        case arrangeWordCharacter
    }
}
