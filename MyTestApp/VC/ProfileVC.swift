//
//  ProfileVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 08/10/2020.
//

import UIKit
import FirebaseUI

class ProfileVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let button = UIButton(frame: CGRect(x: 0, y: 25, width: 100, height: 100))
        button.addTarget(self, action: #selector(dismissTapped), for: .touchUpInside)
        let largeConfig = UIImage.SymbolConfiguration(pointSize: 40, weight: .bold, scale: .large)
        let largeBoldDoc = UIImage(systemName: "arrow.backward.circle.fill", withConfiguration: largeConfig)
        
        button.setImage(largeBoldDoc, for: .normal)
        button.tintColor = #colorLiteral(red: 0.2709999979, green: 0.4429999888, blue: 1, alpha: 1)

        view.addSubview(button)
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
