//
//  ListCell.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/18/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

class ListCell: BaseCollectionViewCell<Movie> {

    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    
    override func initialization() {
        imgView.contentMode = .scaleAspectFill
        
       
    }
    
    private func fullWidthDynamicHeight(){
    self.contentView.translatesAutoresizingMaskIntoConstraints = false
    let screenWidth = UIScreen.main.bounds.size.width
    widthConstraint.constant = screenWidth
    setNeedsLayout()
    layoutIfNeeded()
    }
    
    override func bind(data:Movie) {
        yearLabel.text="\(data.release_date[...3]) | \(data.original_language.uppercased())"
        titleLabel.text=data.title
        descLabel.text=data.overview
        imgView.loadImageFromWeb(url: data.poster_path)
    }
    
}
