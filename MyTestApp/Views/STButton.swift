//
//  STButton.swift
//  MyTestApp
//
//  Created by Joe Kletz on 09/10/2020.
//

import Foundation
import UIKit

class STButton: UIButton {
    
    convenience init(frame: CGRect, fontSize : CGFloat) {
        self.init(frame: frame)
        titleLabel?.font = UIFont(name: "heebo-ExtraBold", size: fontSize)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
