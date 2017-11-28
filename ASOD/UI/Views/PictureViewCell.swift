//
//  PictureViewCell.swift
//  ASOD
//
//  Created by Максим Казаков on 12/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit
import Kingfisher

class PictureViewCell: UITableViewCell {
    static let identifier = String(describing: PictureViewCell.self)
    
    
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        picture.layer.cornerRadius = 10
        picture.layer.masksToBounds = true
    }
    
    func setup(viewModel: PictureViewModel) {
        
        if let imageUrl = viewModel.url {
            picture.kf.indicatorType = .activity
            picture.kf.setImage(with: imageUrl)
        } else {
            picture.image = #imageLiteral(resourceName: "picturePlaceholder")
        }
        
        explanationLabel.text = viewModel.explanation
        dateLabel.text = PictureViewCell.dateFormatter.string(from: viewModel.date)
        titleLabel.text = viewModel.title
        if viewModel.copyright.isEmpty {
            authorLabel.isHidden = true
        }
        else {
            authorLabel.isHidden = false
            authorLabel.text = "Author: \(viewModel.copyright)"
        }
        
    }
    
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
//        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
}
