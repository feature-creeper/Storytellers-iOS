//
//  VideoCompositor.swift
//  MyTestApp
//
//  Created by Joe Kletz on 14/10/2020.
//


import UIKit
import AVFoundation
//import AVKit
import Photos
import CoreData

//PROBABLY COULD MAKE COMPOSITION EASIER IF APPLIED TO PARENT
//        textLayer.isGeometryFlipped = true


class VideoCompositor {
    
    var pageTimes : [(Int, Int)]
    
    var myurl: URL?
    
    let view:UIView?
    
    let text:[[String]]
    
    let bookID:String
    
    init(_ view: UIView, pageTimes: [(Int, Int)],storyText:[[String]], bookID : String) {
        self.view = view
        self.pageTimes = pageTimes
        self.text = storyText
        self.bookID = bookID
        print("STORY TEXT: \(storyText)")
    }
    
    func composite(url:URL, completion: @escaping () -> Void) {
        
        let composition = AVMutableComposition()
        let vidAsset = AVAsset(url: url)
        
        // get video track
        let vtrack =  vidAsset.tracks(withMediaType: AVMediaType.video)
        
        let assetAudioTrack: AVAssetTrack = vidAsset.tracks(withMediaType: AVMediaType.audio)[0]
        
        
        let videoTrack: AVAssetTrack = vtrack[0]
        let vid_timerange = CMTimeRangeMake(start: CMTime.zero, duration: vidAsset.duration)
        
        let tr: CMTimeRange = CMTimeRange(start: CMTime.zero, duration: CMTime(seconds: 1.0, preferredTimescale: 600))
        composition.insertEmptyTimeRange(tr)
        
        let trackID:CMPersistentTrackID = CMPersistentTrackID(kCMPersistentTrackID_Invalid)
        
        
        
        if let compositionvideoTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.video, preferredTrackID: trackID) {
            
            do {
                try compositionvideoTrack.insertTimeRange(vid_timerange, of: videoTrack, at: CMTime.zero)
                
            } catch {
                print("error")
            }
            
            compositionvideoTrack.preferredTransform = videoTrack.preferredTransform
            
        } else {
            print("unable to add video track")
            return
        }
        
