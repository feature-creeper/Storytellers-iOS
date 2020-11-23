//
//  VideoCompositor.swift
//  MyTestApp
//
//  Created by Joe Kletz on 14/10/2020.
//


import UIKit
import AVFoundation
import Photos
import CoreData

//PROBABLY COULD MAKE COMPOSITION EASIER IF APPLIED TO PARENT
//textLayer.isGeometryFlipped = true

//Make only a few pages, do not load all pages as layers

class VideoCompositor {
    
    var pageTimes : [(Int, TimeInterval,Bool)]
    
    var myurl: URL?
    
//    let view:UIView?
    
    let text:[[String]]
   
    let bookID:String
    
    var completionTimer : Timer?
    
    var assetExport : AVAssetExportSession?
    
    var delegate : CompositorDelegate?
    
    init(//_ view: UIView,
         pageTimes: [(Int, TimeInterval,Bool)],storyText:[[String]], bookID : String) {
//        self.view = view
        self.pageTimes = pageTimes
        self.text = storyText
        self.bookID = bookID
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
//        let size = videoTrack.naturalSize
        
        let screenBounds = UIScreen.main.bounds
        let screenScale = UIScreen.main.scale
        let screenSize = CGSize(width: screenBounds.size.width * screenScale, height: screenBounds.size.height * screenScale)
        
        
        let videolayer = CALayer()
        videolayer.frame = CGRect(x: 0, y: pageHeight - 280, width: screenSize.width, height: screenSize.height)
        
        
        let parentlayer = CALayer()
        parentlayer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: screenSize.height)
        parentlayer.addSublayer(videolayer)
        
        let pageLayer = CALayer()
        pageLayer.backgroundColor = UIColor.white.cgColor
        pageLayer.frame = CGRect(x: 0, y: 0, width: screenSize.width, height: pageHeight)
        
        parentlayer.addSublayer(pageLayer)

        createTextLayers(parentLayer: pageLayer, pageHeight: pageHeight, size: screenSize)
        
        
        let layercomposition = AVMutableVideoComposition()
        layercomposition.frameDuration = CMTimeMake(value: 1, timescale: 25)
        layercomposition.renderSize = screenSize
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
        assetExport = AVAssetExportSession(asset: composition, presetName:AVAssetExportPresetHighestQuality)
        assetExport?.outputFileType = AVFileType.mov
        assetExport?.videoComposition = layercomposition
        
        // Check exist and remove old file
        FileManager.default.removeItemIfExisted(movieDestinationUrl as URL)
        
