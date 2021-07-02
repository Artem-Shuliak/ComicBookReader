//
//  ComicBookContentDataModel.swift
//  ComicBookReader
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit

class ComicBookContentDataModel {
    
    static let shared = ComicBookContentDataModel()
    private init() { }
    
    let comicBookPages: [UIImage] = [#imageLiteral(resourceName: "X-Men - Golgotha-0"), #imageLiteral(resourceName: "X-Men - Golgotha-2"), #imageLiteral(resourceName: "X-Men - Golgotha-3"), #imageLiteral(resourceName: "X-Men - Golgotha-3")]
    
}
