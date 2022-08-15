//
//  BookCell.swift
//  BookStore
//
//  Created by Group D on 18/07/22.
//

import UIKit

class BookCell: UICollectionViewCell {

    @IBOutlet weak var favImgView: UIImageView!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
