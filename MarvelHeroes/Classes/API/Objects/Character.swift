//
// Created by Артем on 05/03/2020.
// Copyright (c) 2020 ___FULLUSERNAME___. All rights reserved.
//

import Foundation

class Character: Decodable {
    private static let defaultImageRepresentation = "standard_small"

    var identifier: Int64?
    var name = ""
    var description = ""
    var thumbnailURL: URL?
    var comment: String?

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Character.CodingKeys.self)
        identifier = try container.decode(Int64.self, forKey: .identifier)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        let pathContainer = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .thumbnail)
        let path = try pathContainer.decode(String.self, forKey: .thumbnailURL)
        let thumbExtension = try pathContainer.decode(String.self, forKey: .thumbnailExtension)
        thumbnailURL = URL(string: "\(path)/\(Character.defaultImageRepresentation).\(thumbExtension)")
    }

    enum CodingKeys: String, CodingKey {
        case identifier = "id"
        case name
        case description
        case thumbnail
        case thumbnailURL = "path"
        case thumbnailExtension = "extension"
    }
}
