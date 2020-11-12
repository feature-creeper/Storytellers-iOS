//
//  LoadingVideoView.swift
//  MyTestApp
//
//  Created by Joe Kletz on 09/11/2020.
//

import UIKit

class LoadingVideoView: UIView {
    
    var progressBar : UIProgressView = {
        let s = UIProgressView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.trackTintColor = UIColor.black.withAlphaComponent(0.5)
        s.progressTintColor = .white
        s.layer.cornerRadius = 4
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
        
        contentStack.addArrangedSubview(label)
        contentStack.addArrangedSubview(progressBar)
        
        label.leftAnchor.constraint(equalTo: self.readableContentGuide.leftAnchor).isActive = true
        label.rightAnchor.constraint(equalTo: self.readableContentGuide.rightAnchor).isActive = true
        
        progressBar.widthAnchor.constraint(equalTo: contentStack.widthAnchor, constant: -80).isActive = true
//        progressBar.heightAnchor.constraint(equalToConstant: 8).isActive = true
        
        contentStack.setCustomSpacing(30, after: label)
        
    }
}
