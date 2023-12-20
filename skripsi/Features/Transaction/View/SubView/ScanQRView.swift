//
//  ScanQRView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 22/10/23.
//

import SwiftUI

struct ScanQRView: View {
    
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            Color.background.primary
                .ignoresSafeArea()
            
            VStack {
                Image("QR")
                    .resizable()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                
                FloatingButtonView (
                    color: Color.primary100,
                    image: "",
                    text1: "Done",
                    text2: "",
                    quantity: 0
                ) {
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
        .toolbarBackground(Color.primary100, for: .automatic)
    }
}

#Preview {
    ScanQRView()
}
