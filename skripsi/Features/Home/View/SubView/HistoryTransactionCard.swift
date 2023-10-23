//
//  HistoryTransactionCard.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct HistoryTransactionCard: View {
    
    @EnvironmentObject private var router: ContentViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text("SHP 030923001")
                    .font(.subheadline).bold()
                    
                
                Text("03 Sep 2023, 10:20 WIB")
                    .font(.caption2)
                    .foregroundStyle(Color.text.primary30)
            }
            Spacer()
            
            Text("Rp. 32.500")
            
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(Color.text.primary100)
        .padding()
        .background(Color.background.base)
        .onTapGesture {
//            router.navigate(routeType: .detail)
        }
    }
}

#Preview {
    HistoryTransactionCard()
}
