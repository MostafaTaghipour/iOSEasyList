//
//  FlowCell.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/23/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class FlowCell: BaseCollectionViewCell<Movie> {
    
    
    @IBOutlet weak var container: UIView!
    @IBOutlet weak var titleLabel: UILabel!
   @IBOutlet weak var imgView: UIImageView!
    
    
    override func initialization() {
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = imgView.frame.height/2
         imgView.layer.masksToBounds = true
        contentView.layer.cornerRadius =  contentView.frame.height/2
        contentView.layer.masksToBounds=true
    }
    
    override func bind(data:Movie) {
        titleLabel.text=data.title
        imgView.loadImageFromWeb(url: data.poster_path)
    }
}

