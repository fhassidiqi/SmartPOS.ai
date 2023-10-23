//
//  PayView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 20/10/23.
//

import SwiftUI

struct PayView: View {
    
    private let paymentType = ["Sub Total", "Tax(10%)", "Total", "Cash", "Return"]
    private let payment = [129000, 12900, 129000, 129000, 0]
    var body: some View {
        NavigationStack {
            ZStack {
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
                            PaymentSummaryView(text: paymentType[item], money: payment[item])
                                .padding()
                            
                            Divider()
                                .padding(.horizontal)
                                
                        }
                    }
                    .background(Color.background.base)
                }
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Pay")
                        .font(.headline)
                        .foregroundStyle(Color.textWhite)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .automatic)
            .toolbarBackground(Color.primary100, for: .automatic)
        }
        .floatingActionButton(color: Color.primaryColor100, text1: "Proceed", text2: nil, image: "", action: {})
    }
}

#Preview {
    PayView()
}

struct PaymentSummaryView: View {
    let text: String
    let money: Int
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(text)
                
                Spacer()
                
                Text("Rp. \(money)")
            }
            .font(.callout)
            .foregroundStyle(Color.text.primary100)
//            .padding()
        }
    }
}
