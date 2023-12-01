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
                
                titleSection("Total Belanja", content: Text("\(transactionModel.totalPrice)")
                        .font(.title)
                        .fontWeight(.semibold)
                )
                
                Divider()
                    .padding(.vertical)
                
                orderInformation("Order Number", text: transactionModel.orderNumber)
                orderInformation("Order Date", text: formatDate(transactionModel.date))
                
                Divider()
                    .padding(.vertical)
                
                ForEach(transactionModel.item) { item in
                    itemRow(item)
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
    
}

#Preview {
    DetailHistoryView(transactionModel: TransactionModel(id: "1", orderNumber: "Order Number", date: Date.now, item: [ItemModel(id: "1", name: "Item Name", imageUrl: "imageUrl", description: "Description", category: "Category", omzet: 1, profit: 1, price: 1, discount: 1, quantity: 1, totalOmzetPerItem: 1, totalPricePerItem: 1, totalProfitPerItem: 1)], subTotal: 2, totalPrice: 88000, tax: 8000, cashier: "Falah", totalPriceBeforeTax: 80000))
}

extension DetailHistoryView {
    private func titleSection(_ title: String, content: Text) -> some View {
        VStack(spacing: 5) {
            Text(title).font(.headline).padding(.top, 25)
            content
        }
    }
    
    private func orderInformation(_ key: String, text: String) -> some View {
        HStack {
            Text(key)
                .foregroundStyle(Color.text.primary30)
            Spacer()
            Text(text)
                .foregroundStyle(Color.text.primary100)
        }
        .font(.subheadline)
    }
    
    private func itemRow(_ item: ItemModel) -> some View {
        HStack {
            Text(item.name)
            Spacer()
            Spacer()
            
            Text("\(item.quantity)")
            Spacer()
            
            Text("Rp. \(item.price)")
            Spacer()
            
            Text("Rp. \(transactionModel.totalPriceBeforeTax)")
        }
        .padding(.bottom, 8)
    }
    
    private func formatDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        return dateFormatter.string(from: date)
    }
}
