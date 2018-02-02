//
//  SectionFooter.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/9/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList


class SectionFooter: UITableViewHeaderFooterView,ReusableView {

    @IBOutlet weak var label: UILabel!

    var data:MovieSection?{
        didSet{
            guard let movie = data else { return  }
            bind(data: movie)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    contentView.backgroundColor=UIColor.backgroundColor
    }
    
    func bind(data:MovieSection) {
        label.text = "There are \(data.movies.count) movies that started with the letter \(data.firstLetter)"
    }
}
