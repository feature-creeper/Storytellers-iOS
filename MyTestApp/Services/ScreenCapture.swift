//
//  ScreenCapture.swift
//  MyTestApp
//
//  Created by Joe Kletz on 09/11/2020.
//

import UIKit
import AVFoundation
import ReplayKit

class ScreenCapture: NSObject, RPPreviewViewControllerDelegate {
    
    var recording = false

    let rp = RPScreenRecorder.shared()
    var ovc : UIViewController?
    
    override init() {
        
        super.init()
    
        rp.startRecording { (err) in
        }
        
    }
    
    func stop() {
        
        let vc = RPPreviewViewController()
        vc.previewControllerDelegate = self
        
        rp.stopRecording { (vc, err) in
            self.ovc!.present(vc!, animated: true, completion: nil)
        }
    }
    
    
}
