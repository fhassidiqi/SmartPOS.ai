//
//  CameraView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 17/12/23.
//

import SwiftUI

struct CameraView: View {
    
    @EnvironmentObject private var router: Router
    
    var body: some View {
        ZStack {
            
        }
        .toolbar {
            CustomToolbar(title: "Camera", leadingTitle: "Pay") {
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
    CameraView()
}
