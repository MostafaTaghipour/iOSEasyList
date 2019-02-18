//
//  ViewController.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/4/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

class MainVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title="Easy List"
        self.navigationController?.navigationBar.prefersLargeTitles=true
        
    }
    
    
    @IBAction func goToPaginationVC(_ sender: Any) {
        let vc = EndlessVC(nibName: "EndlessVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func goToSectionedVC(_ sender: Any) {
        let vc = SectionedVC(nibName: "SectionedVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func goToExpandableVC(_ sender: Any) {
        let vc = ExpandableVC(nibName: "ExpandableVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func goToAnimationVC(_ sender: Any) {
        let vc = AnimationVC(nibName: "AnimationVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToFilteringVC(_ sender: Any) {
        let vc = FilteringVC(nibName: "FilteringVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToLayoutVC(_ sender: Any) {
        let vc = LayoutVC(nibName: "LayoutVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func goToMessageingVC(_ sender: Any) {
        let vc = MessagingVC(nibName: "MessagingVC", bundle: nil)
        self.navigationController?.pushViewController(vc, animated: true)
    
//        if let vc = UIStoryboard(name: "messaging", bundle: nil).instantiateViewController(withIdentifier: "MessagingVC") as? MessagingVC {
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
    }
}

