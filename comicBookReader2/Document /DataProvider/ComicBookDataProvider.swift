//
//  ComicBookDataProvider.swift
//  comicBookReader2
//
//  Created by Artem Chouliak on 7/2/21.
//

import UIKit
import UnrarKit
import ZIPFoundation

class ComicBookDataProvider {
    
    // Default Document Directory of an App
    private var getDocumentDirectory: URL? {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    }
    
    // archive reference in app document storage location
    private var archiveFile: URL? {
        return getDocumentDirectory?.appendingPathComponent("The Amazing Spider-Man - Amazing Grace (2016) (Digital) (F) (Zone-Empire).cbr")
    }
    
    // Archive Managers
    private var cbzArchiveManager: Archive?
    private var cbrArchiveManager: URKArchive?
    
    init() {
        guard let archiveFile = archiveFile else { return }
        
        cbzArchiveManager = Archive(url: archiveFile, accessMode: .read)
        cbrArchiveManager = try? URKArchive(url: archiveFile)
    }
    
}

extension ComicBookDataProvider: DataProviderProtocol {
    
    func listOfFilePaths() -> [String]? {
        let fileExtension = archiveFile?.pathExtension.lowercased()
        
        switch fileExtension {
        case "cbz":
           return listofCbzFiles()
        case "cbr":
           return listofCbrFiles()
        default:
            print("unsupported archive extension")
            return nil
        }
    }
    
    
    func extractDataAtPath(filePath: String, completion: (Data?) -> Void) {
        let fileExtension = archiveFile?.pathExtension.lowercased()
        
        switch fileExtension {
        case "cbz":
            extractCbzFile(filePath: filePath) { data in
                completion(data)
            }
        case "cbr":
            let data = extractCbrFile(filePath: filePath)
            completion(data)
        default:
            print("unable to extract data - unsupported archive extension")
            completion(nil)
        }
    }
    
}



// MARK: -  ComicBook Data Provider Extension Methods

extension ComicBookDataProvider {
    
    func listofCbzFiles() -> [String]? {
        guard let archiveManager = cbzArchiveManager else { return nil }
        return archiveManager.map { $0.path }
    }
    
    func extractCbzFile(filePath: String, completion: (Data?) -> Void) {
        guard let archiveManager = cbzArchiveManager else {
            completion(nil)
            print("unable to instantiate archiveManager")
            return
        }
        
        guard let file = archiveManager[filePath] else {
            completion(nil)
            print("unable to locate file")
            return
        }
        
        do {
            // extracting image from the path and storing it in memory as Data
            let _ = try archiveManager.extract(file, bufferSize: .max, skipCRC32: false, progress: nil) { Data in
                print(Data)
                completion(Data)
            }
        } catch {
            print("unable to extract file")
            completion(nil)
        }
    }
    
    
    func listofCbrFiles() -> [String]? {
        guard let manager = cbrArchiveManager else { return nil }
        return try? manager.listFilenames()
    }
    
    func extractCbrFile(filePath: String) -> Data? {
        guard let manager = cbrArchiveManager else { return nil }
        return try? manager.extractData(fromFile: filePath)
    }
    
}
