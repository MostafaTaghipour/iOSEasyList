//
//  SeactionHeader.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/9/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import iOSEasyList

protocol CollapsibleTableViewHeaderDelegate:class {
    func toggleSection(_ header: CollapsibleTableViewHeader, section: Int)
}

class CollapsibleTableViewHeader: UITableViewHeaderFooterView,ReusableView {
    
    weak  var delegate: CollapsibleTableViewHeaderDelegate?
    var section: Int = 0
    
    @IBOutlet weak var arrowImage: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    var data:MovieExpandableSection?{
        didSet{
            guard let data = data else { return  }
            bind(data: data)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        contentView.backgroundColor = UIColor.header
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(CollapsibleTableViewHeader.tapHeader(_:))))
        arrowImage.tintColor = UIColor.gray
    }
    
    func bind(data:MovieExpandableSection) {
        label.text = data.header
        arrowImage.image = data.collapsed ? #imageLiteral(resourceName: "expand") : #imageLiteral(resourceName: "collapse")
    }
    
    @objc private func tapHeader(_ gestureRecognizer: UITapGestureRecognizer) {
        guard let cell = gestureRecognizer.view as? CollapsibleTableViewHeader else {
            return
        }
        delegate?.toggleSection(self, section: cell.section)
    }
}
