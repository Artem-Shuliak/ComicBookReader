//
//  ComicBookContentDataModel.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

class ComicBookDocument {
    
    // model for the data of a book extracted by dataProvider
    let provider = ComicBookDataProvider()
    var comicBookInfo: ComicBookDataModel?
    
    init() {
//        comicBookInfo = getData()
    }
    
    var numberOfPages: Int? {
        return comicBookInfo?.pageCount
    }
    
    var title: String? {
        return comicBookInfo?.series
    }
    
    var date: String? {
        return comicBookInfo?.date
    }
    
    // extracts an imag for index of a page
    func imageAtIndex(index: Int) -> UIImage? {
        return UIImage(named: "X-Men - Golgotha-\(index)")
    }

}


extension ComicBookDocument {
    
    // Converts all URL of pages into Images
    func getImages() -> [UIImage]? {
        
        guard let listOfFiles = provider.listOfFiles() else { return nil}
        
        let sortedFiles = listOfFiles.sorted {
            $0.relativeString < $1.relativeString
        }
        
       return sortedFiles.compactMap { URL -> UIImage? in
            do {
                let imageData = try Data(contentsOf: URL)
                let image = UIImage(data: imageData)
                return image
            } catch {
                print("unable to decode image from url")
                return nil
            }
        }
    }

}
