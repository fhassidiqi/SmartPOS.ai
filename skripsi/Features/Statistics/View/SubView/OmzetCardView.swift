//
//  RevenueCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 21/10/23.
//

import SwiftUI

struct RevenueCardView: View {
    
    var title: String
    var value: Int
    var previousMonthValue: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            let (percentageChange, formattedPercentage) = calculateAndFormatPercentage(currentValue: value, previousValue: previousMonthValue)
            
            HStack(spacing: 3) {
                Text(title)
                    .foregroundStyle(Color.text.primary100)
                    .padding(.trailing, 5)
                
                Text(formattedPercentage)
                
                Image(systemName: percentageChange > 0 ? "arrow.up" : "arrow.down")
                
            }
            .foregroundStyle(percentageChange >= 0 ? Color.text.green : Color.red)
            .font(.caption)
            .fontWeight(.semibold)
            
            Text("Rp. \(value)")
                .font(.headline)
            
            Text("Compared to (Rp. \(previousMonthValue) in last month)")
                .font(.caption2)
                .foregroundStyle(Color.text.primary30)
        }
        .frame(width: 140, height: 100)
        .padding()
        .background(Color.background.base)
        .cornerRadius(20)
    }
    
    private func calculateAndFormatPercentage(currentValue: Int, previousValue: Int) -> (Double, String) {
        guard previousValue != 0 else {
            return (0.0, "0.00%")
        }
        
        let percentageChange = Double(currentValue - previousValue) / Double(previousValue) * 100.0
        let formattedPercentage = formatPercentage(percentageChange)
        
        return (percentageChange, formattedPercentage)
    }
    
    private func formatPercentage(_ percentage: Double) -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .percent
        numberFormatter.minimumFractionDigits = 2
        numberFormatter.maximumFractionDigits = 2
        
        return numberFormatter.string(from: NSNumber(value: percentage / 100.0)) ?? ""
    }
}
