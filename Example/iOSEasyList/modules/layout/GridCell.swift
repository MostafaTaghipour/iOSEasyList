//
//  GridCell.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/18/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList
class GridCell: BaseCollectionViewCell<Movie> {
    

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!

    
    override func initialization() {
        imgView.contentMode = .scaleAspectFill
    }
    
    override func bind(data:Movie) {
        titleLabel.text=data.title
        imgView.loadImageFromWeb(url: data.poster_path)
    }
}
