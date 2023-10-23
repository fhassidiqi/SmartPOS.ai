//
//  OmzetCardView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 21/10/23.
//

import SwiftUI

struct OmzetCardView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 3) {
                Text("Omzet")
                    .foregroundStyle(Color.text.primary100)
                    .padding(.trailing, 5)
                
                Text("+2.5%")
                
                Image(systemName: "arrow.up")
                
            }
            .foregroundStyle(Color.text.green)
            .font(.caption)
            .fontWeight(.semibold)
            
            Text("Rp. 4.000.000")
                .font(.headline)
            
            Text("Compared to (Rp. 3,92jt in last month)")
                .font(.caption2)
                .foregroundStyle(Color.text.primary30)
        }
        .frame(width: 140, height: 100)
        .padding()
        .background(Color.background.base)
        .cornerRadius(20)
    }
}

#Preview {
    OmzetCardView()
}
