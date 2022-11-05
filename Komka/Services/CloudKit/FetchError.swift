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

    /// Retrieve error for user feedback
    var localizedDescription: String {
        switch self {
        case .failedQuery(_):
            return "Gagal mengambil data, pastikan sudah terhubung dengan jaringan internet"
        
        case .missingData(_):
            return "Terdapat masalah pada data"
        }
    }

    /// Retrieve error  for debugging
    var description: String {
        switch self {
        case .failedQuery(let recordType):
            return "Query for \(recordType.rawValue) record has failed"
        
        case .missingData(let recordType):
            return "One or more data of \(recordType.rawValue) record is missing"
        }
        
    }
    
}
