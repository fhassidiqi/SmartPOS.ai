//
//  Detector.swift
//  skripsi
//
//  Created by Falah Hasbi Assidiqi on 26/12/23.
//

import Foundation
import AVFoundation
import Vision
import UIKit


extension ViewController {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        detectObject(pixelBuffer)
    }
    
    func detectObject(_ image: CVPixelBuffer) {
        do {
            let yoloV3Model = try VNCoreMLModel(for: MLModel(contentsOf: yolov3Url!))
            let recognitions = VNCoreMLRequest(model: yoloV3Model, completionHandler: detectionDidComplete)
            
            requests = [recognitions]
            
            let imageHandler = VNImageRequestHandler(cvPixelBuffer: image, orientation: .up, options: [:])
            try? imageHandler.perform(requests)
        } catch let error{
            debugPrint(error)
        }
    }
    
    //callback to detect object request
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let results = request.results {
                self.extractDetections(results)
            }
        }
    }
    
    func extractDetections(_ results: [VNObservation]) {
        objectLayer.sublayers = nil
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {return}
            
            //set label name
            labelName = objectObservation.labels.first!.identifier
            
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
            let transformedBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            
            let boxLayer = self.drawBoundingBox(transformedBounds, label: objectObservation.labels.first!.identifier)
            objectLayer.addSublayer(boxLayer)
        }
        
        //Person Counter Label
        personCounterText.text = "Label: \(labelName)"
        personCounterText.backgroundColor = .black
        personCounterText.textColor = .white
        personCounterText.textAlignment = .center
        
        self.view.addSubview(personCounterText)
        
        labelName = ""
    }
    
    func drawBoundingBox(_ bounds: CGRect, label: String) -> CALayer {
        //Box
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = UIColor.green.cgColor
        boxLayer.cornerRadius = 4.0
        
        //Text
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 0, y: 0, width: boxLayer.frame.width, height: 30)
        textLayer.alignmentMode = .center
        textLayer.foregroundColor = UIColor.orange.cgColor
        textLayer.string = label
        textLayer.fontSize = 10.0
        
        boxLayer.addSublayer(textLayer)
        
        return boxLayer
    }
    
    func setUpLayer() {
        objectLayer = CALayer()
        objectLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        objectLayer.zPosition = 1
        
        self.view.layer.addSublayer(objectLayer)
    }
}
