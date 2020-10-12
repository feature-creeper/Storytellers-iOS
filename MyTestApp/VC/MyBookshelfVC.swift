//
//  MyBookshelfVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 12/10/2020.
//

import UIKit

class MyBookshelfVC: UIViewController {
    
    var myBooks : [Book] = []
    
    let tableView : UITableView = {
        let tv = UITableView()
        return tv
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        let v = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 200))
        v.backgroundColor = .brown
        view.addSubview(v)
        
        tableView.frame = view.frame
        tableView.delegate = self
        tableView.dataSource = self
        view.addSubview(tableView)
        
        tableView.register(MyBookShelfTableCell.self, forCellReuseIdentifier: "cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchSavedBooks()
    }
    
    func fetchSavedBooks() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        do {
            myBooks = try context.fetch(Book.fetchRequest())
            tableView.reloadData()
        } catch  {
            
        }
        
    }
    
    func tappedOnBook(_ index : Int) {
        print(index)
        
        let vc = MyBookDetailVC()
        let nav = UINavigationController(rootViewController: vc)
       

        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }

}

extension MyBookshelfVC : UITableViewDelegate{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedOnBook(indexPath.row)
    }
}

extension MyBookshelfVC : UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBooks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MyBookShelfTableCell
        cell.book = myBooks[indexPath.row]
        return cell
    }
    
    
}

class MyBookShelfTableCell: UITableViewCell {
    
    
    let thumbnailImageView : UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .systemGray6
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 9
        return view
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Heebo-Bold", size: 22)
        label.numberOfLines = 2
        return label
    }()
    
    let authorLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Heebo-Regular", size: 16)
        return label
    }()
    
    let stackView : UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var book : Book? {
        didSet{
            titleLabel.text = book?.title
            authorLabel.text = book?.author
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    func setupViews() {
        contentView.addSubview(stackView)
        contentView.addSubview(thumbnailImageView)
        
        let thumbnailWidth : CGFloat = 75
        thumbnailImageView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor).isActive = true
        thumbnailImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        thumbnailImageView.widthAnchor.constraint(equalToConstant: thumbnailWidth).isActive = true
        thumbnailImageView.heightAnchor.constraint(equalToConstant: thumbnailWidth).isActive = true
        
        stackView.leftAnchor.constraint(equalTo: thumbnailImageView.rightAnchor, constant: 15).isActive = true
        stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        
        stackView.axis = .vertical
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(authorLabel)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
