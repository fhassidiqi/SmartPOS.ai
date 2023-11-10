//
//  DetailHistoryView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct DetailHistoryView: View {
    
    @EnvironmentObject private var router: ContentViewModel
    var transactionModel: TransactionModel
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.background.primary
                    .edgesIgnoringSafeArea(.top)
                VStack(spacing: 5) {
                    Text("Total Belanja")
                        .font(.headline)
                        .padding(.top, 25)
                    
                    Text("\(transactionModel.amount)")
                        .font(.title)
                        .fontWeight(.semibold)
                    
                    Divider()
                        .padding(.vertical)
                    
                    HStack {
                        Text("Order Number")
                            .foregroundStyle(Color.text.primary30)
                        
                        Spacer()
                        
                        Text(transactionModel.orderNumber)
                            .foregroundStyle(Color.text.primary100)
                    }
                    .font(.subheadline)
                    
                    HStack {
                        Text("Order Date")
                            .foregroundStyle(Color.text.primary30)
                        
                        Spacer()
                        
                        Text(formatDate(transactionModel.date))
                            .foregroundStyle(Color.text.primary100)
                    }
                    .font(.subheadline)
                    
                    Divider()
                        .padding(.vertical)
                    
                    ForEach(0..<5) { item in
                        ItemCardView()
                    }
                    
                    Spacer()
                }
                .padding(.horizontal)
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Detail Transaction")
                        .font(.headline)
                        .foregroundStyle(Color.text.white)
                }
            }
            .toolbarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .automatic)
            .toolbarBackground(Color.primary100, for: .automatic)
        }
    }
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

#Preview {
    DetailHistoryView(transactionModel: TransactionModel(id: "1", orderNumber: "Order Number", date: Date.now, item: [ItemModel(id: "1", name: "Item Name", imageUrl: "imageUrl", description: "Description", category: "Category", omzet: 1, profit: 1, price: 1, quantity: 1, totalPrice: 120000, discount: 1)], amount: 120000, cashier: "Falah"))
}
