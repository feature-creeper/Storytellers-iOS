//
//  API.swift
//  MyTestApp
//
//  Created by Joe Kletz on 08/10/2020.
//

import Foundation
import Firebase


enum FeaturedList : String {
    case featured, recently_added
}

class API {
    public static let sharedAPI = API()
    private init(){
        db = Firestore.firestore()
    }
    
    var db:Firestore!
    
    func getFeaturedBooks(featured:FeaturedList, perPage:Int ,completion: @escaping ([Book])->Void) {
        let docRef = db.collection(featured.rawValue)
        
        var books:[Book] = [] {
            didSet{
                if books.count == perPage {
                    completion(books)
                }
            }
        }
        
        docRef.getDocuments { (snap, error) in
            for doc in snap!.documents {
                let bookData = doc.data()
//                completion("I ESCAPED \(String(describing: bookData["title"]))")
                if let bookId = bookData["id"] as? String{
                    self.getBook(withId: bookId) { (book) in
                        //completion(book)
                        books.append(book)
                    }
                    
                }
                
            }
        }
    }
    
    func getBook(withId id: String, completion : @escaping (Book)->Void) {
        let docRef = db.collection("books").document(id)
        
        docRef.getDocument { (snapshot, error) in
            do {
                let bookData = try JSONSerialization.data(withJSONObject: snapshot?.data(), options: [])
                let decoder = JSONDecoder()
                
                let book = try decoder.decode(Book.self, from: bookData)
                completion(book)
            }
            catch{
                
            }
        }
    }
}
