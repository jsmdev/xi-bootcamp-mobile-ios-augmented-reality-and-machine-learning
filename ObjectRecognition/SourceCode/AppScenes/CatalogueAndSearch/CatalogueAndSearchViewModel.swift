//
//  CatalogueAndSearchViewModel.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import Foundation

protocol CatalogueAndSearchViewDelegate: class {
    func catalogueImagesLoaded()
}

class CatalogueAndSearchViewModel {
    weak var viewDelegate: CatalogueAndSearchViewDelegate?
    var imageCellViewModels = [ImageCellViewModel]()
    
    func viewWasLoaded() {
        loadImages()
    }
    
    private func loadImages() {
        imageCellViewModels = ImageRepository.shared.getData().map({ ImageCellViewModel(image: $0)})
        viewDelegate?.catalogueImagesLoaded()
    }
}

extension CatalogueAndSearchViewModel {
    func numberOfRows(in section: Int) -> Int {
        return imageCellViewModels.count
    }
    
    func viewModel(at indexPath: IndexPath) -> ImageCellViewModel? {
        guard indexPath.row < imageCellViewModels.count else {return nil}
        return imageCellViewModels[indexPath.row]
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        print("didSelectRow at: \(indexPath)")
    }
}
