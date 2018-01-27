//
//  AppHelpers.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/5/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire

extension String {
    subscript(value: PartialRangeUpTo<Int>) -> Substring {
        get {
            return self[..<index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeThrough<Int>) -> Substring {
        get {
            return self[...index(startIndex, offsetBy: value.upperBound)]
        }
    }
    
    subscript(value: PartialRangeFrom<Int>) -> Substring {
        get {
            return self[index(startIndex, offsetBy: value.lowerBound)...]
        }
    }
}


extension UIImageView{
    func loadImageFromWeb(url:String,width:Int = 150){
        kf.indicatorType = .activity
       kf.setImage(with: URL(string: API.baseImageUrl + "w\(width)" + url))
    }
}



extension UIColor{
    static let backgroundColor=UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    static let header=UIColor(red: 230/255, green: 230/255, blue: 231/255, alpha: 1.0)
    static let placeHolder=UIColor(red: 170/255, green: 173/255, blue: 196/255, alpha: 1.0)
}

extension NSObject {
    var className: String {
        return String(describing: type(of: self)).components(separatedBy: ".").last!
    }
    
    class var className: String {
        return String(describing: self).components(separatedBy: ".").last!
    }
}

extension UIActivityIndicatorView{
    
    var animating:Bool{
        set{
            if newValue{
                startAnimating()
            }
            else{
                stopAnimating()
            }
        }
        get{
            return isAnimating
        }
    }
    
}

@IBDesignable
class CardImageView: UIImageView {
    
    @IBInspectable var cornerRadius: CGFloat = 3
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds=true
    }
    
}

@IBDesignable
class CardView: UIView {
    
    @IBInspectable var cornerRadius: CGFloat = 3
    
    @IBInspectable var shadowOffsetWidth: CGFloat = 0
    @IBInspectable var shadowOffsetHeight: CGFloat = 0.5
    @IBInspectable var shadowColor: UIColor? = UIColor.darkGray
    @IBInspectable var shadowOpacity: Float = 0.3
    
    override func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight)
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
        
    }
    
}




class NibView: UIView {
    var view: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        // Setup view from .xib file
        xibSetup()
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Setup view from .xib file
        xibSetup()
        commonInit()
    }
    
    func commonInit(){
        
    }
    
   private func xibSetup() {
        backgroundColor = UIColor.clear
        view = loadNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Adding custom subview on top of our view
        addSubview(view)
        
        view.translatesAutoresizingMaskIntoConstraints = false
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[childView]|",
                                                      options: [],
                                                      metrics: nil,
                                                      views: ["childView": view]))
    }
    
   private func loadNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nibName = type(of: self).description().components(separatedBy: ".").last!
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(withOwner: self, options: nil).first as! UIView
    }
}


extension UIView {
    func roundCorners(corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}

public extension Float {
    /// SwiftRandom extension
    public static func random(lower: Float = 0, _ upper: Float = 100) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (upper - lower) + lower
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
        //RESOLVED CRASH HERE
    }
    
    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    
    static func formatDateTime(milis:Int64)->String{
        let date = Date(milliseconds: milis)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = NSCalendar.current.isDateInToday(date) ? "HH:mm" : "MMMM dd"
         return dateFormatter.string(from: date)
    }
}



struct Connectivity {
    static let sharedInstance = NetworkReachabilityManager()!
    static var isConnectedToInternet:Bool {
        return self.sharedInstance.isReachable
    }
}


struct InternetConnectionError:Error {
    
}


class GradientView: UIView {
    override open class var layerClass: AnyClass {
        return CAGradientLayer.classForCoder()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        let gradientLayer = self.layer as! CAGradientLayer
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
    }
}
