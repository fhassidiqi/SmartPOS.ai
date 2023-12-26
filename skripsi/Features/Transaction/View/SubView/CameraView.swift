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
    @StateObject private var vm = FoodListViewModel()
    
//    var captureButton: some View {
//        Button(action: {
//            
//        }, label: {
//            Circle()
//                .foregroundColor(.white)
//                .frame(width: 80, height: 80, alignment: .center)
//                .overlay(
//                    Circle()
//                        .stroke(Color.black.opacity(0.8), lineWidth: 2)
//                        .frame(width: 65, height: 65, alignment: .center)
//                )
//        })
//    }
//    
//    var capturedPhotoThumbnail: some View {
//        Group {
//            if vm.photo != nil {
//                withAnimation(.spring()) {
//                    Image(uiImage: vm.photo.image!)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 60, height: 60)
//                        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
//                }
//            } else {
//                RoundedRectangle(cornerRadius: 10)
//                    .frame(width: 60, height: 60, alignment: .center)
//                    .foregroundColor(.black)
//            }
//        }
//    }
//    
//    var flipCameraButton: some View {
//        Button(action: {
//            
//        }, label: {
//            Circle()
//                .foregroundColor(Color.gray.opacity(0.2))
//                .frame(width: 45, height: 45, alignment: .center)
//                .overlay(
//                    Image(systemName: "camera.rotate.fill")
//                        .foregroundColor(.white))
//        })
//    }
    
    var body: some View {
        ZStack {
            GeometryReader { reader in
                VStack {
                    
                    CameraViewControllerRepresentable()
                        
                    
                    HStack {
                        
                    }
                }
            }
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

