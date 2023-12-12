//
//  Double+Ext.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 12/12/23.
//

import Foundation

extension Int {
    func formatAsCurrency() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .currency
        numberFormatter.minimumFractionDigits = 0
        numberFormatter.maximumFractionDigits = 0

        // Assuming the currency is IDR (Indonesian Rupiah)
        numberFormatter.currencyCode = "IDR"

        return numberFormatter.string(from: NSNumber(value: self)) ?? ""
    }
}
