//
//  TestImageModel.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import Foundation

typealias TestImages = [TestImageModel]

struct TestImageModel {
    let name: String
    var recognizedObjects: String
    
    internal init(name: String, recognizedObjects: String) {
        self.name = name
        self.recognizedObjects = recognizedObjects
    }
   
}
