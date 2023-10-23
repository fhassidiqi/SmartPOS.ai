//
//  Date+Ext.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 21/10/23.
//

import Foundation
import SwiftUI

extension Date {
    static func from(year: Int, month: Int, day: Int) -> Date {
        let components = DateComponents(year: year, month: month, day: day)
        
        return Calendar.current.date(from: components)!
    }
}
