//
//  DetailHistoryView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 15/10/23.
//

import SwiftUI

struct DetailHistoryView: View {
    
    var transactionModel: TransactionModel
    var itemTransactionModel: ItemTransactionModel?
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            Color.background.primary
                .edgesIgnoringSafeArea(.top)
            VStack(spacing: 5) {
                
                titleSection("Total Belanja", content: Text("\(transactionModel.totalTransaction)")
                    .font(.title)
                    .fontWeight(.semibold)
                )
                
                Divider()
                    .padding(.vertical)
                
                orderInformation("Order Number", text: transactionModel.orderNumber)
                orderInformation("Order Date", text: transactionModel.date.formatDateShort)
                
                Divider()
                    .padding([.vertical, .bottom])
                
                ForEach(transactionModel.items, id: \.item.id) { itemTransaction in
                    itemInformation(itemTransaction)
                }
                
                
                HStack {
                    Text("Tax 10%")
                    
                    Spacer()
                    
                    Text("\(transactionModel.tax)")
                }
                .font(.subheadline)
                
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
    
    private func itemInformation(_ itemTransactionModel: ItemTransactionModel) -> some View {
        
        HStack {
            
            Text("\(itemTransactionModel.item.name)")
                .frame(maxWidth: 160, alignment: .leading)
            
            Spacer()
            
            Text("\(itemTransactionModel.quantity)")
                .frame(maxWidth: 30, alignment: .center)
            
            Spacer()
            
            Text("\(itemTransactionModel.item.price)")
                .frame(maxWidth: 70, alignment: .trailing)
            
            Spacer()
            
            Text("\(itemTransactionModel.totalPricePerItem)")
                .frame(maxWidth: 80, alignment: .trailing)
                
        }
        .foregroundStyle(Color.text.primary100)
        .font(.subheadline)
        .padding(.bottom, 10)
    }
}
