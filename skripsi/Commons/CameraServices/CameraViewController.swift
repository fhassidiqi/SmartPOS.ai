//
//  CameraViewController.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 26/12/23.
//

import UIKit
import AVFoundation
import Vision
import SwiftUI

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var router: Router!
    let captureSession = AVCaptureSession()
    var foodListViewModel = FoodListViewModel()
    
    var labelName: String = ""
    var objectLayer: CALayer! = nil
    var screenRect: CGRect = UIScreen.main.bounds
    
    var requests = [VNRequest]()
    var videoDataOutput = AVCaptureVideoDataOutput()
    var yolov2Url = Bundle.main.url(forResource: "modelAISkripsi", withExtension: "mlmodelc")
    
    var captureButton = UIButton()
    var personCounterText = UILabel()
    
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue(label: "createdQueue").async {
            self.cameraSetUp()
            self.showCamera()
            self.getCameraFrames()
            
            self.setUpLayer()
            self.captureSession.startRunning()
            
            let cameraViewController = CameraViewControllerRepresentable(viewModel: self.foodListViewModel, router: self.router)
            
            self.setupCaptureButton()
            self.view.addSubview(self.captureButton)
        }
    }
    
    func cameraSetUp() {
        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) else {return}
        guard let cameraInput = try? AVCaptureDeviceInput(device: device) else {return}
        captureSession.addInput(cameraInput)
    }
    
    func showCamera() {
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.width, height: screenRect.height)
        previewLayer.zPosition = 0
        previewLayer.videoGravity = .resizeAspectFill
        previewLayer.connection!.videoOrientation = .portrait
    }
    
    func getCameraFrames() {
        videoDataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoDataOutput)
        
        videoDataOutput.connection(with: .video)!.videoOrientation = .portrait
        
        DispatchQueue.main.async {
            self.view.layer.addSublayer(self.previewLayer)
        }
    }
    
    func setupCaptureButton() {
        let buttonSize: CGFloat = 50.0
        let buttonPadding: CGFloat = 10.0
        let circleSize: CGFloat = buttonSize + 2 * buttonPadding
        
        let circleView = UIView()
        circleView.frame = CGRect(x: (view.bounds.width - circleSize) / 2,
                                  y: view.bounds.height - circleSize - 10.0,
                                  width: circleSize,
                                  height: circleSize)
        circleView.backgroundColor = UIColor.clear
        circleView.layer.cornerRadius = circleSize / 2.0
        circleView.layer.borderWidth = 2.0
        circleView.layer.borderColor = UIColor.white.cgColor
        
        captureButton.frame = CGRect(x: ((view.bounds.width - circleSize) / 2) + buttonPadding,
                                     y: (view.bounds.height - circleSize - 10.0) + buttonPadding,
                                     width: buttonSize,
                                     height: buttonSize)
        captureButton.backgroundColor = UIColor.white
        captureButton.layer.cornerRadius = buttonSize / 2.0
        captureButton.addTarget(self, action: #selector(captureButtonPressed), for: .touchUpInside)
        
        circleView.addSubview(captureButton)
        view.addSubview(circleView)
    }
    
    @objc func captureButtonPressed() {
        let cleanedLabel = labelName.replacingOccurrences(of: " -2016-", with: "")
        foodListViewModel.updatePayment(withLabelName: cleanedLabel)
        router.navigateBack()
    }
}

struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    typealias UIViewControllerType = ViewController

    var viewModel: FoodListViewModel
    var router: Router

    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()
        viewController.foodListViewModel = viewModel
        viewController.router = router
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update UI if needed
    }
}
