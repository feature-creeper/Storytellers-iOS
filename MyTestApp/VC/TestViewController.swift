//
//  MyViewController.swift
//  MyTestApp
//
//  Created by Joe Kletz on 08/10/2020.
//

import UIKit
import Firebase

class TestViewController: UIViewController {
    
    var db:Firestore!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        db = Firestore.firestore()
       
        firebaseGetBooks()
        
        addClose()
    }
    
    func addClose() {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 300, height: 90))
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
//        button.frame(forAlignmentRect: CGRect(x: 0, y: 0, width: 300, height: 90))
        button.setTitle("CLOSE", for: .normal)
        button.backgroundColor = UIColor.blue
        view.addSubview(button)
    }
    
    @objc
    func close() {
        dismiss(animated: true, completion: nil)
    }
    
    override func loadView() {
        let v = UIView()
        v.backgroundColor = UIColor.white
        self.view = v
    }
    
    func firebaseGetBooks() {
        API.sharedAPI.getFeaturedBooks(featured: .featured) { (books) in
            for book in books {

            }
        }
    }
    
    func firebaseTest() {
        print("FB TEST")
        
        let docRef = db.collection("books").document("2h9uMt6Fp0UTXwU6M3Dp")
        
        docRef.getDocument { (snap, error) in
            
            let bookData:[String:Any] = snap?.data() ?? [:]
            
            print(bookData["title"])
            do{
                 let myData = try JSONSerialization.data(withJSONObject: bookData, options: [])
                print(myData)
                
                let decoder = JSONDecoder()
                
//                let myBook = try decoder.decode( Book.self, from: myData)
                
                //print("MY BOOK IS \(myBook.title)")
            }catch{
                
            }
            
            do{
                let encoder = JSONEncoder()
//                let aBook = Book(title: "CHEWY")
//                let endodedBook = try encoder.encode(aBook)
//                print(endodedBook)
            }catch{
                
            }
            
        }
        
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

class MyObject: Codable {
    var name : String?
    var age : Int?
    
    enum CodingKeys : String, CodingKey {
        case name = "title"
    }
    
    required init(from decoder: Decoder) throws {
        let value = try decoder.container(keyedBy: CodingKeys.self)
        name = try value.decode(String.self, forKey: .name)
        //age = try values.decode(Double.self, forKey: )
    }
}

extension CodingUserInfoKey {
  static let managedObjectContext = CodingUserInfoKey(rawValue: "managedObjectContext")!
}

/*
 enum DecoderConfigurationError: Error {
   case missingManagedObjectContext
 }

 class TodoItem: NSManagedObject, Decodable {
   enum CodingKeys: CodingKey {
     case id, label, completions
  }

   required convenience init(from decoder: Decoder) throws {
     guard let context = decoder.userInfo[CodingUserInfoKey.managedObjectContext] as? NSManagedObjectContext else {
       throw DecoderConfigurationError.missingManagedObjectContext
     }

     self.init(context: context)

     let container = try decoder.container(keyedBy: CodingKeys.self)
     self.id = try container.decode(Int64.self, forKey: .id)
     self.label = try container.decode(String.self, forKey: .label)
     self.completions = try container.decode(Set<TodoCompletion>.self, forKey: .completions) as NSSet
   }
 }
 */
