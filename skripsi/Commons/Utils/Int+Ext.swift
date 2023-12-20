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
}
