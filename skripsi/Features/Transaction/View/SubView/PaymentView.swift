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
    @State private var isActive = false
    @State private var paymentType: PaymentType = .manual
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.background.primary
                .ignoresSafeArea()
            
            ScrollView {
                itemSection
                paymentSummarySection
            }
            
            if !vm.payment.isEmpty && Double(vm.payment) ?? 0 >= Double(vm.calculateTotalWithTax()) {
                FloatingButtonView(
                    color: Color.text.white,
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
        .toolbarBackground(Color.primaryColor100, for: .automatic)
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
            
            paymentInfo(title: "Total", value: "\(vm.calculateTotalPrice().formattedAsRupiah)")
            paymentInfo(title: "Tax 10%", value: "\(vm.calculateTax().formattedAsRupiah)")
            paymentInfo(title: "Total", value: "\(vm.calculateTotalWithTax().formattedAsRupiah)").bold()
            selectedPaymentType()
            paymentInfo(title: "Change", value: "\(vm.calculateChange(enteredAmount: Double(vm.payment) ?? 0 ).formattedAsRupiah)")
        }
        .background(Color.background.base)
    }
    
    private func paymentInfo(title: String, value: String) -> some View {
        VStack {
            HStack(spacing: 0) {
                Text(title)
                Spacer()
                Text(value)
                    .font(.callout)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .background(Color.background.base)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    private func selectedPaymentType() -> some View {
        VStack {
            HStack {
                Picker("Choose Payment", selection: $paymentType) {
                    ForEach(PaymentType.allCases) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .background(Color.primary20)
                .cornerRadius(16)
                .overlay {
                    RoundedRectangle(cornerRadius: 16)
                        .inset(by: 0.5)
                        .stroke(Color.primaryColor100)
                }
                .onChange(of: paymentType, perform: handlePaymentTypeSelection)
                
                Spacer()
                
                ZStack(alignment: .leading) {
                    
                    TextField("Enter Amount", text: Binding(
                        get: {
                            return vm.payment.isEmpty ? "" : Int(vm.payment)?.formattedAsRupiah ?? vm.payment
                        },
                        set: { newValue in
                            let rawValue = newValue.components(separatedBy: CharacterSet.decimalDigits.inverted).joined()
                            vm.payment = rawValue
                        }
                    ))
                    .font(.callout)
                    .keyboardType(.numberPad)
                    .multilineTextAlignment(.trailing)
                }
                .frame(width: 100)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)
            .background(Color.background.base)
            
            Divider()
                .padding(.horizontal)
        }
    }
    
    private func handlePaymentTypeSelection(_ selectedPaymentType: PaymentType) {
        switch selectedPaymentType {
        case .manual:
            break
        case .cash:
            router.navigate(to: .cameraView)
        case .qr:
            router.navigate(to: .scanQR)
        }
    }
}

enum PaymentType: String, CaseIterable, Identifiable {
    case manual = "Payment"
    case cash = "Cash"
    case qr = "QR"
    var id: PaymentType { self }
}
