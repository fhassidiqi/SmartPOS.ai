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
                
                
                Text(formatDate(transactionModel.date))
                    .font(.caption2)
                    .foregroundStyle(Color.text.primary30)
            }
            Spacer()
            
            Text("\(transactionModel.amount)")
            
            Image(systemName: "chevron.right")
        }
        .foregroundStyle(Color.text.primary100)
        .padding()
        .background(Color.background.base)
        .cornerRadius(8)
    }
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

#Preview {
    HistoryTransactionCard(transactionModel: TransactionModel(id: "1", orderNumber: "Order Number", date: Date.now, item: [ItemModel(id: "1", name: "Item Name", imageUrl: "imageUrl", description: "Description", category: "Category", omzet: 1, profit: 1, price: 1, discount: 1)], quantity: 2, totalPrice: 80000, amount: 80000, cashier: "Falah"))
}
