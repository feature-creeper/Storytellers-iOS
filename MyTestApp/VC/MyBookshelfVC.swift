//
//  MyBookshelfVC.swift
//  MyTestApp
//
//  Created by Joe Kletz on 12/10/2020.
//

import UIKit

class MyBookshelfVC: UITableViewController {
    
    var myBooks : [Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let navbarFont = UIFont(name: "Heebo-Medium", size: 17) ?? UIFont.systemFont(ofSize: 17)
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.font: navbarFont,
        ]

        let navbarFontLarge = UIFont(name: "Heebo-Bold", size: 35) ?? UIFont.systemFont(ofSize: 17)
        navigationController?.navigationBar.largeTitleTextAttributes = [
            NSAttributedString.Key.font: navbarFontLarge,
//            NSAttributedString.Key.foregroundColor: UIColor.red
        ]

        tableView.register(MyBookShelfTableCell.self, forCellReuseIdentifier: "cell")
        
        title = "My Bookshelf"
        
    }

    override func viewWillAppear(_ animated: Bool) {
        fetchSavedBooks()
        
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.navigationBar.sizeToFit()
        }

        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode = .always

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
        
        let vc = MyBookDetailVC()
        vc.book = myBooks[index]
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension MyBookshelfVC {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tappedOnBook(indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
}

extension MyBookshelfVC {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        view.clipsToBounds = true
        view.contentMode = .scaleAspectFill
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
            
            if let title = book?.title {
                thumbnailImageView.setImage(fromCoreDataNamed: title.replacingOccurrences(of: " ", with: "_"))
            }
            
            
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
