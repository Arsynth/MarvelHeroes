//
// Created by Артем on 06/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

class CharacterListResponse: ResponsePage<Character>, Decodable {
    required init(from decoder: Decoder) throws {
        super.init()
        let container = try decoder.container(keyedBy: CharacterListResponse.CodingKeys.self)
        count = try container.decode(Int.self, forKey: .count)
        limit = try container.decode(Int.self, forKey: .limit)
        offset = try container.decode(Int.self, forKey: .limit)
        results = try container.decode([Character].self, forKey: .results)
    }

    enum CodingKeys: String, CodingKey {
        case count
        case limit
        case offset
        case results
    }
}

class CharacterListPager: ResponsePageCollector<Character> {

}
