//
//  ComicBookContentDataModel.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

class ComicBookDocument {
    
    // MARK: - Private Properties
    
    enum State {
        case notLoaded
        case ready
    }

    // model for the data of a book extracted by dataProvider
    private var provider: ComicBookDataProvider
    private var comicBookInfo: ComicBookDataModel?
    
    private(set) var pages: [ComicBookPage]?
    
    // MARK: - Public Properties
    var state: State
    
    // returns ComicBookInfo as Dictionary
    var infoDictionary: [String: Any]? {
        return comicBookInfo?.dictionary
    }
    
    var title: String? {
        return comicBookInfo?.Series
    }
    
    var date: String? {
        return comicBookInfo?.date
    }

    // MARK: - Init Methods
    
    init?(archiveName: String) {
        guard let provider = ComicBookDataProvider(archiveName: archiveName) else { return nil }
        self.provider = provider
        
        self.state = .notLoaded
        self.pages = createPages()
        self.state = .ready
    }
    
    // MARK: - Private Methods
    
    private func createPages() -> [ComicBookPage]? {
        return provider.listOfFilePaths()?
            .filter {
                $0.contains(".jpg")
            }.map { path in
                return ComicBookPage(archiveName: path, document: self)
            }
    }
    
    private let opertionQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.name = "com.comicBook.image.queue"
        queue.maxConcurrentOperationCount = 3
        queue.qualityOfService = .userInteractive
        return queue
    }()
    
    // MARK: - Public Methods
    
    // extracts an imag for index of a page
    func retrieveImageOperation(at page: ComicBookPage, completion: @escaping (UIImage) -> Void) -> Operation {
        
         let operation = BlockOperation { [weak self] in
            self?.provider.extractDataAtPath(filePath: page.dataProviderToken) { data in
                
                guard let data = data else {
                    print("unable to get data")
                    return
                }
                
                guard let image = UIImage(data: data) else {
                    print("unable to create Image from data")
                    return
                }
                completion(image)
            }
        }
        opertionQueue.addOperation(operation)
        return operation
    }

}


extension ComicBookDocument {
    
    // Function to Decode XML from the Archive XML file
    /*
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
    */

}
