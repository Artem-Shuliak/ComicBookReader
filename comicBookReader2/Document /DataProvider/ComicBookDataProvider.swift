//
//  ComicBookDataProvider.swift
//  comicBookReader2
//
//  Created by Artem Chouliak on 7/2/21.
//

import Foundation
import Zip
import UnrarKit

class ComicBookDataProvider {
    
    // Default Document Directory of an App
    private var getDocumentDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    // archive reference in app document storage location
    private var archive: URL? {
      return getDocumentDirectory?.appendingPathComponent("The Amazing Spider-Man - Amazing Grace (2016) (Digital) (F) (Zone-Empire).cbr")
    }
    
    init() {
        decompressArchive()
    }
        
}

extension ComicBookDataProvider: DataProviderProtocol {
    
    // Get URL's of all Files
    func listOfFiles() -> [URL]? {
        guard let documentURL = archive?.deletingPathExtension() else { return nil }

        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentURL, includingPropertiesForKeys: nil)
            return fileURLs
            
        } catch {
            print("Error while enumerating files \(documentURL.path): \(error.localizedDescription)")
            return nil
        }

    }
    
    func getData() -> ComicBookDataModel {
        return ComicBookDataModel(series: "", summary: "", publisher: "", Genre: "", pageCount: 0, year: 0, month: 0, day: 0, pages: [])
    }
    
    
}



// MARK: -  ComicBook Data Provider Extension Methods

extension ComicBookDataProvider {
    
    // Decompresses the Archive
    func decompressArchive() {
    
        guard let getDocumentsDirectory = getDocumentDirectory, let file = archive else { return }
        let fileExtension = archive?.pathExtension.lowercased()
        
        switch fileExtension {
        case "cbz":
            decompressZip(file: file, destination: getDocumentsDirectory)
        default:
            decompressRar(file: file, destination: getDocumentsDirectory)
        }
        
    }
    
    // Decompress Zip Format ("cbz")
    func decompressZip(file: URL, destination: URL) {
        do {
            try Zip.unzipFile(file, destination: destination, overwrite: true, password: nil)
        } catch {
            print("unable to decompress archive")
        }

    }
    
    // Decompress Rar Format ("cbr")
    func decompressRar(file: URL, destination: URL) {
        
        let destinationFolder = file.deletingPathExtension()
        var archive : URKArchive?
        do {
            archive = try URKArchive(path: file.path)
            try archive?.extractFiles(to: destinationFolder.path, overwrite: true)
            print(destination)
        } catch {
            print("unable to decompress archive")
        }

    }
    
}
