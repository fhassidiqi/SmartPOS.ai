//
//  Int+Ext.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 12/12/23.
//

import Foundation

extension Int {
    var formattedAsRupiah: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
    
    var formattedAsAbbreviation: String {
        let number = Double(self)
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        
        if number >= 1_000_000 {
            let millionValue = number / 1_000_000
            return "Rp. \(formatter.string(from: NSNumber(value: millionValue)) ?? "\(millionValue)")M"
        } else if number >= 1_000 {
            let thousandValue = number / 1_000
            return "Rp. \(formatter.string(from: NSNumber(value: thousandValue)) ?? "\(thousandValue)")K"
        } else {
            return "Rp. \(self)"
        }
    }
}
