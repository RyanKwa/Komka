//
//  ChooseGenderViewModel.swift
//  Komka
//
//  Created by Minawati on 11/10/22.
//

import Foundation

class ChooseGenderViewModel {
    
    func addGenderToKeyValueStore(gender: String){
        if !gender.isEmpty {
            NSUbiquitousKeyValueStore.default.hasChooseGender = gender
        }
    }
}
