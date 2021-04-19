//
//  ImageDetailViewController.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import UIKit
import AVFoundation
import Vision

class ImageDetailViewController: UIViewController {
    @IBOutlet weak var detailImageView: UIImageView?
    
    lazy var labelExample: UILabel = {
        let labelExample = UILabel()
        labelExample.translatesAutoresizingMaskIntoConstraints = false
        labelExample.backgroundColor = .gray
        labelExample.text = "Analizando..."
        return labelExample
    }()
    
    let viewModel: ImageDetailViewModel
    
    init(viewModel: ImageDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        viewModel.predict()
    }

    private func configureViewController() {
        title = "Image Detail"
        detailImageView?.image = UIImage(data: viewModel.imageData)
        view.addSubview(labelExample)
        NSLayoutConstraint.activate([
            labelExample.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            labelExample.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -32)
        ])
    }
    
    func visualizeObservations(observations: [VNDetectedObjectObservation], objectsName: String) {
        DispatchQueue.main.async {
            guard let image = self.detailImageView?.image else { return }
            
            let imageSize = image.size
            var imageTransform = CGAffineTransform.identity.scaledBy(x: 1, y: -1).translatedBy(x: 0, y: -imageSize.height)
            imageTransform = imageTransform.scaledBy(x: imageSize.width, y: imageSize.height)
            UIGraphicsBeginImageContextWithOptions(imageSize, true, 0)
           
            let graphicsContext = UIGraphicsGetCurrentContext()
            image.draw(in: CGRect(origin: .zero,
                                  size: imageSize))
            graphicsContext?.saveGState()
            graphicsContext?.setLineJoin(.round)
            graphicsContext?.setLineWidth(6.0)
            graphicsContext?.setFillColor(red: 1, green: 1, blue: 0, alpha: 0.3)
            graphicsContext?.setStrokeColor(UIColor.green.cgColor)
            
            observations.forEach { (observation) in
            
                let observationBounds = observation.boundingBox.applying(imageTransform)
                graphicsContext?.addRect(observationBounds)
            }
            if objectsName.count == 0 {
                self.labelExample.text = "Objects not found"
            } else {
                self.labelExample.text = objectsName
            }
            graphicsContext?.drawPath(using: CGPathDrawingMode.fillStroke)
            graphicsContext?.restoreGState()
            
            let drawnImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()

            self.detailImageView?.image = drawnImage
        }
    }
    
}

extension ImageDetailViewController: ImageDetailViewDelegate {
    func didPredict(observations: [VNDetectedObjectObservation], objectsName: String) {
        visualizeObservations(observations: observations, objectsName: objectsName)
    }
}


