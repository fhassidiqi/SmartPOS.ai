//
//  ReportView.swift
//  skripsi-watch Watch App
//
//  Created by Falah Hasbi Assidiqi on 20/12/23.
//

import SwiftUI

struct ReportView: View {
    
    let title: String
    let current: Int
    let previous: Int
    let percentage: Double

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            HStack(spacing: 3) {
                Text(title)
                    .font(.body)
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                Text(String(format: "%.2f%%", percentage))
                    .font(.caption2)
                    .foregroundColor(.green)
                    .frame(maxWidth: .infinity, alignment: .trailing)
            }
            
            Text("\(current.formattedAsRupiah)")
                .font(.headline)
                .frame(maxWidth: .infinity, alignment: .leading)

            Text("Compared to yesterday (\(previous.formattedAsRupiah))")
                .font(.caption2)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .foregroundStyle(Color.white)
        .background(Color.background.primary)
        .cornerRadius(12)
        .padding()
    }
}

#Preview {
    ReportView(title: "Omzet", current: 5000000, previous: 3000000, percentage: 20.0)
}
