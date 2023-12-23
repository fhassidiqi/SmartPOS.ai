//
//  ScanQRView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 22/10/23.
//

import SwiftUI

struct ScanQRView: View {
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject var vm: FoodListViewModel
    
    var body: some View {
        ZStack {
            Color.background.primary
                .ignoresSafeArea()
            
            VStack {
                Image("QR")
                    .resizable()
                    .frame(maxWidth: .infinity)
                    .frame(height: 400)
                
                Spacer()
                
                FloatingButtonView (
                    color: Color.text.white,
                    image: "",
                    text1: "Done",
                    text2: "",
                    quantity: 0
                ) {
                    vm.payment = "\(vm.calculateTotalWithTax())"
                    router.navigateBack()
                }
            }
        }
        .toolbar {
            CustomToolbar(title: "Scan QR", leadingTitle: "Pay") {
                router.navigateBack()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .automatic)
        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.primaryColor100, for: .automatic)
    }
}
