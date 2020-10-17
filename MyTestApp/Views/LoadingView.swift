//
//  LoadingView.swift
//  MyTestApp
//
//  Created by Joe Kletz on 17/10/2020.
//

import UIKit

class LoadingView: UIView {
    
    var spinner : UIActivityIndicatorView = {
        let s = UIActivityIndicatorView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.color = .white
        s.style = .large
        s.startAnimating()
        return s
    }()
    
    var label : UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.font = UIFont(name: "Heebo-Bold", size: 28)
        v.textColor = .white
        v.numberOfLines = 0
        return v
    }()
    
    var contentStack : UIStackView = {
       let i = UIStackView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.axis = .vertical
        i.alignment = .center
        return i
    }()
    
    convenience init(title: String) {
        self.init(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        backgroundColor = UIColor(white: 0.1, alpha: 0.7)
        setupSubviews()
        label.text = title
    }
    
    
    
    func setupSubviews() {
        addSubview(contentStack)
        contentStack.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        contentStack.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        contentStack.widthAnchor.constraint(equalTo: self.widthAnchor).isActive = true
        //contentStack.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        contentStack.addArrangedSubview(spinner)
        contentStack.addArrangedSubview(label)
        
        label.leftAnchor.constraint(equalTo: self.readableContentGuide.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.readableContentGuide.rightAnchor).isActive = true
        
        contentStack.setCustomSpacing(30, after: spinner)
        
    }
}
