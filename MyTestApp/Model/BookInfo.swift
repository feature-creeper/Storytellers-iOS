//
//  BookInfo.swift
//  MyTestApp
//
//  Created by Joe Kletz on 11/10/2020.
//

import Foundation

struct BookInfo : Codable {
    var author : String?
    var title : String?
    var cover : String?
    var id : String?
    var effects : String?
    
    enum CodingKeys: String, CodingKey {
        case author
        case title
        case cover
    }
}
