//
//  ProfileVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 08/10/2020.
//

import UIKit
import FirebaseAuth
import CoreData

class ProfileVC: UIViewController {
    
    var myVideos : [VideoMO] = []

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
        collV.register(ProfileFooter.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "Footer")
        collV.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "Header")
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
        
        fetchSavedVideos()
    }

    
    func setupNavBar() {
        let logout = UIBarButtonItem(image: UIImage(systemName: "arrow.right.square"), style: .plain, target: self, action: #selector(logoutTapped))
        navigationItem.rightBarButtonItems = [logout]
        
        let help = UIBarButtonItem(image: UIImage(systemName: "questionmark.circle"), style: .plain, target: self, action: #selector(helpTapped))
        navigationItem.leftBarButtonItems = [help]
    }
    
    
    func setupViews() {
        view.addSubview(collectionView)

        collectionView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func fetchSavedVideos() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            
            myVideos = try context.fetch(VideoMO.fetchRequest())
            collectionView.reloadData()

        } catch  {
            
        }

    }
    
    @objc
    func logoutTapped(){
        try? Auth.auth().signOut()
    }
    
    @objc
    func helpTapped(){
        let vc = HelpVC()
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    @objc
    func dismissTapped()  {
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let authUI = delegate.authUI
        let authViewController = authUI!.authViewController()
        present(authViewController, animated: true, completion: nil)
    }

}

extension ProfileVC : UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myVideos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyVideoCell
        if let data = myVideos[indexPath.item].thumbnail{
            cell.image = UIImage(data: data)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: 300, height: 425)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: 300, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        
        case UICollectionView.elementKindSectionHeader:

            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Header", for: indexPath as IndexPath)
            return headerView

        case UICollectionView.elementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "Footer", for: indexPath as IndexPath)
            return footerView

        default:
            return UICollectionReusableView()
        }
    }
}

extension ProfileVC: UICollectionViewDelegateFlowLayout {
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = view.bounds.width/3 - 6
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


class ProfileHeader: UICollectionReusableView {
    var myVideosLabel : UILabel = {
        let v = UILabel()
        v.text = "My Videos"
        v.font = UIFont(name: Globals.semiboldWeight, size: 25)
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textAlignment = .center
        v.textColor = .black
        return v
    }()
    
    var privacyButton : UIButton = {
        let v = UIButton()
        v.setTitle("Privacy", for: .normal)
        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        return v
    }()
    
    var childSafetyButton : UIButton = {
        let v = UIButton()
        v.setTitle("Child safety", for: .normal)
        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        return v
    }()
    
    var contactButton : UIButton = {
        let v = UIButton()
        v.setTitle("Speak to us", for: .normal)
        v.setTitleColor(.gray, for: .normal)
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 20)
        
        return v
    }()
    
    var aStack : UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.spacing = 10
        v.alignment = .leading
        return v
    }()
    
    var circleView : CircleView = {
        let v = CircleView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = v.bounds.width / 2
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        
        
        self.addSubview(aStack)
        self.addSubview(circleView)
        
       
        circleView.topAnchor.constraint(equalTo: self.topAnchor, constant: 35).isActive = true
        circleView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        circleView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        circleView.heightAnchor.constraint(equalToConstant: 150).isActive = true
       
        aStack.topAnchor.constraint(equalTo: circleView.bottomAnchor, constant: 20).isActive = true
        aStack.leftAnchor.constraint(equalTo: self.layoutMarginsGuide.leftAnchor, constant: 15).isActive = true
        aStack.rightAnchor.constraint(equalTo: self.layoutMarginsGuide.rightAnchor, constant: 15).isActive = true
        
        aStack.addArrangedSubview(privacyButton)
        aStack.addArrangedSubview(childSafetyButton)
        aStack.addArrangedSubview(contactButton)
        aStack.addArrangedSubview(myVideosLabel)
        
        aStack.setCustomSpacing(20, after: contactButton)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ProfileFooter: UICollectionReusableView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
