//
//  ImageRepository.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import UIKit
import Vision
import QuartzCore

class ImageRepository {
    static let shared = ImageRepository()
    private var requests = [VNRequest]()
    let model = try? YOLO(configuration: MLModelConfiguration())
    var testImages = TestImages()
    var currentImage: TestImageModel?

    private init() {
        loadData()
    }
    
    private func loadData() {
        for index in 0 ..< 105 {
            currentImage = TestImageModel(name: "jsmdev-test-image-\(index).jpeg", recognizedObjects: "")
            if let model = model?.model,
               let visionModel = try? VNCoreMLModel(for: model) {
                let objectRecognition = VNCoreMLRequest(model: visionModel, completionHandler: visionRequestCompleted)
                requests = [objectRecognition]
            }
            predict()
            if let image = currentImage {
                testImages.append(image)
            }
        }
    }
    
    func getData() -> [TestImageModel] {
        return testImages
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
                if let topLabelObservation = objectObservation.labels.first {
                    objectsName.append("\(topLabelObservation.identifier), ")
                }
            }
            objectsName = String(objectsName.dropLast(2))
            currentImage?.recognizedObjects = objectsName
            debugPrint("Recognized Objects: \(objectsName)")
            CATransaction.commit()
        }
    }
    
    private func predict() {
        guard let imageName = currentImage?.name, let image = UIImage(named: imageName) else { return }
        guard let pixelBuffer = image.resize().pixelBuffer else { return }
        let imageRequestHandler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        do {
            try imageRequestHandler.perform(self.requests)
        } catch {
            debugPrint("Error when predict objects: \(error)")
        }
    }
}
