//
//  HistoryTransactionCard.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct HistoryTransactionCard: View {
    
    var transactionModel: TransactionModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 3) {
                Text(transactionModel.orderNumber)
                    .font(.subheadline).bold()
                
                
                Text(transactionModel.date.formatDateMedium)
                    .font(.caption2)
                    .foregroundStyle(Color.text.primary30)
            }
            Spacer()
            
            Text(transactionModel.totalTransaction.formattedAsRupiah)
            
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(Color.text.primary100)
        .padding()
        .background(Color.background.base)
        .cornerRadius(8)
    }
}

