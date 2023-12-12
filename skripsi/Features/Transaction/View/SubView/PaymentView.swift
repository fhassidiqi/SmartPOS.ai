//
//  PaymentView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 12/11/23.
//

import SwiftUI

struct PaymentView: View {
    
    @EnvironmentObject private var router: Router
    var itemTransaction: [ItemTransactionModel]
    @State private var isActive = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.background.primary
                .ignoresSafeArea()
            
            ScrollView {
                itemSection
            }
        }
        .toolbar {
            CustomToolbar(title: "Pay", leadingTitle: "Food List") {
                router.navigateBack()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .automatic)
        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.primary100, for: .automatic)
    }
    
    private var itemSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Item")
                .font(.headline)
                .padding()
            
            Divider()
            
            ForEach(itemTransaction, id: \.item) { selectedItem in
                ItemFoodCardView(itemModel: selectedItem.item, itemTransactionModel: selectedItem, onAddButtonTapped: { updatedItemTransaction in
                    return
                    
                })
                    .padding()
                
                Divider()
                    .padding([.horizontal, .bottom])
            }
        }
        .background(Color.background.base)
    }
    
//    private var paymentSummarySection: some View {
//        VStack(alignment: .leading, spacing: 0) {
//            Text("Payment Summary")
//                .font(.headline)
//                .padding()
//            
//            Divider()
//            
//            ForEach(vm.selectedItems, id: \.item) { selectedItem in
//                PaymentSummaryView(paymentType: selectedItem.item.name, payment: selectedItem.totalPricePerItem)
//                    .padding()
//                
//                Divider()
//                    .padding(.horizontal)
//            }
//        }
//        .background(Color.background.base)
//    }
}

struct PaymentSummaryView: View {
    
    var paymentType: String
    var payment: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(paymentType)
                
                Spacer()
                
                Text("Rp. \(payment)")
            }
            .font(.callout)
            .foregroundStyle(Color.text.primary100)
        }
    }
}
