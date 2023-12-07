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
    
    func getMonthAndYear() -> (month: Int, year: Int) {
        let calendar = Calendar.current
        let currentMonth = calendar.component(.month, from: self)
        let currentYear = calendar.component(.year, from: self)
        return (month: currentMonth, year: currentYear)
    }
    
    func getPreviousMonthAndYear() -> (month: Int, year: Int) {
        let calendar = Calendar.current
        let oneMonthAgo = calendar.date(byAdding: .month, value: -1, to: self)!
        let previousMonth = calendar.component(.month, from: oneMonthAgo)
        let previousYear = calendar.component(.year, from: oneMonthAgo)
        return (month: previousMonth, year: previousYear)
    }
    
    func formatMonthAsString(_ month: Int) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.monthSymbols[month - 1]
    }
}
