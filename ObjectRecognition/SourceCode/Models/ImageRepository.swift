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
    
    }
}
