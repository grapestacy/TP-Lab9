//
//  NSObject.swift
//  BelarussianWriters
//
//  Created by Stacy Vinogradova on 29.04.21.
//

import Foundation
extension NSObject {

    var className: String {
        return String(describing: type(of: self))
    }

    class var className: String {
        return String(describing: self)
    }
}
