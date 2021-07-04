//
//  DataProviderProtocol .swift
//  comicBookReader2
//
//  Created by Artem Chouliak on 7/2/21.
//

import Foundation

protocol DataProviderProtocol {
    func listOfFiles() -> [URL]?
    func getData() -> ComicBookDataModel
}


