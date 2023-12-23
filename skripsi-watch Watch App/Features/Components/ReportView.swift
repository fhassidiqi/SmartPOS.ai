//
//  ReportView.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import SwiftUI

struct ReportView: View {
    
    let title: String
    let current: String
    let previous: String
    let percentage: Double
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            Text(title)
                .font(.body)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            HStack (spacing: 3) {
                Text(current)
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                HStack (spacing: 0) {
                    Text(String(format: "%.2f%%", percentage))
                    
                    Image(systemName: percentage > 0.0 ? "arrow.up" : "arrow.down")
                }
                .font(.caption2)
                .foregroundStyle(percentage >= 0.0 ? Color.green : Color.red)
            }
            
            Text("Compared to yesterday (\(previous))")
                .font(.caption2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.gray)
        .cornerRadius(12)
        .padding()
    }
}

#Preview {
    ReportView(title: "Omzet", current: "5000000", previous: "3000000", percentage: 20.0)
}
