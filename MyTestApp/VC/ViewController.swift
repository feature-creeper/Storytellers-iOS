//
//  ViewController.swift
//  MyTestApp
//
//  Created by Joe Kletz on 06/10/2020.
//

import UIKit

class ViewController: UIViewController, SomeProtocol {
    
    var cachedPosition = Dictionary<IndexPath,CGPoint>()
    
    var tableView : UITableView!
    
    var featuredBooks:[BookFeatured] = []
    var newBooks:[BookFeatured] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        
        
        
        tableView.register(FeaturedBooksCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        view.addSubview(tableView)

        fetchBooks()
        
    }
    
    func fetchBooks() {
        API.sharedAPI.getFeaturedBooks(featured: .featured) { (books) in
            self.featuredBooks.append(contentsOf: books)
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
        
        API.sharedAPI.getFeaturedBooks(featured: .recently_added) { (books) in
            self.newBooks.append(contentsOf: books)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    func tappedBook(_ book:BookFeatured) {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        if let viewController = mainStoryboard.instantiateViewController(withIdentifier: "BookDetailVC") as? BookDetailVC {
            viewController.modalPresentationStyle = .fullScreen
            viewController.bookFeatured = book
            self.present(viewController, animated: true, completion: nil)
        }
    }
}

extension ViewController :UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! FeaturedBooksCell
        
        if indexPath.row == 0 {
            cell.books = featuredBooks
            cell.rowName = "Featured"
        }else if indexPath.row == 1{
            cell.books = newBooks
            cell.rowName = "New"
        }
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.initialise()
        cell.col.contentOffset = cachedPosition[indexPath] ?? .zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? FeaturedBooksCell {
            cachedPosition[indexPath] = cell.col.contentOffset
        }
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}


protocol SomeProtocol : class {
    // protocol definition goes here
    func tappedBook(_ book:BookFeatured)
}

//class MyDelegateClass {
//    var delegate:SomeProtocol?
//    
////    func doDelegate() {
////        delegate?.tappedBook()
////    }
//}
