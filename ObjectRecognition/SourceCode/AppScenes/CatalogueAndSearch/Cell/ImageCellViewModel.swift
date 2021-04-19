//
//  ImageCellViewModel.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import Foundation

protocol ImageCellViewDelegate: class {
    func imageLoaded(imageName: String)
}

class ImageCellViewModel {
    weak var viewDelegate: ImageCellViewDelegate?
    var testImage: TestImageModel?
    
    init(image: TestImageModel) {
        testImage = image
        if let name = testImage?.name {
            viewDelegate?.imageLoaded(imageName: name)
        }
    }
}
