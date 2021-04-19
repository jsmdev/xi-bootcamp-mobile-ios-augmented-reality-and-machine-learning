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
//        let imagesPrefixName = "jsmdev-test-image-"
        testImages.append(TestImageModel(name: "jsmdev-test-image-080.jpeg"))
    }
    
    func getData() -> [TestImageModel] {
        return testImages
    }
}
