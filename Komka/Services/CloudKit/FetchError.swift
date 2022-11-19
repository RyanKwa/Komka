//
//  FetchError.swift
//  Komka
//
//  Created by Ryan Vieri Kwa on 31/10/22.
//

import Foundation

enum FetchError: Error, CustomStringConvertible {
    
    case failedQuery(recordType: RecordType)
    case missingData(recordType: RecordType)

    /// Retrieve error descriptoinn for user feedback
    var localizedDescription: String {
        switch self {
        case .failedQuery(_):
            return "Maaf, tidak ada koneksi internet."
        
        case .missingData(_):
            return "Terdapat masalah pada data"
        }
    }
    
    /// Retrieve error title for user feedback
    var errorTitle: String {
        switch self {
        case .failedQuery(_):
            return "Jaringan gagal . . ."
        case .missingData(_):
            return "Missing Data . . ."
        }
    }

    /// Retrieve error guidnce for user feedback
    var errorGuidance: String {
        switch self {
        case .failedQuery(_):
            return "Silahkan cek koneksi internet dan coba lagi"
        
        case .missingData(_):
            return "Silahkan cek koneksi internet dan coba lagi"
        }
    }
    
    /// Retrieve error description for debugging
    var description: String {
        switch self {
        case .failedQuery(let recordType):
            return "Query for \(recordType.rawValue) record has failed"
        
        case .missingData(let recordType):
            return "One or more data of \(recordType.rawValue) record is missing"
        }
        
    }
    
}
