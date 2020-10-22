//
//  PhotoListViewCell.swift
//  FlickerSearch
//
//  Created by Arjuna on 3/2/20.
//  Copyright © 2020 Arjuna. All rights reserved.
//

import UIKit
import Kingfisher

class PhotoListViewCell: UITableViewCell {
    
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func setUpWith(photoItemModel:PhotoItemViewModel) {
        titleLabel.text = photoItemModel.title
        let url = URL(string: photoItemModel.downloadUrl())
        imgView.kf.indicatorType = .activity
        imgView.kf.setImage(with:url)
    }
}



