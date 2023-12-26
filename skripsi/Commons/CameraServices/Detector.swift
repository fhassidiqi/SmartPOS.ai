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
    
    func detectionDidComplete(request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            if let results = request.results {
                self.extractDetections(results)
            }
        }
    }
    
    func getColorForLabel(_ label: String) -> (boxColor: UIColor, textColor: UIColor) {
        switch label {
        case "1000", "1000 -2016-":
            return (.red, .red)
        case "2000", "2000 -2016-":
            return (.blue, .blue)
        case "5000", "5000 -2016-":
            return (.green, .green)
        case "10000", "10000 -2016-":
            return (.yellow, .yellow)
        case "20000", "20000 -2016-":
            return (.orange, .orange)
        case "50000", "50000 -2016-":
            return (.brown, .brown)
        case "100000", "100000 -2016-":
            return (.purple, .purple)
        default:
            return (.black, .white)
        }
    }
    
    func extractDetections(_ results: [VNObservation]) {
        objectLayer.sublayers = nil
        
        for observation in results where observation is VNRecognizedObjectObservation {
            guard let objectObservation = observation as? VNRecognizedObjectObservation else {return}
            
            labelName = objectObservation.labels.first!.identifier
            
            let objectBounds = VNImageRectForNormalizedRect(objectObservation.boundingBox, Int(screenRect.size.width), Int(screenRect.size.height))
            let transformedBounds = CGRect(x: objectBounds.minX, y: screenRect.size.height - objectBounds.maxY, width: objectBounds.maxX - objectBounds.minX, height: objectBounds.maxY - objectBounds.minY)
            
            let boxLayer = self.drawBoundingBox(transformedBounds, label: labelName, boxColor: getColorForLabel(labelName).boxColor, textColor: getColorForLabel(labelName).textColor)
            objectLayer.addSublayer(boxLayer)
        }
        
        personCounterText.text = "Label: \(labelName)"
        personCounterText.backgroundColor = .black
        personCounterText.textColor = .white
        personCounterText.textAlignment = .center
        
        self.view.addSubview(personCounterText)
        
        labelName = ""
    }
    
    func drawBoundingBox(_ bounds: CGRect, label: String, boxColor: UIColor, textColor: UIColor) -> CALayer {
        
        let boxLayer = CALayer()
        boxLayer.frame = bounds
        boxLayer.borderWidth = 3.0
        boxLayer.borderColor = boxColor.cgColor
        boxLayer.cornerRadius = 4.0
        
        let textLayer = CATextLayer()
        textLayer.frame = CGRect(x: 0, y: 0, width: boxLayer.frame.width, height: boxLayer.frame.height)
        textLayer.alignmentMode = .center
        textLayer.foregroundColor = textColor.cgColor
        textLayer.string = label
        textLayer.fontSize = 15.0
        
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
