//
//  CatalogueAndSearchViewController.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import UIKit

class CatalogueAndSearchViewController: UIViewController {
    @IBOutlet var collectionView: UICollectionView?

    var viewModel: CatalogueAndSearchViewModel
    
    init(viewModel: CatalogueAndSearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Image Catalogue"
        configureCollectionView()
        viewModel.viewWasLoaded()
    }

    private func configureCollectionView() {
        collectionView?.dataSource = self
        collectionView?.delegate = self
        collectionView?.register(UINib(nibName: "ImageCell", bundle: nil),
                                 forCellWithReuseIdentifier: "ImageCell")
    }

}

extension CatalogueAndSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfRows(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = viewModel.viewModel(at: indexPath),
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as? ImageCell else { return UICollectionViewCell() }
        cell.viewModel = cellViewModel
        return cell
    }
}

extension CatalogueAndSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.didSelectRow(at: indexPath)
    }
}

extension CatalogueAndSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let cellWidth = (UIScreen.main.bounds.width - 10 + 16 + 16) / 2
//        let cellHeight = cellWidth
        return CGSize(width: 156, height: 156)
    }
}

extension CatalogueAndSearchViewController: CatalogueAndSearchViewDelegate {
    func catalogueImagesLoaded() {
        collectionView?.reloadData()
    }
}
