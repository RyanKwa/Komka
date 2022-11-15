//
//  CompletionPageViewModel.swift
//  Komka
//
//  Created by Evelin Evelin on 14/11/22.
//

import Foundation
 
class CompletionPageViewModel {
    func updateIsCompletedToKeyValueStore() {
        NSUbiquitousKeyValueStore.default.isCompleted += 1
    }
}
