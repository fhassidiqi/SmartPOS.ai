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
    @State private var isImagePickerPresented: Bool = false
    @State private var capturedImage: UIImage?
    
    var body: some View {
        ZStack {
            if let image = capturedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
            } else {
                Color.black.edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.isImagePickerPresented.toggle()
                    }
                    .sheet(isPresented: $isImagePickerPresented) {
                        ImagePicker(isImagePickerPresented: $isImagePickerPresented, capturedImage: $capturedImage)
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
        .toolbarBackground(Color.primary100, for: .automatic)
    }
}

#Preview {
    CameraView()
}

