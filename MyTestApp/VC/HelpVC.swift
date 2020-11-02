//
//  HelpVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 20/10/2020.
//

import UIKit

class HelpVC: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    var vcA : HelpContentVC = {
        let vc = HelpContentVC()
        vc.pageIndex = 1
        vc.labelTitle = "First select one of our books.\nWe have loads of good ones!"
        return vc
    }()
    
    var vcB : HelpContentVC = {
        let vc = HelpContentVC()
        vc.pageIndex = 2
        vc.labelTitle = "Learn to read and even learn a new language"
        return vc
    }()
    
    var vcC : HelpContentVC = {
        let vc = HelpContentVC()
        
        vc.pageIndex = 3
//        vc.showButton = true
        vc.labelTitle = "CCCC"
        return vc
    }()
    
    var vCArr: [HelpContentVC] = []
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vcA.delegate = self
        vcB.delegate = self
        vcC.delegate = self
        
        vCArr = [vcA,vcB,vcC]
        
        self.delegate = self
        self.dataSource = self
        
        
        setViewControllers([viewControllerAtIndex(0)!], direction: .forward, animated: true) { (complete) in
            
        }
        
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        var index = indexOfViewController(viewController)
        
    
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        
        return viewControllerAtIndex(index)
        
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = indexOfViewController(viewController)
        
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        
        if index == vCArr.count {
            return nil
        }
        
        return viewControllerAtIndex(index)
    }
    
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return vCArr.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let OB1 = viewControllers?.first,
              let OB1Index = vCArr.index(of: OB1 as! HelpContentVC) else {
            return 0
            
        }
        
        return 0
    }
    
    
}

// MARK: - Helpers
extension HelpVC {
    fileprivate func viewControllerAtIndex(_ index: Int) -> HelpContentVC? {
        if vCArr.count == 0 || index >= vCArr.count {
            return nil
        }
        print(index)
        return vCArr[index]
    }
    
    fileprivate func indexOfViewController(_ viewController: UIViewController) -> Int {
        return vCArr.index(of: viewController as! HelpContentVC) ?? NSNotFound
    }
}

extension HelpVC : HelpVCDelegate{
    func tappedDismiss() {
        self.dismiss(animated: true, completion: nil)
    }
    
    
}


class HelpContentVC: UIViewController {
    
    var delegate : HelpVCDelegate?
    
    var pageIndex = 0
    
//    var showButton : Bool = false
    
    let label : UILabel = {
        let v  = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.textColor = .black
        v.textAlignment = .center
        v.numberOfLines = 0
        v.font = UIFont(name: Globals.regularWeight, size: 20)
        return v
    }()
    
    let stack : UIStackView = {
        let v  = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        return v
    }()
    
    let mainImage : UIImageView = {
        let v  = UIImageView()
        v.contentMode = .scaleAspectFit
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let dismissButton : UIButton = {
        let v  = UIButton()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.titleLabel?.font = UIFont(name: Globals.semiboldWeight, size: 26)
        v.setTitle("Continue", for: .normal)
        v.backgroundColor = .orange
        v.layer.cornerRadius = 10
        v.contentEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
        v.addTarget(self, action: #selector(tappedDismiss), for: .touchUpInside)
//        v.textColor = .black
        return v
    }()
    
    var labelTitle : String? {
        didSet{
            label.text = labelTitle
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
    
    func setupViews() {

        view.addSubview(stack)
        
        stack.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        stack.addArrangedSubview(mainImage)
        stack.addArrangedSubview(label)
        
        mainImage.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        mainImage.heightAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        
        label.text = labelTitle
        
//        if showButton {
//
//        }
//
        if pageIndex == 1 {
            mainImage.image = UIImage(named: "Reading")
        }
        
        if pageIndex == 2 {
            mainImage.image = UIImage(named: "LanguageHelp")
            
        }
        
        if pageIndex == 3 {
            view.addSubview(dismissButton)
            dismissButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            dismissButton.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
            dismissButton.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
            dismissButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        }
        
    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = .white
        self.view = v
    }
    
    @objc
    func tappedDismiss() {
        delegate?.tappedDismiss()
    }
}

protocol HelpVCDelegate {
    func tappedDismiss()
}
