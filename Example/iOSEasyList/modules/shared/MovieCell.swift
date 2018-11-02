//
//  MovieCell.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/5/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class MovieCell: BaseTableViewCell<Movie> {
    
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    
   
    override func initialization() {
     imgView.contentMode = .scaleAspectFill
    }
    
    override func bind(data:Movie) {
        yearLabel.text="\(data.release_date![...3]) | \(data.original_language!.uppercased())"
        titleLabel.text=data.title
        descLabel.text=data.overview
        imgView.loadImageFromWeb(url: data.poster_path)
    }
}


