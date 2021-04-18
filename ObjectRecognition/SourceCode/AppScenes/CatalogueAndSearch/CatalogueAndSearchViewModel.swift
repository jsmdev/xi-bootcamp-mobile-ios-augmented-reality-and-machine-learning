//
//  CatalogueAndSearchViewModel.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import Foundation

protocol CatalogueAndSearchViewDelegate: class {
    
}

class CatalogueAndSearchViewModel {
    weak var viewDelegate: CatalogueAndSearchViewDelegate?
}
