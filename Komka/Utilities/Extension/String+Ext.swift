//
//  String+Ext.swift
//  Komka
//
//  Created by Minawati on 09/11/22.
//

import Foundation

extension String {
    static func convertArrayToString(array: [String]) -> String {
        let string = array.joined(separator: " ")
        return string
    }
}
