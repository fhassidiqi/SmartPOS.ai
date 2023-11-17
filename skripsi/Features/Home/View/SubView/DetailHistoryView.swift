//
//  DetailHistoryView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct DetailHistoryView: View {
    
    var transactionModel: TransactionModel
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            Color.background.primary
                .edgesIgnoringSafeArea(.top)
            VStack(spacing: 5) {
                Text("Total Belanja")
                    .font(.headline)
                    .padding(.top, 25)
                
                Text("\(transactionModel.totalPrice)")
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
                
                ForEach(transactionModel.item) { item in
                    HStack {
                        Text(item.name)
                        
                        Spacer()
                        Spacer()
                        
                        Text("\(item.quantity)")
                        Spacer()
                        
                        Text("Rp. \(transactionModel.subTotal)")
                        Spacer()
                        
                        Text("Rp. \(transactionModel.totalPriceBeforeTax)")
                    }
                    .padding(.vertical, 8)
                }

                
                HStack {
                    Text("Tax 10%")
                    
                    Spacer()
                    
                    Text("Rp. \(transactionModel.tax)")
                }
                
                Spacer()
            }
            .padding(.horizontal)
        }
        .toolbar {
            CustomToolbar(title: "Detail Transaction", leadingTitle: "Home") {
                router.navigateBack()
            }
        }
        .toolbarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .toolbarBackground(.visible, for: .automatic)
        .toolbarBackground(Color.primary100, for: .automatic)
    }
    
    func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}

#Preview {
    DetailHistoryView(transactionModel: TransactionModel(id: "1", orderNumber: "Order Number", date: Date.now, item: [ItemModel(id: "1", name: "Item Name", imageUrl: "imageUrl", description: "Description", category: "Category", omzet: 1, profit: 1, price: 1, discount: 1, quantity: 1, totalOmzetPerItem: 1, totalPricePerItem: 1, totalProfitPerItem: 1)], subTotal: 2, totalPrice: 88000, tax: 8000, cashier: "Falah", totalPriceBeforeTax: 80000))
}
