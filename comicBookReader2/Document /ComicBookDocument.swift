//
//  ComicBookContentDataModel.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

class ComicBookDocument {
    
    // model for the data of a book extracted by dataProvider
    var comicBookInfo: ComicBookDataModel?
    
    init() {
        comicBookInfo = getData()
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

// MARK: - Protocol Methods to get Data from Data Provider
extension ComicBookDocument: DataProviderProtocol {

    func listOfFiles() {
        //
    }

    func getData() -> ComicBookDataModel {
        //
        let ExtractedDataModel = ComicBookDataModel(series: "X-Men: Golgotha", summary: "The X-Men travel to Antarctica to respond to an S.O.S. from a colony of mutants...and what they find is far more shocking than they expected! Will the X-Men share the colony's gruesome fate?", publisher: "Marvel", Genre: "Superhero", pageCount: 114, year: 2014, month: 12, day: 01, pages: [Page(imageNumber: 0), Page(imageNumber: 1), Page(imageNumber: 2)])
        return ExtractedDataModel
    }


}
