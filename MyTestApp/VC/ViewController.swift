//
//  ViewController.swift
//  MyTestApp
//
//  Created by Joe Kletz on 06/10/2020.
//

import UIKit

class ViewController: UIViewController, SomeProtocol {
    
    var cachedPosition = Dictionary<IndexPath,CGPoint>()
    
    func someTypeMethod() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "BookDetailVC") as? BookDetailVC {
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        tableView.register(FeaturedBooksCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)

        
    }
}

extension ViewController :UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeaturedBooksCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.initialise()
        cell.col.contentOffset = cachedPosition[indexPath] ?? .zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FeaturedBooksCell {
            cachedPosition[indexPath] = cell.col.contentOffset
        }
    }
}


protocol SomeProtocol : class {
    // protocol definition goes here
    func someTypeMethod()
}

class MyDelegateClass {
    var delegate:SomeProtocol?
    
    func doDelegate() {
        delegate?.someTypeMethod()
    }
}
