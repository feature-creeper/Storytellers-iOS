//
//  Helpers.swift
//  MyTestApp
//
//  Created by Joe Kletz on 12/10/2020.
//

import Foundation
import UIKit
import AVFoundation

extension UIViewController{
    func showDialogue(message:String, title:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))

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
