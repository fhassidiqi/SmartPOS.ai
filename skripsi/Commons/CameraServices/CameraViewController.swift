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

    let captureSession = AVCaptureSession()
    
    //preview layer = camera layer
    lazy var previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
    
    var screenRect: CGRect = UIScreen.main.bounds
    var objectLayer: CALayer! = nil
    
    //send the frame through the model
    var requests = [VNRequest]()
    var videoDataOutput = AVCaptureVideoDataOutput()
    var yolov3Url = Bundle.main.url(forResource: "modelAISkripsi", withExtension: "mlmodelc")
    var labelName: String = "" //set the label name to the UI
    var personCounterText = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue(label: "createdQueue").async {
            self.cameraSetUp()
            self.showCamera()
            self.getCameraFrames()

            self.setUpLayer()
            self.captureSession.startRunning()
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

        //Preview Layer (Camera Layer) must be run in main thread
        DispatchQueue.main.async {
            self.view.layer.addSublayer(self.previewLayer)
        }
    }
}

struct CameraViewControllerRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        let vc = ViewController()
        return vc
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = ViewController
    
    
}
