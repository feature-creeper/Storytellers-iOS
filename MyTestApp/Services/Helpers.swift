//
//  Helpers.swift
//  MyTestApp
//
//  Created by Joe Kletz on 12/10/2020.
//

import Foundation
import UIKit
import AVFoundation


extension UIImage {
    func colorImage(with color: UIColor) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        UIGraphicsBeginImageContext(self.size)
        let contextRef = UIGraphicsGetCurrentContext()

        contextRef?.translateBy(x: 0, y: self.size.height)
        contextRef?.scaleBy(x: 1.0, y: -1.0)
        let rect = CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height)

        contextRef?.setBlendMode(CGBlendMode.normal)
        contextRef?.draw(cgImage, in: rect)
        contextRef?.setBlendMode(CGBlendMode.sourceIn)
        color.setFill()
        contextRef?.fill(rect)

        let coloredImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return coloredImage
    }
}

extension UIViewController{
    func showDialogue(message:String, title:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel))

        self.present(alert, animated: true)
    }
}

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
    
    func getEffectSequenceArray() -> [[String:Any]]{
        let effectSequenceSeperated = self.split(separator: "}")
        
        var effectSequence : [[String:Any]] = []
        effectSequenceSeperated.forEach { (effectString) in
            var item : String = String(effectString)
            item.append("}")
            
            let json = try? JSONSerialization.jsonObject(with: item.data(using: .utf8)!, options: []) as! [String:Any]
            
            if let effectJson = json{
                effectSequence.append(effectJson)
            }
        }
        
        return effectSequence
    }
}

extension URL{
    public func imageFromVideoURL( at time: TimeInterval, completion: @escaping (Data?) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let asset = AVURLAsset(url: self)

            let assetIG = AVAssetImageGenerator(asset: asset)
            assetIG.appliesPreferredTrackTransform = true
            assetIG.apertureMode = AVAssetImageGenerator.ApertureMode.encodedPixels

            let cmTime = CMTime(seconds: time, preferredTimescale: 60)
            let thumbnailImageRef: CGImage
            do {
                thumbnailImageRef = try assetIG.copyCGImage(at: cmTime, actualTime: nil)
            } catch let error {
                print("Error: \(error)")
                return completion(nil)
            }
            
            let image = UIImage(cgImage: thumbnailImageRef)
            let jpegData = image.jpegData(compressionQuality: 0.5)

            DispatchQueue.main.async {
                completion(jpegData)
                //completion()
            }
        }
    }
}
