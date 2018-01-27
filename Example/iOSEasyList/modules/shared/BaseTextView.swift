//
//  BaseTextView.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/21/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol BaseTextViewDelegate: UITextViewDelegate {
    @objc optional func textViewDidChangeHeight(_ textView: BaseTextView, height: CGFloat)
}

@IBDesignable @objc
open class BaseTextView: UITextView {
    
    
    // Maximum length of text. 0 means no limit.
    @IBInspectable open var maxLength: Int = 0
    
    // Trim white space and newline characters when end editing. Default is true
    @IBInspectable open var trimWhiteSpaceWhenEndEditing: Bool = false
    
    // Maximm height of the textview
    @IBInspectable open var maxHeight: CGFloat = CGFloat(0)
    
    // growing textviewbox
    @IBInspectable open var growing: Bool = false
    
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet{
            layoutSubviews()
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet{
            layoutSubviews()
        }
    }
    @IBInspectable var borderColor: UIColor = .clear {
        didSet{
            layoutSubviews()
        }
    }
    
    
    @IBInspectable var background: UIColor = .clear {
        didSet{
            layoutSubviews()
        }
    }
    
    
    
    // Placeholder properties
    private var _placeholderLabel:UILabel?
    @IBInspectable public var placeholder: String? {
        get {
            return _placeholderLabel?.text
        }
        set {
            if let placeholderLabel = _placeholderLabel {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue!)
            }
        }
    }
    
    // Placeholder color properties
    @IBInspectable public var placeholderColor: UIColor = UIColor.lightGray {
        didSet {
            if let placeholderLabel = _placeholderLabel {
                placeholderLabel.textColor=placeholderColor
            }
        }
    }
    
    
    override open var font: UIFont?{
        didSet{
            if let placeholderLabel = _placeholderLabel {
                placeholderLabel.font=font
            }
        }
    }
    
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }
    
    override open var textContainerInset:  UIEdgeInsets{
        didSet{
            self.resizePlaceholder()
        }
    }
    
    
    
    override open var text: String! {
        didSet {
            self.textDidChanged(textView: self)
            setNeedsDisplay()
        }
    }
    
    fileprivate weak var heightConstraint: NSLayoutConstraint?
    
    // Initialize
    override public init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        commonInit()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    open override var intrinsicContentSize: CGSize {
        return CGSize(width: UIViewNoIntrinsicMetric, height: 38)
    }
    
    func associateConstraints() {
        // iterate through all text view's constraints and identify
        // height,from: https://github.com/legranddamien/MBAutoGrowingTextView
        for constraint in self.constraints {
            if (constraint.firstAttribute == .height) {
                if (constraint.relation == .equal) {
                    self.heightConstraint = constraint;
                }
            }
        }
    }
    
    // Listen to UITextView notification to handle trimming, placeholder and maximum length
    fileprivate func commonInit() {
        self.contentMode = .redraw
        associateConstraints()
        NotificationCenter.default.addObserver(self, selector: #selector(textDidChange), name: NSNotification.Name.UITextViewTextDidChange, object: self)
        NotificationCenter.default.addObserver(self, selector: #selector(textDidEndEditing), name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    // Remove notification observer when deinit
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidChange, object: self)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UITextViewTextDidEndEditing, object: self)
    }
    
    // Calculate height of textview
    private var oldText = ""
    private var oldWidth = CGFloat(0)
    private func handleHeight(){
        guard growing else {
            return
        }
        
        if text == oldText && oldWidth == bounds.width { return }
        oldText = text
        oldWidth = bounds.width
        
        let size = sizeThatFits(CGSize(width:bounds.size.width, height: CGFloat.greatestFiniteMagnitude))
        let height = maxHeight > 0 ? min(size.height, maxHeight) : size.height
        
        if (heightConstraint == nil) {
            heightConstraint = NSLayoutConstraint(item: self, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: height)
            addConstraint(heightConstraint!)
        }
        
        if height != heightConstraint?.constant {
            self.heightConstraint!.constant = height;
            scrollRangeToVisible(NSMakeRange(0, 0))
            if let delegate = delegate as? BaseTextViewDelegate {
                delegate.textViewDidChangeHeight?(self, height: height)
            }
        }
    }
    
    
    
    // Trim white space and new line characters when end editing.
    @objc func textDidEndEditing(notification: Notification) {
        if let notificationObject = notification.object as? BaseTextView {
            if notificationObject === self {
                if trimWhiteSpaceWhenEndEditing {
                    text = text?.trimmingCharacters(in: .whitespacesAndNewlines)
                    setNeedsDisplay()
                }
            }
        }
    }
    
    // Limit the length of text
    @objc open func textDidChange(notification: Notification) {
        if let notificationObject = notification.object as? BaseTextView {
            if notificationObject === self {
                if maxLength > 0 && text.characters.count > maxLength {
                    
                    let endIndex = text.index(text.startIndex, offsetBy: maxLength)
                    text = String(text[..<endIndex])
                    undoManager?.removeAllActions()
                }
                setNeedsDisplay()
                
                
                if let placeholderLabel = _placeholderLabel {
                    placeholderLabel.isHidden = self.text.characters.count > 0
                }
            }
        }
    }
    
    //placeHolder visibility
    open func textDidChanged(textView: UITextView) {
        
        if let placeholderLabel = _placeholderLabel {
            placeholderLabel.isHidden = textView.text.characters.count > 0
        }
    }
    
    
    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = _placeholderLabel {
            let labelX = self.textContainer.lineFragmentPadding + textContainerInset.left
            let labelY = self.textContainerInset.top - 2
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = placeholderLabel.frame.height
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }
    
    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String)
    {
        
        _placeholderLabel = UILabel()
        
        _placeholderLabel!.text = placeholderText
        _placeholderLabel!.sizeToFit()
        
        _placeholderLabel!.font = self.font
        _placeholderLabel!.textColor = placeholderColor
        
        _placeholderLabel!.isHidden = self.text.characters.count > 0
        
        self.addSubview(_placeholderLabel!)
        self.resizePlaceholder()
    }
    
    
    
    
    
    // handle view layer
    private func handleLayer() {
        
        layer.borderWidth = borderWidth
        layer.borderColor = borderColor.cgColor
        layer.backgroundColor = background.cgColor
        layer.cornerRadius = cornerRadius
        layer.masksToBounds=true
        clipsToBounds = true
       
        if growing{
            let path = UIBezierPath(roundedRect: bounds.insetBy(dx: 0.5, dy: 0.5), cornerRadius: cornerRadius)
            let mask = CAShapeLayer()
            
            mask.path = path.cgPath
            layer.mask = mask
        }
        
        
    }
    
    
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        
        handleLayer()
        handleHeight()
    }
}

