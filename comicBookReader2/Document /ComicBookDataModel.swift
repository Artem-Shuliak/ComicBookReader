//
//  ComicBookDataModel.swift
//  comicBookReader2
//
//  Created by Artem Chouliak on 7/2/21.
//

import Foundation

struct ComicBookDataModel: Codable {
    let Series: String?
    let Summary: String?
    let Publisher: String?
    let Genre: String?
    let PageCount: Int?
    let Year: Int?
    let Month: Int?
    let Day: Int?
}

extension ComicBookDataModel {
    
    var date: String? {
        
        guard let day = Day, let month = Month, let year = Year else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let someDateTime = formatter.date(from: "\(year)-\(month)-\(day)")
        
        guard let someDateTime = someDateTime else { return nil }
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        
        return dateFormatterPrint.string(from: someDateTime)
    }

}

extension Encodable {
    
  var dictionary: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments)).flatMap { $0 as? [String: Any] }
    
  }
}

