//
//  Helpers.swift
//  MyTestApp
//
//  Created by Joe Kletz on 12/10/2020.
//

import Foundation
import UIKit
import AVFoundation

//extension UIView {
//    func layerGradient() {
//        let layer : CAGradientLayer = CAGradientLayer()
//        layer.frame.size = self.frame.size
//        layer.frame.origin = CGPoint(x: 0.0,y: 0.0)
//        layer.cornerRadius = CGFloat(frame.width / 20)
//
//        let color0 = UIColor(red:250.0/255, green:250.0/255, blue:250.0/255, alpha:0.5).cgColor
//        let color1 = UIColor(red:200.0/255, green:200.0/255, blue: 200.0/255, alpha:0.1).cgColor
//        let color2 = UIColor(red:150.0/255, green:150.0/255, blue: 150.0/255, alpha:0.1).cgColor
//        let color3 = UIColor(red:100.0/255, green:100.0/255, blue: 100.0/255, alpha:0.1).cgColor
//        let color4 = UIColor(red:50.0/255, green:50.0/255, blue:50.0/255, alpha:0.1).cgColor
//        let color5 = UIColor(red:0.0/255, green:0.0/255, blue:0.0/255, alpha:0.1).cgColor
//        let color6 = UIColor(red:150.0/255, green:150.0/255, blue:150.0/255, alpha:0.1).cgColor
//
//        layer.colors = [color0,color1,color2,color3,color4,color5,color6]
//        self.layer.insertSublayer(layer, at: 0)
//    }
//}


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
