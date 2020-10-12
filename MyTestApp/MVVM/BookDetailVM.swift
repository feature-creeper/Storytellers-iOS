//
//  BookDetailVM.swift
//  MyTestApp
//
//  Created by Joe Kletz on 11/10/2020.
//

import Foundation
import UIKit


protocol BookDetailDelegate {
    func receivedBook(book : BookInfo)
    func saved()
}

class BookDetailVM {
    
    var bookFeatured: BookFeatured?
    
    var delegate : BookDetailDelegate?
    
    
    func getBookContent() {
        
        //Start Loading
        
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext

        let book = Book(context: context)
        book.author = bookFeatured!.author
        book.cover = bookFeatured!.cover
        book.title = bookFeatured!.title
        
        if let id = bookFeatured?.id {
            API.sharedAPI.getBookContent(withBookId: id) { (content) in
                do{
                    let contentData = try JSONSerialization.data(withJSONObject: content, options: [])
                    let contentStringified = String(data: contentData, encoding: String.Encoding.utf8)
                    book.content = contentStringified
                    try context.save()
                } catch{
                    //Error
                }
            }
        }
    }
    
//    func save() {
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let context = delegate.persistentContainer.viewContext
//        do {
//            try context.save()
//        } catch  {
//        
//        }
//    }
    
//    func queryBooks() {
//        var savedBooks = [Book]()
//        let delegate = UIApplication.shared.delegate as! AppDelegate
//        let context = delegate.persistentContainer.viewContext
//        do {
//            savedBooks = try context.fetch(Book.fetchRequest())
//            savedBooks.forEach { (book) in
//                print(book.title)
//            }
//        } catch  {
//
//        }
//    }
    
    func getBook() {
        
        guard let bookID = bookFeatured?.id else {return}
        API.sharedAPI.getFeaturedBook(withId: bookID) { (bookInfo) in
//            delegate.receivedBook
            self.delegate!.receivedBook(book: bookInfo)
        }
    }
}
