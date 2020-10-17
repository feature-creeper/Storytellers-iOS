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

class VideoCompositor {
    
    var pageTimes : [(Int, Int)]
    
    var myurl: URL?
    
    let view:UIView?
    
    //let storyText:StoryText
    let text:[[String]]
    
    let bookID:String
    
//    init(_ view: UIView, pageTimes: [(Int, Int)],storyText:StoryText) {
//        self.view = view
//        self.pageTimes = pageTimes
//        self.storyText = storyText
//    }
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
                
                
                //                let a = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                //                a?.insertTimeRange(vid_timerange, of: assetAudioTrack, at: CMTime.zero)
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
                
                
                //                let a = composition.addMutableTrack(withMediaType: AVMediaType.audio, preferredTrackID: kCMPersistentTrackID_Invalid)
                //                a?.insertTimeRange(vid_timerange, of: assetAudioTrack, at: CMTime.zero)
            } catch {
                print("error")
            }
            
//            compositionvideoTrack.preferredTransform = videoTrack.preferredTransform
            
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
        
        
        
        
        
        /* Add audio track */
        //        AVMutableCompositionTrack *compositionAudioTrack = [composition addMutableTrackWithMediaType:AVMediaTypeAudio preferredTrackID:kCMPersistentTrackID_Invalid];
        //        [compositionAudioTrack insertTimeRange:fullTime ofTrack:sourceAudioTrack atTime:kCMTimeZero error:nil];
        
        
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
                
//                let fetch = NSFetchRequest<Book>(entityName: "Book")
//                fetch.predicate = NSPredicate(format: "id == %@", bookID)
//                
//                let appDelegate = UIApplication.shared.delegate as! AppDelegate
//                let context = appDelegate.persistentContainer.viewContext
//                
//                let book : Book = try! context.fetch(fetch).first! as Book
//                
//                
//                let video = VideoMO(context: context)
//                video.filename = videoFileName
//                
//                book.addToVideos(video)
                
                DatabaseHelper.shared.createVideoMO(bookID: bookID, videoFileName: videoFileName, videoURL: self.myurl!) {
                    print("SAVING COMPLETE")
                    
                    completion()
                }
                
                
                
                
//                PHPhotoLibrary.shared().performChanges({
//                    PHAssetChangeRequest.creationRequestForAssetFromVideo(atFileURL: movieDestinationUrl as URL)
//
//                }) { saved, error in
//                    if saved {
//                        print("Saved")
//                    }
//                }
                
//                self.playVideo()
            
            }
        })
    }
    
//    func playVideo() {
//        let player = AVPlayer(url: myurl!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view!.bounds
//        self.view!.layer.addSublayer(playerLayer)
//        player.play()
//        print("playing...")
//    }
    
    
    //U can add another white layer that fades in a second before
    
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
//            titleLayer.string = storyText.story[page.0]//"STORY PAGE \(page.0)"//
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
