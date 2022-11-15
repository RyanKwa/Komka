//
//  ArrangeWordTestCase.swift
//  KomkaTests
//
//  Created by Ryan Vieri Kwa on 26/10/22.
//

import XCTest
import RxCocoaRuntime
@testable import Komka
final class ArrangeWordTestCase: XCTestCase {
    let sut = ArrangeWordViewModel()

    func testSelectWord_whenPlacedToSlot_answerIsCorrect() {
        let selectedWord = "Saya"
        let placementIndex = 0
        let sentences = ["Saya", "makan"]
        
        let result = sut.evaluateWordPlacement(selectedWord: selectedWord, placementIndex: placementIndex, sentences: sentences)
        
        XCTAssertTrue(result)
    }

    func testSelectWord_whenPlacedToSlot_answerIsIncorrect() {
        let selectedWord = "Saya"
        let placementIndex = 1
        let sentences = ["Saya", "makan"]

        let result = sut.evaluateWordPlacement(selectedWord: selectedWord, placementIndex: placementIndex, sentences: sentences)
        
        XCTAssertFalse(result)
    }
    
    func testSelectWord_whenPlacedToSlot_indexIsGreaterThanArraySentenceSize_returnFalse() {
        let selectedWord = "Saya"
        let placementIndex = 3
        let sentences = ["Saya", "makan"]
        
        let result = sut.evaluateWordPlacement(selectedWord: selectedWord, placementIndex: placementIndex, sentences: sentences)
        
        XCTAssertFalse(result)
    }
    
    func testSelectWord_whenPlacedToSlot_indexIsSmallerThanZero_returnFalse() {
        let selectedWord = "Saya"
        let placementIndex = -1
        let sentences = ["Saya", "makan"]
        
        let result = sut.evaluateWordPlacement(selectedWord: selectedWord, placementIndex: placementIndex, sentences: sentences)
        
        XCTAssertFalse(result)
    }
}
