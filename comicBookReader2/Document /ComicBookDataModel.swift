//
//  ComicBookDataModel.swift
//  comicBookReader2
//
//  Created by Artem Chouliak on 7/2/21.
//

import Foundation

struct ComicBookDataModel: Decodable {
    let series: String?
    let summary: String?
    let publisher: String?
    let Genre: String?
    let pageCount: Int?
    let year: Int?
    let month: Int?
    let day: Int?
}

extension ComicBookDataModel {
    
    var date: String? {
        
        guard let day = day, let month = month, let year = year else { return nil }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let someDateTime = formatter.date(from: "\(year)-\(month)-\(day)")
        
        guard let someDateTime = someDateTime else { return nil }
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMM dd,yyyy"

        
        return dateFormatterPrint.string(from: someDateTime)
    }
    
//    func getValues() -> [String: Any] {
//        let dict: [String: Any] = [
//            "series": series,
//            "summary": summary,
//            "publisher": publisher,
//            "Genre": Genre,
//            "pageCount": pageCount,
//            "year": year,
//            "month": month,
//            "day": day,
//        ]
//
//    }
}
