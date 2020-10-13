//
//  Helpers.swift
//  MyTestApp
//
//  Created by Joe Kletz on 12/10/2020.
//

import Foundation
import UIKit

extension UIImageView{
    func setImage(fromCoreDataNamed imageName: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let imageURL = documentsDirectory.appendingPathComponent("\(imageName).png")
        let image = UIImage(contentsOfFile: imageURL.path)
        self.image = image
    }

}

extension UIView{
    func applyShadow(offset:CGSize,opacity:Float,radius:CGFloat){
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = offset
        layer.shadowOpacity = opacity
        layer.shadowRadius = radius
    }
}

extension String{
    func getEffectArray() -> [String] {
        return self.components(separatedBy: ",")
    }
}
