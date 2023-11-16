//
//  PaymentView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 12/11/23.
//

import SwiftUI

struct PaymentView: View {
    
    private let paymentType = ["Sub Total", "Tax(10%)", "Total", "Cash", "Return"]
    private let payment = [129000, 12900, 129000, 129000, 0]
    @EnvironmentObject private var router: Router
    @StateObject private var vm = FoodListViewModel()
    
    var body: some View {
        ZStack(alignment: .bottom) {
            Color.background.primary
                .ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Item")
                        .font(.headline)
                        .padding()
                    
                    Divider()
                    
                    ItemPayCardView()
                        .padding()
                    
                    Divider()
                        .padding([.horizontal, .bottom])
                }
                .background(Color.background.base)
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("Payment Summary")
                        .font(.headline)
                        .padding()
                    
                    Divider()
                    
                    ForEach(0..<paymentType.count, id: \.self) { item in
                        PaymentSummaryView(paymentType: paymentType[item], payment: payment[item])
                            .padding()
                        
                        Divider()
                            .padding(.horizontal)
                            
                    }
                }
                .background(Color.background.base)
            }
            
            FloatingButtonView(color: Color.primaryColor100, image: nil, text1: "Proceed", text2: nil) {
                router.navigateToRoot()
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
}

#Preview {
    PaymentView()
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
