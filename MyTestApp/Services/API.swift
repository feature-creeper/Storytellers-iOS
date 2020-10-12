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
    
    func getFeaturedBooks(featured:FeaturedList, completion: @escaping ([BookFeatured])->Void) {
        let docRef = db.collection(featured.rawValue)
        
        var books:[BookFeatured] = []
        
        docRef.getDocuments { (snap, error) in
            snap?.documents.forEach({ (snapshot) in
                
                do{
                    var bookData = snapshot.data()
                    if let date = bookData["added"] as? Timestamp {
                        date.dateValue()
                        bookData.removeValue(forKey: "added")
                        
                        let book = try BookFeatured(from: bookData)
                    
                        books.append(book)
                    }
                } catch{
                    
                }
                
            })
            
            completion(books)
        }
    }
    
    func getFeaturedBook(withId id: String, completion : @escaping (BookInfo)->Void) {
        let docRef = db.collection("books").document(id)
        
        docRef.getDocument { (snapshot, error) in
            do {
                let bookData = try JSONSerialization.data(withJSONObject: snapshot?.data(), options: [])
                
                
                
                let decoder = JSONDecoder()
                
                //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                
                //decoder.userInfo[CodingUserInfoKey.managedObjectContext] = context
                
                var bookInfo = try decoder.decode(BookInfo.self, from: bookData)
                bookInfo.id = snapshot?.documentID
                
                completion(bookInfo)
            }
            catch{
                
            }
        }
    }
    
    func getBookContent(withBookId id : String, completion : @escaping ([String:Any]) -> Void) {
        let docRef = db.collection("books").document(id).collection("content")
        
        var content: [String:Any] = [:]
        
        docRef.getDocuments { (snap, error) in
            snap?.documents.forEach({ (docSnap) in
                content[docSnap.documentID] = docSnap.data()
            })
            
            completion(content)
        }
    }
}

extension Decodable {
  init(from: Any) throws {
    let data = try JSONSerialization.data(withJSONObject: from, options: [])
    let decoder = JSONDecoder()
    self = try decoder.decode(Self.self, from: data)
  }
}
