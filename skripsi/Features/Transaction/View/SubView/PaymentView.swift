//
//  PaymentView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 12/11/23.
//

import SwiftUI

struct PaymentView: View {
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject var vm: FoodListViewModel
    var payment: Int? = 50000
    @State private var isActive = false
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.background.primary
                .ignoresSafeArea()
            
            ScrollView {
                itemSection
                    .padding(.bottom, 8)
                paymentSummarySection
            }
            
            if payment != 0 {
                FloatingButtonView(
                    color: Color.primary100,
                    image: "",
                    text1: "Proceed",
                    text2: "",
                    quantity: 0
                ) {
                    vm.addTransaction(date: Date())
                    router.navigateToRoot()
                }
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
            
            ForEach(vm.selectedItems, id: \.item.id) { selectedItem in
                ItemFoodCardView(itemModel: selectedItem.item, itemTransactionModel: selectedItem, onAddButtonTapped: { updatedItemTransaction in
                    if let index = vm.selectedItems.firstIndex(where: { $0.item.id == updatedItemTransaction.item.id }) {
                        vm.selectedItems[index] = updatedItemTransaction
                    } else {
                        vm.selectedItems.append(updatedItemTransaction)
                    }
                })
                .padding()
                
                Divider()
                    .padding([.horizontal, .bottom])
            }
        }
        .background(Color.background.base)
    }
    
    private var paymentSummarySection: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("Payment Summary")
                .font(.headline)
                .padding()
            
            Divider()
            
            paymentInfo(title: "Total", value: "\(formattedPrice(totalPrice()))")
            paymentInfo(title: "Tax 10%", value: "\(formattedPrice(calculateTax()))")
            paymentInfo(title: "Total", value: "\(formattedPrice(totalWithTax()))").bold()
            paymentInfo(title: "Cash", value: "\(formattedPrice(payment ?? 0))")
            paymentInfo(title: "Change", value: "\(formattedPrice(calculateChange()))")
        }
        .background(Color.background.base)
    }
    
    private func paymentInfo(title: String, value: String) -> some View {
        VStack {
            HStack {
                Text(title)
                Spacer()
                Text(value).font(.callout)
                
            }
            .padding()
            .background(Color.background.base)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    private func formattedPrice(_ amount: Int) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencySymbol = "Rp."
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: amount)) ?? "\(amount)"
    }
    
    private func totalPrice() -> Int {
        vm.selectedItems.reduce(0) { $0 + $1.totalPricePerItem }
    }
    
    private func calculateTax() -> Int {
        Int(Double(totalPrice()) * 0.1)
    }
    
    private func totalWithTax() -> Int {
        Int(Double(totalPrice()) * 1.1)
    }
    
    private func calculateChange() -> Int {
        let totalPrice = Double(totalPrice()) * 1.1
        return Int(Double(payment ?? 0) - totalPrice)
    }
    
    private func createUpdatedItemTransaction(withQuantity quantity: Int) -> ItemTransactionModel {
        return ItemTransactionModel(
            item: vm.selectedItems[0].item,
            quantity: quantity,
            totalPricePerItem: vm.selectedItems[0].item.price * quantity,
            totalProfitPerItem: vm.selectedItems[0].item.profit * quantity,
            totalOmzetPerItem: vm.selectedItems[0].item.omzet * quantity
        )
    }
}
