//
//  CatalogueAndSearchViewController.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import UIKit

class CatalogueAndSearchViewController: UIViewController {

    var viewModel: CatalogueAndSearchViewModel?
    
//    init(viewModel: CatalogueAndSearchViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        title = "Image Catalogue"
    }


}

extension CatalogueAndSearchViewController: CatalogueAndSearchViewDelegate {
    
}
