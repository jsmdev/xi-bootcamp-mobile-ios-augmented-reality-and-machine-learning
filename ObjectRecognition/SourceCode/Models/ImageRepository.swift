//
//  ImageRepository.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import Foundation

class ImageRepository {
    static let shared = ImageRepository()
    var testImages = TestImages()

    private init() {
        loadData()
    }
    
    private func loadData() {
        for index in 0 ..< 105 {
            testImages.append(TestImageModel(name: "jsmdev-test-image-\(index).jpeg"))
        }
    }
    
    func getData() -> [TestImageModel] {
        return testImages
    }
}
