//
//  ImageDetailViewModel.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import Vision
import QuartzCore
import UIKit


protocol ImageDetailCoordinatorDelegate: class {
    
}

protocol ImageDetailViewDelegate: class {
    
    func didPredict(observations: [VNDetectedObjectObservation], objectsName: String)
}

class ImageDetailViewModel {
    
    weak var coordinateDelegate: ImageDetailCoordinatorDelegate?
    weak var viewDelegate: ImageDetailViewDelegate?
    let imageData: Data
    let model = try? YOLO(configuration: MLModelConfiguration())
    
    private var requests = [VNRequest]()
    
    init(imageData: Data) {
        self.imageData = imageData
        guard let model = model?.model,
              let visionModel = try? VNCoreMLModel(for: model) else {fatalError()}
        
       let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestCompleted)
        
        self.requests = [objectRecognition]
    }
    
 
    func predict() {
        guard let pixelBuffer = UIImage(data: imageData)?.resize().pixelBuffer else {return}
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            print(error)
        }
    }
    
    private func visionRequestCompleted(request: VNRequest, error: Error?) {
        if let results = request.results {
            CATransaction.begin()
            CATransaction.setValue(kCFBooleanTrue, forKey: kCATransactionDisableActions)
            
            var objectsName = ""
            
            for observation in results where observation is VNRecognizedObjectObservation {
                guard let objectObservation = observation as? VNRecognizedObjectObservation else {
                    continue
                }
                // Select only the label with the highest confidence.
                let topLabelObservation = objectObservation.labels[0]
                objectsName.append("\(topLabelObservation.identifier), ")
            }
            
            
            guard let observations = results as? [VNDetectedObjectObservation] else {return}
            self.viewDelegate?.didPredict(observations: observations, objectsName: objectsName)
            CATransaction.commit()
        }
    }
}

extension UIImage {
    func resize(_ maxSize: CGFloat = 500) -> UIImage {
        return UIGraphicsImageRenderer(size: CGSize(width: maxSize, height: maxSize)).image { _ in
            self.draw(in: CGRect(origin: .zero, size: CGSize(width: maxSize, height: maxSize)))
        }
    }
    
    var pixelBuffer: CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        context?.translateBy(x: 0, y: self.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        UIGraphicsPushContext(context!)
        self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        return pixelBuffer
    }
}