        if let compositionaudioTrack: AVMutableCompositionTrack = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: trackID) {
            
            do {
                try compositionaudioTrack.insertTimeRange(vid_timerange, of: assetAudioTrack, at: CMTime.zero)
                
            } catch {
                print("error")
            }
            
        } else {
            print("unable to add video track")
            return
        }
        
        
        let pageHeight : CGFloat = 550
        
        
        // Watermark Effect
        let size = videoTrack.naturalSize
        
        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: pageHeight, width: size.width, height: size.height - 100)
        
        let parentlayer = CALayer()
        parentlayer.backgroundColor = UIColor.white.cgColor
        parentlayer.frame = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        parentlayer.addSublayer(videolayer)
        
        createTextLayers(parentLayer: parentlayer,pageHeight: pageHeight,size: size)
        
        
        
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 30)
        layercomposition.renderSize = size
        layercomposition.animationTool = AVVideoCompositionCoreAnimationTool(postProcessingAsVideoLayer: videolayer, in: parentlayer)
        
        
        
        
        // instruction for watermark
        let instruction = AVMutableVideoCompositionInstruction()
        instruction.timeRange = CMTimeRangeMake(start: CMTime.zero, duration: composition.duration)
        
        
        let videotrack = composition.tracks(withMediaType: AVMediaType.video)[0] as AVAssetTrack
        
        let layerinstruction = AVMutableVideoCompositionLayerInstruction(assetTrack: videotrack)
        instruction.layerInstructions = NSArray(object: layerinstruction) as [AnyObject] as! [AVVideoCompositionLayerInstruction]
        layercomposition.instructions = NSArray(object: instruction) as [AnyObject] as! [AVVideoCompositionInstructionProtocol]
        
        //  create new file to receive data
        let dirPaths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let docsDir = dirPaths[0] as NSString
        
        let seconds = String(Date().timeIntervalSince1970)
        let uniqueFileName = seconds.replacingOccurrences(of: ".", with: "_")
        let videoFileName = uniqueFileName + ".mov"
        
        let movieFilePath = docsDir.appendingPathComponent(videoFileName)
        let movieDestinationUrl = NSURL(fileURLWithPath: movieFilePath)
        
        // use AVAssetExportSession to export video
        let assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = AVFileType.mov
        assetExport?.videoComposition = layercomposition
        
        // Check exist and remove old file
        FileManager.default.removeItemIfExisted(movieDestinationUrl as URL)
        
        assetExport?.outputURL = movieDestinationUrl as URL
        assetExport?.exportAsynchronously(completionHandler: { [self] in
            switch assetExport!.status {
            case AVAssetExportSession.Status.failed:
                print("failed")
                print(assetExport?.error ?? "unknown error")
            case AVAssetExportSession.Status.cancelled:
                print("cancelled")
                print(assetExport?.error ?? "unknown error")
            default:
                print("Movie complete")
                
                self.myurl = movieDestinationUrl as URL
                
                DatabaseHelper.shared.createVideoMO(bookID: bookID, videoFileName: videoFileName, videoURL: self.myurl!) {
                    print("SAVING COMPLETE")
                    
                    completion()
                }
                
                
            }
        })
    }
    
    func createTextLayers(parentLayer:CALayer, pageHeight : CGFloat, size : CGSize) {
        
        
        //for page in pageTimes {
        
        let pageBackgroundLayer = CALayer()
        pageBackgroundLayer.backgroundColor = UIColor.white.cgColor
        pageBackgroundLayer.frame = CGRect(x: 0, y: 0, width: size.width * 2, height: pageHeight * 2)
        
//        pageBackgroundLayer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
//        pageBackgroundLayer.anchorPoint = CGPoint(x: 0, y: 0)
        pageBackgroundLayer.position = CGPoint(x: 0, y: 0)
        
        pageBackgroundLayer.shadowColor = UIColor.black.cgColor
        pageBackgroundLayer.shadowOffset = CGSize(width: 0, height: 0)
        pageBackgroundLayer.shadowOpacity = 0.4
        pageBackgroundLayer.shadowRadius = 15.0
        
        let textBorder : CGFloat = 70
        
        let textLayer = CATextLayer()
        textLayer.backgroundColor = UIColor.white.cgColor
        textLayer.string = "TEST PAGE ASDFAF ASDG ASDASD S GSGS GGSD GG G SGTEST PAGE ASDFAF ASDG ASDASD S GSGS GGSD GG G SGTEST PAGE ASDFAF ASDG ASDASD S GSGS GGSD GG G SGTEST PAGE ASDFAF ASDG ASDASD"//text[0][page.0]
        textLayer.font = UIFont(name: Globals.easyRead, size: 0)
        textLayer.fontSize = 45
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        
        textLayer.anchorPoint = CGPoint(x: 0, y: 0)
        //IGNORE FRAME X, Y
        //textLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: pageHeight)
        textLayer.position = CGPoint(x: size.width + textBorder, y: pageHeight + textBorder)
        textLayer.isWrapped = true
        textLayer.bounds.size.width = size.width - (textBorder * 2)
        textLayer.bounds.size.height = pageHeight - (textBorder * 2)
    

        
        pageBackgroundLayer.addSublayer(textLayer)
        parentLayer.addSublayer(pageBackgroundLayer)
        
        //CREATE TIME FROM BEGINNING OF SESSION
        
        //            var outTime : Double = 0;
        //            for item in pageTimes {
        //                if item.0 <= page.0 {
        //                    outTime += Double(item.1)
        //                }
        //            }
        //            let startTimeMilliseconds = outTime / 1000
        
        print("STARTTIME")
        //print(startTimeMilliseconds)
        
        
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = 1
        groupAnimation.duration = 0.7
        
//        let animation = CABasicAnimation(keyPath: "position")
//        animation.fromValue = pageBackgroundLayer.position
//        animation.toValue = [-(pageBackgroundLayer.bounds.width * 1.5) ,  pageBackgroundLayer.position.y]
//        animation.duration = 1
//        animation.beginTime = 1
        //animation.fillMode = CAMediaTimingFillMode.forwards;
        
        let position = CABasicAnimation(keyPath: "position")
        position.fromValue = pageBackgroundLayer.position
        position.toValue = [-(pageBackgroundLayer.bounds.width * 1.5) ,  pageBackgroundLayer.position.y]
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.fromValue = 0.0
        rotate.toValue = .pi/180.0 * 20
        
        //animation.isRemovedOnCompletion = false
        groupAnimation.animations = [position,rotate]
        pageBackgroundLayer.add(groupAnimation, forKey: nil)
        //}
    }
}

