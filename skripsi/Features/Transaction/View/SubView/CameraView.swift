//
//  CameraView.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 17/12/23.
//

import SwiftUI
import AVFoundation

struct CameraView: View {
    
    @EnvironmentObject private var router: Router
    @EnvironmentObject private var vm: FoodListViewModel
    
    var body: some View {
        ZStack {
            CameraViewControllerRepresentable(viewModel: vm, router: router)
        }
        .toolbar {
            CustomToolbar(title: "Camera", leadingTitle: "Pay") {
                router.navigateBack()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.visible, for: .automatic)
        .navigationBarBackButtonHidden()
        .toolbarBackground(Color.primaryColor100, for: .automatic)
    }
}

