//
//  LoadingViewController.swift
//  ObjectRecognition
//
//  Created by José Sancho on 19/4/21.
//

import UIKit

class LoadingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        nextViewController()
    }

    func nextViewController() {
        let catalogueAndSearchViewModel = CatalogueAndSearchViewModel()
        let catalogueAndSearchViewController = CatalogueAndSearchViewController(viewModel: catalogueAndSearchViewModel)
        catalogueAndSearchViewModel.viewDelegate = catalogueAndSearchViewController
        if let window = SceneDelegate.shared.window {
            let navigationController = UINavigationController(rootViewController: catalogueAndSearchViewController)
            navigationController.navigationBar.isTranslucent = false
            window.rootViewController = navigationController
        }
    }
}
