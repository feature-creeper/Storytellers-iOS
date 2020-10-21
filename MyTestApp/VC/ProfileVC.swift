//
//  ProfileVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 08/10/2020.
//

import UIKit
import FirebaseAuth

class ProfileVC: UIViewController {
    
    var logoutButton : UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 25, width: 100, height: 100))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: largeConfig)
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = #colorLiteral(red: 0.2709999979, green: 0.4429999888, blue: 1, alpha: 1)
        return button
    }()
    
    var scrollView : UIScrollView = {
        let scroll = UIScrollView()
        scroll.translatesAutoresizingMaskIntoConstraints = false
        scroll.alwaysBounceVertical = true
        return scroll
    }()
    
    var circleView : CircleView = {
        let v = CircleView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = v.bounds.width / 2
        return v
    }()
    
    var myVideosLabel : UILabel = {
        let v = UILabel()
        v.text = "My Videos"
        v.font = UIFont(name: Globals.semiboldWeight, size: 25)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        v.textColor = .black
        return v
    }()
    
    var collectionView : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collV = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collV.translatesAutoresizingMaskIntoConstraints = false
        collV.register(MyVideoCell.self, forCellWithReuseIdentifier: "cell")
        collV.backgroundColor = .white
        return collV
    }()
    
    var collViewHeight : CGFloat {
        
        return collectionView.collectionViewLayout.collectionViewContentSize.height
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        setupNavBar()
        
        setupViews()
    }

    
    func setupNavBar() {
        let logout = UIBarButtonItem(image: UIImage(systemName: "arrow.right.square"), style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItems = [logout]
        
        let help = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpTapped))
        navigationItem.leftBarButtonItems = [help]
    }
    
    
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.addSubview(circleView)
        scrollView.addSubview(myVideosLabel)
        scrollView.addSubview(collectionView)
        
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        
        circleView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 35).isActive = true
        circleView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        myVideosLabel.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 30).isActive = true
        myVideosLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true

        collectionView.topAnchor.constraint(equalTo: myVideosLabel.bottomAnchor, constant: 20).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 4).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -4).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        
//      collectionView.heightAnchor.constraint(equalToConstant: 800).isActive = true
        
        scrollView.bottomAnchor.constraint(equalTo: collectionView.bottomAnchor).isActive = true
        
    }
    
    func fitHeight() {
        collectionView.heightAnchor.constraint(equalToConstant: collViewHeight).isActive = true
        view.setNeedsLayout()
    }
    
    @objc
    func logoutTapped(){
        try? Auth.auth().signOut()
    }
    
    @objc
    func helpTapped(){
        print("TAPPED HELP")
        
        let vc = HelpVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func dismissTapped()  {
        print("TAPPED LOGIN")
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let authUI = delegate.authUI
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }

}

extension ProfileVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyVideoCell
    }
   
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width/3 - 4
        return CGSize(width: width, height: width * 1.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        showActionSheet(index: indexPath.item)
    }
    
    
}

/// A special UIView displayed as a ring of color
class CircleView: UIView {
    override func draw(_ rect: CGRect) {
        drawRingFittingInsideView()
    }
    
    internal func drawRingFittingInsideView() -> () {
        let halfSize:CGFloat = min( bounds.size.width/2, bounds.size.height/2)
        let desiredLineWidth:CGFloat = 1 // your desired value
            
        let circlePath = UIBezierPath(
                arcCenter: CGPoint(x:halfSize,y:halfSize),
                radius: CGFloat( halfSize - (desiredLineWidth/2) ),
                startAngle: CGFloat(0),
            endAngle:CGFloat(Double.pi * 2),
            clockwise: true)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = circlePath.cgPath
        
        shapeLayer.fillColor = UIColor.orange.cgColor
//        shapeLayer.strokeColor = UIColor.orange.cgColor
//        shapeLayer.lineWidth = desiredLineWidth
        
        layer.addSublayer(shapeLayer)
    }
}