extension FileManager {
    func removeItemIfExisted(_ url:URL) -> Void {
        if FileManager.default.fileExists(atPath: url.path) {
            do {
                try FileManager.default.removeItem(atPath: url.path)
            }
            catch {
                print("Failed to delete file")
            }
        }
    }
}


/*
 //OLD FADE ANIMATED PAGES
 func createTextLayers(parentLayer:CALayer, pageHeight : CGFloat, size : CGSize) {
 
 
 for page in pageTimes {
 
 print("PAGE ------------>")
 
 print(text[0][page.0])
 
 let animationParentLayer = CALayer()
 animationParentLayer.opacity = 0
 animationParentLayer.backgroundColor = UIColor.white.cgColor
 animationParentLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: pageHeight)
 
 let titleLayer = CATextLayer()
 
 titleLayer.backgroundColor = UIColor.white.cgColor
 
 titleLayer.string = text[0][page.0]
 titleLayer.font = UIFont(name: "Helvetica", size: 56)
 titleLayer.foregroundColor = UIColor.black.cgColor
 titleLayer.shadowOpacity = 0.5
 titleLayer.alignmentMode = CATextLayerAlignmentMode.left
 titleLayer.frame = CGRect(x: 0, y: 0, width: size.width, height: pageHeight)
 titleLayer.isWrapped = true
 titleLayer.fontSize = 70
 titleLayer.shadowOpacity = 0
 titleLayer.bounds.size.width = size.width - 70
 titleLayer.bounds.size.height = pageHeight - 70
 
 animationParentLayer.addSublayer(titleLayer)
 parentLayer.addSublayer(animationParentLayer)
 
 
 //Fade in animation
 
 var startTime : Double = 0.1;
 for item in pageTimes {
 if item.0 < page.0 {
 startTime += Double(item.1)
 }
 }
 
 let startTimeMilliseconds = startTime / 1000
 
 
 
 let animation = CABasicAnimation(keyPath: "opacity")
 animation.fromValue = 0
 animation.toValue = 1
 animation.duration = 1
 animation.beginTime = CFTimeInterval(floatLiteral: startTimeMilliseconds)//CFTimeInterval(exactly: 5)!//AVCoreAnimationBeginTimeAtZero//
 animation.fillMode = CAMediaTimingFillMode.forwards;
 animation.isRemovedOnCompletion = false
 animationParentLayer.add(animation, forKey: "opacity")
 
 
 //Fade out animation
 
 var outTime : Double = 0;
 for item in pageTimes {
 if item.0 <= page.0 {
 outTime += Double(item.1)
 }
 }
 
 let outTimeMilliseconds = outTime / 1000 - 1
 
 let fadeOutAnimation = CABasicAnimation(keyPath: "opacity")
 fadeOutAnimation.fromValue = 1
 fadeOutAnimation.toValue = 0
 fadeOutAnimation.duration = 1
 fadeOutAnimation.beginTime = CFTimeInterval(floatLiteral: outTimeMilliseconds)//CFTimeInterval(exactly: 5)!//AVCoreAnimationBeginTimeAtZero//
 fadeOutAnimation.fillMode = CAMediaTimingFillMode.forwards;
 fadeOutAnimation.isRemovedOnCompletion = false
 
 titleLayer.add(fadeOutAnimation, forKey: "opacity")
 
 
 print("PAGE \(page.0) IN \(startTimeMilliseconds) OUT \(outTimeMilliseconds)")
 }
 */
