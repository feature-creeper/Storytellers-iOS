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
    
    var exitButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 30, width: 70, height: 70))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .medium)
        
        let largeBoldDoc = UIImage(systemName: "clear.fill", withConfiguration: largeConfig)
//        button.applyShadow()
        
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = UIColor.white
        return button
    }()
    
    var pageBackgroundView : UIView = {
       let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        view.backgroundColor = .darkGray
        
        setupDeepARAndCamera()
        
        setupViews()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deepAR.shutdown()
    }
    
    func setupViews() {
        arViewContainer.addSubview(exitButton)
        
        view.addSubview(pageBackgroundView)
        pageBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        pageBackgroundView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        pageBackgroundView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        pageBackgroundView.heightAnchor.constraint(equalToConstant: 150).isActive = true
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

}

extension DeepARVC : DeepARDelegate {
    func didInitialize() {
        print("DID INIT")
    }
}
