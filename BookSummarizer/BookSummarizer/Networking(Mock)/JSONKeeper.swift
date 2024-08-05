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
                    "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis varius metus sit amet erat fringilla, quis maximus augue luctus. Sed sodales dui nulla, non ullamcorper turpis sagittis sed. Cras ut lectus mollis est condimentum mattis nec ut nisl. Nunc suscipit eget nulla quis finibus. Nunc vestibulum in quam sit amet pellentesque. Quisque egestas augue purus, at mollis nisi posuere ut. Donec nec felis in felis blandit ultrices sed a magna. Nam vitae metus eget lacus ullamcorper pretium sit amet a augue. Duis lacus nisl, dignissim sit amet nibh quis, egestas cursus leo. Cras lobortis purus et egestas maximus. Interdum et malesuada fames ac ante ipsum primis in faucibus. Maecenas quis vehicula justo. Morbi sit amet sapien eu nisl iaculis varius eget sed nunc. \\n\\nNam finibus efficitur sagittis. Suspendisse ipsum est, maximus quis velit in, ullamcorper ultrices est. Nunc vulputate est fringilla interdum hendrerit. Mauris sit amet libero pretium, consequat diam quis, ornare quam. Phasellus sagittis porta dui nec euismod. Curabitur mattis consequat nulla, quis accumsan lacus lobortis vitae. Suspendisse potenti. Praesent et consequat sapien. Nam non arcu at nisi venenatis consectetur et id tellus. Maecenas at porta purus, quis lacinia quam. Maecenas in interdum ante. Donec a ullamcorper sapien. Aliquam imperdiet quam nec tincidunt efficitur. Duis tempor ligula non ligula ullamcorper sodales. Orci varius natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed blandit scelerisque porta. Vivamus venenatis lectus enim, vitae lobortis sapien vestibulum eu. Vivamus quis ornare nisi. Curabitur non pharetra tellus. Ut vel lorem sagittis justo molestie cursus id eget lectus. \\nMorbi consectetur nisl et ex porttitor, ut viverra nulla placerat. Suspendisse placerat ante sit amet accumsan vulputate. Donec lobortis velit id tellus imperdiet blandit. Sed fringilla egestas euismod. Praesent tincidunt accumsan diam, id posuere augue suscipit sed. Vestibulum consequat elit sodales, scelerisque nulla eu, porttitor odio.",
                    "audioURL": "https://ia801608.us.archive.org/11/items/how_cook_fish_librivox/how_to_cook_fish_01_green_64kb.mp3"
                },
                {
                    "title": "Fish in Season",
                    "number": 2,
                    "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis varius metus sit amet erat fringilla, quis maximus augue luctus. Sed sodales dui nulla, non",
                    "audioURL": "https://ia801608.us.archive.org/11/items/how_cook_fish_librivox/how_to_cook_fish_02_green_64kb.mp3"
                },
                {
                    "title": "Eleven Court Bouillons",
                    "number": 3,
                    "text": "Sed id placerat nibh, quis lobortis elit. Vestibulum lobortis elit ac egestas cursus. Integer mi leo, luctus eget varius nec, malesuada eget sem. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Proin sagittis quis enim eu pulvinar. Cras tempus semper elit eget dictum. Mauris vestibulum mauris sed tempor tincidunt. Pellentesque efficitur lacus augue, sit amet convallis metus ullamcorper a. Mauris accumsan a est et venenatis. Proin lacinia nisi magna, ut tempor tellus viverra at. \\n\\nDuis in gravida tellus, hendrerit finibus risus. Curabitur tincidunt, lorem id malesuada sollicitudin, tortor velit aliquet tortor, nec feugiat nulla risus id sapien. Donec a luctus sem, eget fermentum nisl. Quisque orci enim, ornare quis auctor quis, mattis quis sem. Quisque placerat dapibus varius. Aenean et orci purus. Ut nunc est, malesuada sed nulla sit amet, accumsan lobortis eros. Nam sed massa eget ex tempor auctor a id odio. Etiam fermentum mattis tortor ac tempor. Donec lacus tellus, consequat sed dui sit amet, tristique efficitur orci. Donec semper feugiat tristique. Maecenas orci odio, accumsan sit amet posuere vitae, gravida vel odio. Donec id maximus lacus, in lobortis nulla. Nam at turpis quis lacus suscipit sagittis. Curabitur vitae risus id risus blandit interdum. Proin at volutpat neque. \\n\\nAliquam elementum risus arcu, nec consectetur augue cursus maximus.Nam facilisis venenatis lacus. Donec malesuada, leo ut lobortis sollicitudin, est urna tristique tortor, nec pulvinar nisi diam eu nunc. Cras vel odio vitae nulla congue cursus a at dui. \\nAliquam id pretium sapien. Donec urna dui, consequat quis ipsum sed, pretium gravida leo. Donec feugiat nunc sed magna vulputate rhoncus vitae sit amet nisi. Donec consectetur enim sed metus vulputate, vel consequat ligula bibendum. Donec vitae maximus erat. Duis id volutpat enim. Maecenas augue nisi, condimentum quis tempor sit amet, lobortis faucibus urna.",
                    "audioURL": "https://ia801608.us.archive.org/11/items/how_cook_fish_librivox/how_to_cook_fish_03_green_64kb.mp3"
                },
                {
                    "title": "One Hundred Simple Fish Sauces",
                    "number": 4,
                    "text": "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Duis elementum, nulla a aliquet sollicitudin, tellus dolor mollis ipsum, non porttitor purus enim at odio. Mauris commodo sem nec gravida tempor. Integer tincidunt arcu vel enim tempor ullamcorper. Nullam risus tortor, volutpat in sem sit amet, maximus consectetur quam. Etiam ut lorem felis. Nulla ultricies magna sit amet ligula commodo feugiat. Duis elementum semper neque, a suscipit massa lacinia in. Sed ut pulvinar erat, pretium molestie mauris. Nulla suscipit suscipit mauris. Cras turpis nisi, ornare sit amet gravida nec, tristique ut dui. Duis ornare velit vitae ex eleifend, quis vulputate tellus tincidunt. Donec pharetra pharetra quam, in dignissim diam ultricies et. Duis laoreet non velit vitae efficitur. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras eu tristique dolor. Vestibulum eu elit in velit pretium tincidunt. Suspendisse tellus felis, malesuada sed velit quis, tempor dictum magna.",
                    "audioURL": "https://ia801608.us.archive.org/11/items/how_cook_fish_librivox/how_to_cook_fish_04_green_64kb.mp3"
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
