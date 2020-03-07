//
// Created by Артем on 05/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

class Character: Decodable {
    private static let defaultImageeRepresentation = "standard_small"

    var name = ""
    var description = ""
    var thumbnailURL: URL?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Character.CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        let pathContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnail)
        let path = try pathContainer.decode(String.self, forKey: .thumbnailURL)
        let thumbExtension = try pathContainer.decode(String.self, forKey: .thumbnailExtension)
        thumbnailURL = URL(string: "\(path)/\(Character.defaultImageeRepresentation).\(thumbExtension)")
    }

    enum CodingKeys: String, CodingKey {
        case name
        case description
        case thumbnail
        case thumbnailURL = "path"
        case thumbnailExtension = "extension"
    }
}
