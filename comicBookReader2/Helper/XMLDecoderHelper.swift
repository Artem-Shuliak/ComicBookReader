//
//  XMLDecoder.swift
//  comicBookReader2
//
//  Created by readdle on 05.07.2021.
//

import Foundation
import XMLParsing

struct XMLDecoderHelper {
    
    static func decodeXML<T: Decodable>(data: Data) -> T? {

        let decoder = XMLDecoder()
        return try? decoder.decode(T.self, from: data)
    
    }
}

