//
//  ComicBookContentDataModel.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

class ComicBookDocument {
    var archiveName: String
    // model for the data of a book extracted by dataProvider
    lazy var provider = ComicBookDataProvider(archiveName: archiveName)
    // Comic Book Info Model
    var comicBookInfo: ComicBookDataModel?
    
    init(archiveName: String) {
        self.archiveName = archiveName
        // Decodes XML from the Archive
        // Instantiates comicBookInfo Model from it
        decodeXMLInfo { model in
            comicBookInfo = model
        }
    }
    
    func setArchive(name: String) {
        provider.archiveName = name
    }
    
    var title: String? {
        return comicBookInfo?.Series
    }
    
    var date: String? {
        return comicBookInfo?.date
    }
    
    
    var numberOfPages: Int {
        let paths = provider.listOfFilePaths()
        let filteredPaths = paths?.filter { $0.contains(".jpg")}
        return filteredPaths?.count ?? 0
    }
    
    // filtered files of the archive, containing only pages with images
    var filteredPages: [String]? {
        let pages = provider.listOfFilePaths()
        let filteredPaths = pages?.filter { $0.contains(".jpg")}
        return filteredPaths
    }
    
    // returns ComicBookInfo as Dictionary
    var infoDictionary: [String: Any]? {
        return comicBookInfo?.dictionary
    }
    
    // extracts an imag for index of a page
    func imageAtPage(index: Int, completion: (UIImage?) -> Void) {
        guard let page = filteredPages?[index] else {
            completion(nil)
            print("unable to get page")
            return
        }
            
        provider.extractDataAtPath(filePath: page) { data in
            guard let data = data else {
                print("unable to get data")
                completion(nil)
                return
            }
            
            guard let image = UIImage(data: data) else {
                print("unable to create Image from data")
                return
            }
        
            completion(image)
        }
    }
    
    // Function to Decode XML from the Archive XML file
    func decodeXMLInfo(completion: (ComicBookDataModel) -> Void) {
        guard let filesinArchive = provider.listOfFilePaths() else { return }
        
        if let xmlDocument = filesinArchive.filter({ $0.contains(".xml") }).first {
            provider.extractDataAtPath(filePath: xmlDocument) { data in
                guard let data = data else { return }
                guard let decodedModel: ComicBookDataModel = XMLDecoderHelper.decodeXML(data: data) else { return }
                completion(decodedModel)
            }
        }
    }
    

}
