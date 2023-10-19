//
//  HistoryTransactionCard.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct HistoryTransactionCard: View {
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("SHP 030923001")
                    .font(.subheadline).bold()
                    .foregroundStyle(Color.text.primary100)
                
                Text("03 Sep 2023, 10:20 WIB")
                    .font(.caption2)
                    .foregroundStyle(Color.text.primary30)
            }
            Spacer()
            
            HStack {
                Text("Rp. 32.500")
                
                Button(action: {
                    
                }, label: {
                    Image(systemName: "chevron.right")
                })
            }
            .foregroundStyle(Color.text.primary100)
        }
        .padding()
        .background(Color.backgroundBase)
    }
}

#Preview {
    HistoryTransactionCard()
}
