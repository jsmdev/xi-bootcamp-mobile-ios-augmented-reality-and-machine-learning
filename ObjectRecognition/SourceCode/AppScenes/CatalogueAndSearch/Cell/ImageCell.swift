//
//  ImageCell.swift
//  ObjectRecognition
//
//  Created by José Sancho on 18/4/21.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var testImageView: UIImageView?
    
    var viewModel: ImageCellViewModel? {
        didSet {
            guard let viewModel = viewModel else {return}
            viewModel.viewDelegate = self
            if let name = viewModel.testImage?.name {
                didLoadImage(with: name)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        testImageView?.layer.cornerRadius =  156 / 2
        testImageView?.layer.borderWidth = 1
        testImageView?.layer.borderColor = UIColor.lightGray.cgColor
        testImageView?.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        testImageView?.image = nil
    }
}

extension ImageCell: ImageCellViewDelegate {
    func didLoadImage(with name: String) {
        if let image = UIImage(named: name) {
            testImageView?.image = image
        }
    }
}
