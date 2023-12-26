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
    @State private var isImagePickerPresented: Bool = false
    @State private var capturedImage: UIImage?
    @State var currentZoomFactor: CGFloat = 1.0
    
//    var captureButton: some View {
//        Button(action: {
//            vm.capturePhoto()
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
//    
//    var flipCameraButton: some View {
//        Button(action: {
//            vm.flipCamera()
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
            
            CameraViewControllerRepresentable()
//            GeometryReader { reader in
//                ZStack {
//                    Color.black.edgesIgnoringSafeArea(.all)
//                    
//                    VStack {
//                        Button(action: {
//                            vm.switchFlash()
//                        }, label: {
//                            Image(systemName: vm.isFlashOn ? "bolt.fill" : "bolt.slash.fill")
//                                .font(.system(size: 20, weight: .medium, design: .default))
//                        })
//                        .accentColor(vm.isFlashOn ? .yellow : .white)
//                        
//                        CameraPreview(session: vm.session)
//                            .gesture(
//                                DragGesture().onChanged({ (val) in
//                                    
//                                    if abs(val.translation.height) > abs(val.translation.width) {
//                                        
//                                        let percentage: CGFloat = -(val.translation.height / reader.size.height)
//                                        let calc = currentZoomFactor + percentage
//                                        let zoomFactor: CGFloat = min(max(calc, 1), 5)
//                                        
//                                        currentZoomFactor = zoomFactor
//                                        vm.zoom(with: zoomFactor)
//                                    }
//                                })
//                            )
//                            .onAppear {
//                                vm.configure()
//                            }
//                            .alert(isPresented: $vm.showAlertError, content: {
//                                Alert(title: Text(vm.alertError.title), message: Text(vm.alertError.message), dismissButton: .default(Text(vm.alertError.primaryButtonTitle), action: {
//                                    vm.alertError.primaryAction?()
//                                }))
//                            })
//                            .overlay(
//                                withAnimation(.easeInOut) {
//                                    Group {
//                                        if vm.willCapturePhoto {
//                                            Color.black
//                                        }
//                                    }
//                                }
//                            )
//                        
//                        
//                        HStack {
//                            capturedPhotoThumbnail
//                            
//                            Spacer()
//                            
//                            captureButton
//                            
//                            Spacer()
//                            
//                            flipCameraButton
//                            
//                        }
//                        .padding(.horizontal, 20)
//                    }
//                }
//            }
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

#Preview {
    CameraView()
}

