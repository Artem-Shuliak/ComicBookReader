//
//  ComicBookPage.swift
//  comicBookReader2
//
//  Created by readdle on 07.07.2021.
//

import UIKit

struct ComicBookPage {
    
    // MARK: - Private Properties
    
    private(set) var dataProviderToken: String
    private weak var document: ComicBookDocument?
    private var imageLoadingRequest: Operation?
    
    private var image: UIImage?
    
    // MARK: - Init Methods
    
    init(archiveName: String, document: ComicBookDocument) {
        self.dataProviderToken = archiveName
        self.document = document
    }
    
    // MARK: - Public Methods
    
    mutating func loadImage(completion: @escaping (UIImage) -> Void) {
        
        guard let document = document else { print("no document"); return }
        
        if let image = self.image {
            completion(image)
        } else {
            imageLoadingRequest = document.retrieveImageOperation(at: self) { image in
                completion(image)
            }
        }
    }
    
    var isLoadingImage: Bool {
        guard let request = imageLoadingRequest else { return false }
        return request.isExecuting
    }
    
    mutating func clearCachedIamge() {
        self.image = nil
    }
    
    func cancelImageLoading() {
        guard let request = imageLoadingRequest else { return }
        request.cancel()
    }
}

    
    

