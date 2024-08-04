//
//  JSONKeeper.swift
//  BookSummarizer
//
//  Created by Yefremova on 03.08.2024.
//

import ComposableArchitecture
import Foundation

class JSONKeeper: PlayItemFetching {
    
    func fetchPlayItem() async throws -> PlayItem {
        guard let item = JSONKeeper.decodedPlayItem() else {
            throw NSError() // TODO: make custom error
        }
        return item
    }
    
    /// this is just an example of what the app could get from the backend
    static let playItemJSON = """
        {
            "name": "How to Cook Fish",
            "cover": "https://m.media-amazon.com/images/I/713AIrfxlqL._AC_UF1000,1000_QL80_.jpg",
            "keyPoints": [
                {
                    "title": "The Catching of Unshelled Fish",
                    "number": 1,
                    "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis elementum, nulla a aliquet sollicitudin, tellus dolor mollis ipsum, non porttitor purus enim at odio. Mauris commodo sem nec gravida tempor. Integer tincidunt arcu vel enim tempor ullamcorper. Nullam risus tortor, volutpat in sem sit amet, maximus consectetur quam. Etiam ut lorem felis. Nulla ultricies magna sit amet ligula commodo feugiat. Duis elementum semper neque, a suscipit massa lacinia in. Sed ut pulvinar erat, pretium molestie mauris. Nulla suscipit suscipit mauris. Cras turpis nisi, ornare sit amet gravida nec, tristique ut dui. Duis ornare velit vitae ex eleifend, quis vulputate tellus tincidunt. Donec pharetra pharetra quam, in dignissim diam ultricies et. Duis laoreet non velit vitae efficitur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras eu tristique dolor. Vestibulum eu elit in velit pretium tincidunt. Suspendisse tellus felis, malesuada sed velit quis, tempor dictum magna.",
                    "audioURL": "dummy url"
                }
            ]
        }
    """
    
    static func decodedPlayItem() -> PlayItem? {
        if let jsonData = playItemJSON.data(using: .utf8) {
            do {
                let playItem = try JSONDecoder().decode(PlayItem.self, from: jsonData)
                print("✅ PlayItem object parsed")
                return playItem
            } catch {
                print("❌ parcing error JSON: \(error)")
                return nil
            }
        } else {
            print("❌ error converting string to data JSON object")
            return nil
        }
    }
}
