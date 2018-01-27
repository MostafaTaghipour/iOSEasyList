//
//  PopularMovieCell.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/8/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class PopularMovieCell: BaseCollectionViewCell<Movie> {

    @IBOutlet weak var imgView: UIImageView!
    
    override func initialization() {
          imgView.contentMode = .scaleAspectFill
    }
    
    
   override func bind(data:Movie) {
        imgView.loadImageFromWeb(url: data.poster_path)
    }
}
