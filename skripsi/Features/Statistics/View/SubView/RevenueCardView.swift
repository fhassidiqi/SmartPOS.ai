//
//  RevenueCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 21/10/23.
//

import SwiftUI

struct RevenueCardView: View {

    var title: String
    var currentValue: Int
    var previousValue: Int
    var percentageChange: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(spacing: 3) {
                Text(title)
                    .foregroundStyle(Color.text.primary100)
                    .padding(.trailing, 5)
                
                Text(String(format: "%.2f%%", percentageChange))
                
                Image(systemName: percentageChange > 0.0 ? "arrow.up" : "arrow.down")
                
            }
            .foregroundStyle(percentageChange >= 0.0 ? Color.text.green : Color.red)
            .font(.caption)
            .fontWeight(.semibold)
            
            Text("Rp. \(currentValue)")
                .font(.headline)
            
            Text("Compared to (Rp. \(previousValue) in last month)")
                .font(.caption2)
                .foregroundStyle(Color.text.primary30)
        }
        .frame(width: 140, height: 100)
        .padding()
        .background(Color.background.base)
        .cornerRadius(20)
    }
}
