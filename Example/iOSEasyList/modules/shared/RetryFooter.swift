//
//  retryFooter.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/7/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

class RetryFooter: NibView {

    @IBOutlet weak var reloadImage: UIImageView!
    @IBOutlet weak var loadMoreErrorText:UILabel!
   
    override func commonInit() {
        reloadImage.layer.masksToBounds=true
        reloadImage.layer.cornerRadius=20
        reloadImage.layer.borderWidth=1
        reloadImage.layer.borderColor = UIColor.placeHolder.cgColor
        reloadImage.layer.backgroundColor = UIColor.placeHolder.withAlphaComponent(0.2).cgColor
        reloadImage.tintColor = .placeHolder
    }
}
