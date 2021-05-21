//
//  String.swift
//  BelarussianWriters
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import Foundation

private let caseByCaseRegex = try! NSRegularExpression(pattern: "\\[\\[.*?]]", options: .caseInsensitive)

public extension String {
    
    var localized: String {
        let string = NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
        return caseByCaseRegex.stringByReplacingMatches(in: string,
                                                        options: [],
                                                        range: NSRange(location: 0, length:  string.count),
                                                        withTemplate: "")
    }
}
