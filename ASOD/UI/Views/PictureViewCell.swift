//
//  PictureViewCell.swift
//  ASOD
//
//  Created by Максим Казаков on 12/11/2017.
//  Copyright © 2017 Максим Казаков. All rights reserved.
//

import UIKit

class PictureViewCell: UITableViewCell {
    static let identifier = String(describing: PictureViewCell.self)
    
    
    @IBOutlet weak var explanationLabel: UILabel!
    @IBOutlet weak var picture: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func setup(viewModel: PictureViewModel) {
        self.picture.image = #imageLiteral(resourceName: "picturePlaceholder")
        self.explanationLabel.text = viewModel.explanation
        self.dateLabel.text = PictureViewCell.dateFormatter.string(from: viewModel.date)
    }
    
    static var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.doesRelativeDateFormatting = true
//        formatter.dateFormat = "YYYY-MM-dd"
        return formatter
    }()
}
