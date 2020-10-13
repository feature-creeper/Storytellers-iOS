//
//  DeepARVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 13/10/2020.
//

import UIKit
import DeepAR

class DeepARVC: UIViewController {
    
    @IBOutlet weak var arViewContainer: UIView!
    
    
    private var deepAR: DeepAR!
    private var arView: ARView!
    
    private var cameraController: CameraController!
    
    private var isRecordingInProcess: Bool = false
    
    var maskPath : String!
    
    var exitButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 30, width: 70, height: 70))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .medium)
        
        let largeBoldDoc = UIImage(systemName: "clear.fill", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    var pageBackgroundView : UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        v.applyShadow(offset: CGSize.zero, opacity: 0.4, radius: 6.0)
        return v
    }()
    
    var pageText : UILabel = {
       let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = UIFont(name: "Heebo-Regular", size: 19)
        v.textColor = UIColor.black
        v.numberOfLines = 0
        v.lineBreakMode = .byWordWrapping
        v.text = """
 Please help me find my laugh", said Spotty. "I can't find a laugh up here" replied Giraffe.
 """
        return v
    }()
    
    var safeAreaView : UIView = {
       let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        return v
    }()
    
    var nextPageButton : UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(nextPageTapped), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "PageNext"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var prevPageButton : UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(prevPageTapped), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "PagePrev"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var startButton : UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(prevPageTapped), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "PagePrev"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var recordButton : UIButton = {
       let button = UIButton()
        button.addTarget(self, action: #selector(recordTapped), for: .touchUpInside)
        button.setImage(#imageLiteral(resourceName: "Record"), for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
                
        setupDeepARAndCamera()
        
        setupViews()
        
        setMask(name: maskPath)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deepAR.shutdown()
    }
    
    func setMask(name:String) {
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let myEffectPath = documentsURL.appendingPathComponent(name).path
        
        deepAR.switchEffect(withSlot: "masks", path: myEffectPath)
    }
    
    func setupViews() {
        arViewContainer.addSubview(exitButton)
        view.addSubview(pageBackgroundView)
        view.addSubview(safeAreaView)
        view.addSubview(nextPageButton)
        view.addSubview(prevPageButton)
        view.addSubview(recordButton)
        
        pageBackgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        pageBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageBackgroundView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        pageBackgroundView.addSubview(pageText)
        pageText.topAnchor.constraint(equalTo: pageBackgroundView.topAnchor, constant: 15).isActive = true
        pageText.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 15).isActive = true
        pageText.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -15).isActive = true

        safeAreaView.topAnchor.constraint(equalTo: pageBackgroundView.bottomAnchor).isActive = true
        safeAreaView.leftAnchor.constraint(equalTo: pageBackgroundView.leftAnchor).isActive = true
        safeAreaView.rightAnchor.constraint(equalTo: pageBackgroundView.rightAnchor).isActive = true
        safeAreaView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        let pageControlWidth = 50
        
        nextPageButton.bottomAnchor.constraint(equalTo: pageBackgroundView.topAnchor, constant: -20).isActive = true
        nextPageButton.rightAnchor.constraint(equalTo: pageBackgroundView.rightAnchor, constant: -20).isActive = true
        nextPageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nextPageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        prevPageButton.bottomAnchor.constraint(equalTo: pageBackgroundView.topAnchor, constant: -20).isActive = true
        prevPageButton.leftAnchor.constraint(equalTo: pageBackgroundView.leftAnchor, constant: 20).isActive = true
        prevPageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        prevPageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        recordButton.bottomAnchor.constraint(equalTo: pageBackgroundView.topAnchor, constant: -20).isActive = true
        recordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        recordButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        recordButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    
    private func setupDeepARAndCamera() {
        
        self.deepAR = DeepAR()
        self.deepAR.delegate = self
        self.deepAR.setLicenseKey("8a9e4faccf2770ed93d87e4f90ae9ebb7330e30c824c4c8f43c70d242ccd967e0e0c110a57d9088b")
        
        
        cameraController = CameraController()
        cameraController.deepAR = self.deepAR
        
        
        
        self.arView = self.deepAR.createARView(withFrame: self.arViewContainer.frame) as! ARView
        self.arView.translatesAutoresizingMaskIntoConstraints = false
        self.arViewContainer.addSubview(self.arView)
        
        cameraController.arview = arView
        
        self.arView.leftAnchor.constraint(equalTo: self.arViewContainer.leftAnchor, constant: 0).isActive = true
        self.arView.rightAnchor.constraint(equalTo: self.arViewContainer.rightAnchor, constant: 0).isActive = true
        self.arView.topAnchor.constraint(equalTo: self.arViewContainer.topAnchor, constant: 0).isActive = true
        self.arView.bottomAnchor.constraint(equalTo: self.arViewContainer.bottomAnchor, constant: 0).isActive = true
        
        cameraController.startCamera()
        
        
    }
    
    @objc
    func dismissTapped()  {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func nextPageTapped()  {
        
    }
    
    @objc
    func prevPageTapped()  {
        
    }
    
    @objc
    func recordTapped()  {
        
    }

}

extension DeepARVC : DeepARDelegate {
    func didInitialize() {
        print("DID INIT")
    }
}
