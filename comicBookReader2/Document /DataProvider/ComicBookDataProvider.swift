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
    
    // archive reference in app document storage location
    private var archiveFile: URL
    
    // Archive Managers
    private var cbzArchiveManager: Archive
    private var cbrArchiveManager: URKArchive
    
    init?(archiveName: String) {
        // get url of ComicFile in documents
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        self.archiveFile = documentDirectory.appendingPathComponent(archiveName)
        
        // Initialize Archives
        guard let cbzArchiveManager = Archive(url: archiveFile, accessMode: .read) else { return nil }
        guard let cbrArchiveManager = try? URKArchive(url: archiveFile) else { return nil }
        
        // assign Archives to properties
        self.cbzArchiveManager = cbzArchiveManager
        self.cbrArchiveManager = cbrArchiveManager
    }
    
}

extension ComicBookDataProvider: DataProviderProtocol {
    
    // Returns list with all files as Paths in the Archive
    func listOfFilePaths() -> [String]? {
        let fileExtension = archiveFile.pathExtension.lowercased()
        
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
    
    // Extracts file at specified path in the archive
    // Returns it as Data
    func extractDataAtPath(filePath: String, completion: (Data?) -> Void) {
        let fileExtension = archiveFile.pathExtension.lowercased()
        
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
        return cbzArchiveManager.map { $0.path }
    }
    
    func extractCbzFile(filePath: String, completion: (Data?) -> Void) {
        
        guard let file = cbzArchiveManager[filePath] else {
            completion(nil)
            print("unable to locate file")
            return
        }
        
        do {
            // extracting image from the path and storing it in memory as Data
            let mutableData = NSMutableData()
            let _ = try cbzArchiveManager.extract(file, bufferSize: .max, skipCRC32: false, progress: nil) { Data in
                mutableData.append(Data)
            }
            
            guard mutableData.length == file.uncompressedSize else { return }
            completion(Data(mutableData))
        
        } catch {
            print("unable to extract file")
            completion(nil)
        }
    }
    
    
    func listofCbrFiles() -> [String]? {
        return try? cbrArchiveManager.listFilenames()
    }
    
    func extractCbrFile(filePath: String) -> Data? {
        return try? cbrArchiveManager.extractData(fromFile: filePath)
    }
    
}
