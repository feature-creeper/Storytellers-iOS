//
//  DeepARVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 13/10/2020.
//

import UIKit
import DeepAR

import AVKit

class DeepARVC: UIViewController {
    
    var currentLanguage = 0
    
    
    @IBOutlet weak var arViewContainer: UIView!
    
    private var deepAR: DeepAR!
    private var arView: ARView!
    
    private var cameraController: CameraController!
    
    var maskPath : String!
    
    //    var storyVM : DeepARVM!
    
    var recording = false
    
    
    var content : String?
    
    var bookID : String!
    
    var chapter = 0
    var pageNum = 0
    
    var pages : [String] = []
    
    var spinner = LoadingVideoView(title: "Creating your video")
    
    var exitButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 30, width: 70, height: 70))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .medium)
        let largeBoldDoc = UIImage(systemName: "clear.fill", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = UIColor.white
        button.applyShadow(offset: CGSize(width: 1, height: 1), opacity: 0.3, radius: 4.0)
        return button
    }()
    
    //    var pageBackgroundView : PassthroughView = {
    //       let v = PassthroughView()
    //        v.backgroundColor = .white
    //        v.translatesAutoresizingMaskIntoConstraints = false
    //        v.applyShadow(offset: CGSize.zero, opacity: 0.4, radius: 6.0)
    //        v.isHidden = true
    //        return v
    //    }()
    
    var timerBGView : UIButton = {
        let v = UIButton()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("00:00:00", for: .normal)
        v.contentEdgeInsets = UIEdgeInsets(top: 6, left: 15, bottom: 6, right: 15)
        v.backgroundColor = UIColor.white.withAlphaComponent(0.6)
        v.layer.cornerRadius = 10
        v.setTitleColor(.black, for: .normal)
        v.imageView?.tintColor = .red
        v.imageEdgeInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 15)
        return v
    }()
    
    var startRecordingButton : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Start", for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 30)
        v.setTitleColor(.white, for: .normal)
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        v.backgroundColor = .green
        v.addTarget(self, action: #selector(startRecordTapped), for: .touchUpInside)
        v.layer.cornerRadius = 30
        
        v.setImage(UIImage(named: "RecordIcon"), for: .normal)
        v.adjustsImageWhenHighlighted = false
        
        v.imageView?.contentMode = .scaleAspectFit
        v.imageEdgeInsets = UIEdgeInsets(top: 10, left: -14, bottom: 10, right: 0)
        return v
    }()
    
    var endRecordingButton : UIButton = {
        let v = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Finish", for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 30)
        v.setTitleColor(.white, for: .normal)
        v.contentEdgeInsets = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        v.backgroundColor = .red
        v.addTarget(self, action: #selector(endRecordingTapped), for: .touchUpInside)
        v.layer.cornerRadius = 30
        v.isHidden = true
        return v
    }()
    
    //    var pageLabel : PassthroughLabel = {
    //       let v = PassthroughLabel()
    //        v.translatesAutoresizingMaskIntoConstraints = false
    //        v.font = UIFont(name: Globals.easyRead, size: 19)
    //        v.textColor = UIColor.black
    //        v.numberOfLines = 0
    //        v.lineBreakMode = .byWordWrapping
    //        return v
    //    }()
    
    var instructionLabelContainer : PassthroughView = {
        let v = PassthroughView()
        v.backgroundColor = UIColor.systemBlue
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 10
        v.isHidden = true
        return v
    }()
    
    var popupInstructionLabel : PassthroughLabel = {
        let v = PassthroughLabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: Globals.popupText, size: 22)
        v.textColor = UIColor.white
        v.numberOfLines = 0
        v.lineBreakMode = .byWordWrapping
        v.text = "Swipe to change page"
        return v
    }()
    
    var safeAreaView : UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    let pageIndicatorLabel : UILabel = {
        let v = UILabel()
        v.font = UIFont(name: Globals.semiboldWeight, size: 20)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        v.textColor = .white
        v.text = "0/10"
        v.isHidden = true
        return v
    }()
    
    let detailStack : PassthroughStack = {
        let v = PassthroughStack()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.alignment = .center
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        
        setupDeepARAndCamera()
        
        deepARSwitchEffect(name: pages[pageNum])
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deepAR.shutdown()
    }
    
    
    func deepARSwitchEffect(name:String) {
        
        
        if currentLanguage == 0 {
            let fileManager = FileManager.default
            let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let myEffectPath = documentsURL.appendingPathComponent(name).path
            
            deepAR.switchEffect(withSlot: "masks", path: myEffectPath)
        }else{
            guard let path = Bundle.main.path(forResource: name, ofType:"") else { return }
//            let fileURL = NSURL(fileURLWithPath: path)
            
            deepAR.switchEffect(withSlot: "masks", path: path)
        }
        
        
    }
    
    func setupViews() {
        
        
//        view.addSubview(timerBGView)
        
        view.addSubview(pageIndicatorLabel)
        view.addSubview(endRecordingButton)
        
        view.addSubview(detailStack)
        
        //        view.addSubview(pageBackgroundView)
        view.addSubview(safeAreaView)
        view.addSubview(startRecordingButton)
        
        view.addSubview(exitButton)
        
        
        detailStack.axis = .vertical
        detailStack.spacing = 15
        detailStack.addArrangedSubview(instructionLabelContainer)
        detailStack.addArrangedSubview(pageIndicatorLabel)
        detailStack.addArrangedSubview(endRecordingButton)
        
        instructionLabelContainer.addSubview(popupInstructionLabel)
        popupInstructionLabel.topAnchor.constraint(equalTo: instructionLabelContainer.topAnchor, constant: 15).isActive = true
        popupInstructionLabel.leadingAnchor.constraint(equalTo: instructionLabelContainer.leadingAnchor, constant: 15).isActive = true
        popupInstructionLabel.trailingAnchor.constraint(equalTo: instructionLabelContainer.trailingAnchor, constant: -15).isActive = true
        instructionLabelContainer.bottomAnchor.constraint(equalTo: popupInstructionLabel.bottomAnchor, constant: 15).isActive = true
        
        
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(spinner)
        spinner.isHidden = true
        spinner.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        spinner.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        spinner.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        spinner.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        
//        timerBGView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
//        timerBGView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        startRecordingButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true
        startRecordingButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        startRecordingButton.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        detailStack.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        detailStack.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        
    }
    
    
    private func setupDeepARAndCamera() {
        
        self.deepAR = DeepAR()
        self.deepAR.delegate = self
        self.deepAR.setLicenseKey("8a9e4faccf2770ed93d87e4f90ae9ebb7330e30c824c4c8f43c70d242ccd967e0e0c110a57d9088b")
        
        cameraController = CameraController()
        
        self.arView = self.deepAR.createARView(withFrame: CGRect(x: 0, y: 0, width: view.frame.width - 40, height: view.frame.height - 80)) as! ARView//self.arViewContainer.frame) as! ARView
        self.arView.translatesAutoresizingMaskIntoConstraints = false
        self.arViewContainer.addSubview(self.arView)
        
        let swipeLeftGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedLeft))
        swipeLeftGesture.direction = .left
        self.arViewContainer.addGestureRecognizer(swipeLeftGesture)
        let swipeRightGesture = UISwipeGestureRecognizer(target: self, action: #selector(swipedRight))
        swipeRightGesture.direction = .right
        self.arViewContainer.addGestureRecognizer(swipeRightGesture)
        
        cameraController.arview = arView
        
        self.arView.leftAnchor.constraint(equalTo: self.arViewContainer.leftAnchor).isActive = true
        self.arView.rightAnchor.constraint(equalTo: self.arViewContainer.rightAnchor).isActive = true
        self.arView.topAnchor.constraint(equalTo: self.arViewContainer.topAnchor).isActive = true
        self.arView.bottomAnchor.constraint(equalTo: self.arViewContainer.bottomAnchor).isActive = true
        
        cameraController.startCamera()
        
    }
    
    private func showExitDialogue(message:String, title:String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Save and quit", style: .default, handler: { (action) in
            self.endRecordingTapped()
        }))
        alert.addAction(UIAlertAction(title: "Quit without saving", style: .destructive, handler: { [self] (action) in
            //            storyVM.invalidateTimer()
            self.dismiss(animated: true, completion: nil)
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        self.present(alert, animated: true)
    }
    
    
    
    @objc
    func swipedRight(){
        
        if !recording {
            return
        }
        
        if pageNum > 0 {
            pageNum -= 1
            
            changePage()
        }
        
        
        
    }
    
    @objc
    func swipedLeft(){
        
        if !recording {
            return
        }
        
        if pageNum < pages.count - 1 {
            pageNum += 1
            
            changePage()
        }
        
    }
    
    func changePage() {
        deepARSwitchEffect(name: pages[pageNum])
        
        if pageNum == pages.count - 1 {
            endRecordingButton.isHidden = false
        }else{
            endRecordingButton.isHidden = true
        }
    }
    
    var screenCap : ScreenCapture!
    
    @objc
    func startRecordTapped()  {
        
        timerBGView.setImage(UIImage(systemName: "circlebadge.fill"), for: .normal)
        
        startRecordingButton.isHidden = true
        //        pageBackgroundView.isHidden = false
        //        endRecordingButton.isHidden = false
        pageIndicatorLabel.isHidden = false
        
        //        storyVM.tappedRecord()
        //        storyVM.startTimer()
        
        DispatchQueue.main.async { [self] in
            let width: Int32 = Int32(deepAR.renderingResolution.width)
            let height: Int32 =  Int32(deepAR.renderingResolution.height)
            deepAR.startVideoRecording(withOutputWidth: width, outputHeight: height)
            //            storyVM.recording = true
            
            recording = true
        }
        
    }
    
    @objc
    func dismissTapped()  {
        //        if storyVM.recording {
        //            showExitDialogue(message: "Are you sure?", title: "Quit recording")
        //        }else{
        //            storyVM.invalidateTimer()
        //            self.dismiss(animated: true, completion: nil)
        //        }
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func endRecordingTapped()  {
        
        //storyVM.tappedRecord()
        deepAR.finishVideoRecording()
        recording = false
        //storyVM.recording = false
    }
    
    func lateReturnFunc(){
        print("LATE")
        
        DispatchQueue.global().asyncAfter(deadline: .now() + 5) {
            print("PERFORMED ASYNC FUNC")
        }
    }
    
}

extension DeepARVC : DeepARDelegate {
    
    
    func didInitialize() {
        print("DID INIT")
    }
    
    func didFinishPreparingForVideoRecording() { }
    
    func didStartVideoRecording() {
        print("START RECORDING Protocol")
    }
    
    func didFinishVideoRecording(_ videoFilePath: String!) {
        
        //            storyVM.invalidateTimer()
        spinner.isHidden = false
        
        let documentsDirectory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        let components = videoFilePath.components(separatedBy: "/")
        guard let last = components.last else { return }
        let destination = URL(fileURLWithPath: String(format: "%@/%@", documentsDirectory, last))
        
        print("---> The destination")
        print(last)
        
        
        let seconds = String(Date().timeIntervalSince1970)
        let uniqueFileName = seconds.replacingOccurrences(of: ".", with: "_")
        let videoFileName = uniqueFileName + ".mov"
        
        DatabaseHelper.shared.createVideoMO(bookID: bookID, videoFileName: last, videoURL: URL(fileURLWithPath:videoFilePath)) {
            print("SAVING COMPLETE")
            
            self.dismiss(animated: true, completion: nil)
        }
        
//        let playerController = AVPlayerViewController()
//                let player = AVPlayer(url: destination)
//                playerController.player = player
//                present(playerController, animated: true) {
//                    player.play()
//        }
        
        
//        let videoCompositor = VideoCompositor( bookID : bookID)
//        videoCompositor.delegate = self
//        videoCompositor.composite(url: URL(fileURLWithPath: videoFilePath)) {
//
//            DispatchQueue.main.async {
//                self.spinner.isHidden = true
//                self.dismiss(animated: true, completion: nil)
//
//            }
//        }
        
    }
}
/*
 extension DeepARVC : StoryDelegate{
 
 
 func changedPage(index: Int, totalPages: Int) {
 
 setMask()
 
 pageIndicatorLabel.text = "\(index + 1)/\(totalPages)"
 
 //        slatView.showSlat(index: index)
 
 instructionLabelContainer.isHidden = true
 
 if index == 0 {
 endRecordingButton.isHidden = true
 instructionLabelContainer.isHidden = false
 } else if index == (totalPages - 1){
 endRecordingButton.isHidden = false
 }else{
 endRecordingButton.isHidden = true
 }
 }
 
 func timerAddedSecond(formatted: String) {
 timerBGView.setTitle(formatted, for: .normal)
 }
 }*/

extension DeepARVC :CompositorDelegate{
    func progressUpdated(progress: Float) {
        spinner.progressBar.progress = progress
    }
}


class PassthroughView: UIView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

class PassthroughLabel: UILabel {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}

class PassthroughStack: UIStackView {
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        let view = super.hitTest(point, with: event)
        return view == self ? nil : view
    }
}
