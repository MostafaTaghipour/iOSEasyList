//
//  MessageBar.swift
//  ListExample-iOS
//
//  Created by Mostafa Taghipour on 1/21/18.
//  Copyright © 2018 RainyDay. All rights reserved.
//

import UIKit

protocol MessageBarDelegate : class{
    func messageBar(didChange height:CGFloat)
    func messageBar(didSend message:String)
    func messageBar(didChange text:String?)
}

extension MessageBarDelegate{
    func messageBar(didChange height:CGFloat){}
    func messageBar(didChange text:String?){}
    func messageBar(didSend message:String){}
}

class MessageBar: UIToolbar {
    
    weak var messageBarDelegate:MessageBarDelegate?
    
    var text:String?{
        get{
            return textView.text
        }
        set{
            textView.text = newValue
        }
    }
    
    lazy var sendButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("SEND", for: .normal)
        btn.tintColor = .black
        btn.setTitleColor(.black, for: .normal)
        btn.setTitleColor(.lightGray, for: .disabled)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        btn.isEnabled=false
        
        self.addSubview(btn)
        
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        btn.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive=true
        btn.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive=true
        
        if #available(iOS 11.0, *) {
            let guide = self.safeAreaLayoutGuide
            btn.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16).isActive=true
        }
        else{
            btn.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16).isActive=true
        }
        
        return btn
    }()
    
    lazy var textView: BaseTextView = { [unowned self] in
        // *** Create GrowingTextView Instance ***
        let textView = BaseTextView()
        //        let borderColor = UIColor(red: CGFloat(204.0 / 255.0), green: CGFloat(204.0 / 255.0), blue: CGFloat(204.0 / 255.0), alpha: CGFloat(1.0))
        //
        //        textView.placeholderColor = borderColor
        //        textView.borderColor=borderColor
        //        textView.borderWidth=1.0
        //        textView.cornerRadius = 4.0
        //        textView.background = .white
        textView.maxLength = 500
        textView.maxHeight = 100
        textView.showsVerticalScrollIndicator=false
        textView.bounces=false
        textView.growing=true
        textView.trimWhiteSpaceWhenEndEditing = true
        textView.placeholder = "Enter message"
        textView.returnKeyType = .send
        textView.font = UIFont.systemFont(ofSize: 16)
        
        // *** Add GrowingTextView into Toolbar
        self.addSubview(textView)
        
        // *** Set Autolayout constraints ***
        textView.translatesAutoresizingMaskIntoConstraints = false
       
        textView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -80).isActive=true
        textView.topAnchor.constraint(equalTo: self.topAnchor, constant: 8).isActive=true
        textView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -8).isActive=true
        
        if #available(iOS 11.0, *) {
           let guide = self.safeAreaLayoutGuide
                textView.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16).isActive=true
        }
        else{
             textView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive=true
        }
        
        return textView
        }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
   fileprivate func commonInit(){
        
        self.translatesAutoresizingMaskIntoConstraints = false
        textView.delegate = self
        sendButton.addTarget(self, action: #selector(send), for: .touchUpInside)
    }
    
    
    @objc fileprivate func send()  {
        guard let text = text , !text.isEmpty else { return  }
        messageBarDelegate?.messageBar(didSend: text)
    }
    
    func reset(){
        text = nil
        sendButton.isEnabled=false
    }
//    
//    //We're adding the bottom constraint here to make sure we belong to window
//    override func didMoveToWindow() {
//        super.didMoveToWindow()
//        if #available(iOS 11.0, *) {
//            if let window = window {
//                bottomAnchor.constraintLessThanOrEqualToSystemSpacingBelow(window.safeAreaLayoutGuide.bottomAnchor, multiplier: 1.0).isActive = true
//            }
//        }
//    }
    
  
    
}

extension MessageBar : BaseTextViewDelegate{
    func textViewDidChange(_ textView: UITextView) {
        
        sendButton.isEnabled = text != nil && !text!.isEmpty
        messageBarDelegate?.messageBar(didChange: text)
    }
    
    func textViewDidChangeHeight(_ textView: BaseTextView, height: CGFloat) {
        messageBarDelegate?.messageBar(didChange: self.frame.height)
    }
    
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            send()
            return false
        }
        return true
    }
}
