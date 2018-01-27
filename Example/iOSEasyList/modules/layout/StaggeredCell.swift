//
//  StaggeredCell.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/18/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class StaggeredCell: BaseCollectionViewCell<Movie> {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    @IBOutlet weak var imgView: UIImageView!
    
    override func initialization() {
        imgView.contentMode = .scaleAspectFill
          self.contentView.translatesAutoresizingMaskIntoConstraints=false
    }
    
    override func bind(data:Movie) {
        imgView.loadImageFromWeb(url: data.poster_path)
    }
}