        //Progress indicator
        if let progress = assetExport?.progress{
             completionTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(fireTimer), userInfo: nil, repeats: true)
        }
        
        
        assetExport?.outputURL = movieDestinationUrl as URL
        assetExport?.exportAsynchronously(completionHandler: { [self] in
            switch assetExport!.status {
        
            case AVAssetExportSession.Status.failed:
                print("failed")
                print(assetExport?.error ?? "unknown error")
                completionTimer!.invalidate()
            case AVAssetExportSession.Status.cancelled:
                print("cancelled")
                print(assetExport?.error ?? "unknown error")
                completionTimer!.invalidate()
            default:
                print("Movie complete")
                completionTimer!.invalidate()
                
                self.myurl = movieDestinationUrl as URL
                
                DatabaseHelper.shared.createVideoMO(bookID: bookID, videoFileName: videoFileName, videoURL: self.myurl!) {
                    print("SAVING COMPLETE")
                    
                    completion()
                }
                
                
            }
        })
    }

    
    func createTextLayers(parentLayer:CALayer, pageHeight : CGFloat, size : CGSize) {
        
        var pageIndex = 0
        
        for page in text[0] {
            let pageLayer = makePage(pageHeight: pageHeight, size: size, pageText: page)
            
            for pageData in pageTimes {
                
                let pageNumber = pageData.0
                let pageTimeInterval = pageData.1
                let pageNext = pageData.2
                
                if pageNumber == pageIndex {
                    if pageNext == true { // Next page
                        let anim = nextPageAnimation(pageLayer: pageLayer, begin: pageTimeInterval)
                        pageLayer.add(anim, forKey: nil)
                    }else{ //Show prev page animation
                        let anim = prevPageAnimation(pageLayer: pageLayer, begin: pageTimeInterval)
                        pageLayer.add(anim, forKey: nil)
                    }
                }
            }
            
            parentLayer.insertSublayer(pageLayer, at: 1)
            
            pageIndex += 1
        }
      
    }
    
    func nextPageAnimation(pageLayer:CALayer, begin: TimeInterval) -> CAAnimationGroup {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = begin
        groupAnimation.duration = 0.7
        
        
        let position = CABasicAnimation(keyPath: "position")
        //position.fromValue = pageLayer.position
        position.toValue = [-(pageLayer.bounds.width * 1.5) ,  pageLayer.position.y]
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        //rotate.fromValue = 0.0
        rotate.toValue = .pi/180.0 * 20
        
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        
        groupAnimation.animations = [position,rotate]
        
        return groupAnimation
    }
    
    func prevPageAnimation(pageLayer:CALayer, begin: TimeInterval) -> CAAnimationGroup {
        let groupAnimation = CAAnimationGroup()
        groupAnimation.beginTime = begin
        groupAnimation.duration = 0.7
        
        
        let position = CABasicAnimation(keyPath: "position")
        position.toValue = pageLayer.position
        position.fromValue = [-(pageLayer.bounds.width * 1.5) ,  pageLayer.position.y]
        let rotate = CABasicAnimation(keyPath: "transform.rotation")
        rotate.toValue = 0.0
        rotate.fromValue = .pi/180.0 * 20
        
        groupAnimation.isRemovedOnCompletion = false
        groupAnimation.fillMode = .forwards
        
        groupAnimation.animations = [position,rotate]
        
        return groupAnimation
    }
    
    func makePage(pageHeight : CGFloat, size : CGSize, pageText:String) -> CALayer {
        let pageBackgroundLayer = CALayer()
        pageBackgroundLayer.backgroundColor = UIColor.white.cgColor
        pageBackgroundLayer.frame = CGRect(x: 0, y: 0, width: size.width * 2, height: pageHeight * 2)
        

        pageBackgroundLayer.position = CGPoint(x: 0, y: 0)
        
        pageBackgroundLayer.shadowColor = UIColor.black.cgColor
        pageBackgroundLayer.shadowOffset = CGSize(width: 0, height: 0)
        pageBackgroundLayer.shadowOpacity = 0.4
        pageBackgroundLayer.shadowRadius = 15.0
        
        let textBorder : CGFloat = 70
        
        let textLayer = CATextLayer()
        textLayer.backgroundColor = UIColor.white.cgColor
        textLayer.string = pageText
        textLayer.font = UIFont(name: Globals.easyRead, size: 35)
        textLayer.fontSize = 70
        textLayer.foregroundColor = UIColor.black.cgColor
        textLayer.alignmentMode = CATextLayerAlignmentMode.left
        
        textLayer.anchorPoint = CGPoint(x: 0, y: 0)
        textLayer.position = CGPoint(x: size.width + textBorder, y: pageHeight + textBorder)
        textLayer.isWrapped = true
        textLayer.bounds.size.width = size.width - (textBorder * 2)
        textLayer.bounds.size.height = pageHeight - (textBorder * 2)
    

        
        pageBackgroundLayer.addSublayer(textLayer)
        
        return pageBackgroundLayer
    }
    
    @objc func fireTimer(timer:Timer) {
        
        print( assetExport?.progress)
 
        if let progress = assetExport?.progress {
            delegate?.progressUpdated(progress: progress)
        }
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

protocol CompositorDelegate {
    func progressUpdated(progress:Float)
}
