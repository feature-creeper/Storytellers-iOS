//
//  DatabaseHelper.swift
//  MyTestApp
//
//  Created by Joe Kletz on 09/10/2020.
//

import Foundation

class DatabaseHelper {
    public static let shared = DatabaseHelper()
    private init(){}
    
    func addFile() {
        print("ADD FILE")
    }
    
    func browseDocuments() {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }

        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])

            // Print the urls of the files contained in the documents directory
            print(directoryContents)
        } catch {
            print("Could not search for urls of files in documents directory: \(error)")
        }
    }
}

extension FileManager {
    func urls(for directory: FileManager.SearchPathDirectory, skipsHiddenFiles: Bool = false ) -> [URL]? {
        let documentsURL = urls(for: directory, in: .userDomainMask)[0]
        let fileURLs = try? contentsOfDirectory(at: documentsURL, includingPropertiesForKeys: nil, options: skipsHiddenFiles ? .skipsHiddenFiles : [] )
        return fileURLs
    }
}
