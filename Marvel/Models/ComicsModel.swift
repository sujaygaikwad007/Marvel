import Foundation

// Enum to represent different types of URLs
enum URLComicType: String, Codable {
    case detail = "detail"
    case wiki = "wiki"
    case comiclink = "comiclink"
    case unknown // Add a case for handling unknown values

    // Initialize URLComicType from a String value, defaulting to 'unknown' for unknown values
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let type = try? container.decode(String.self) {
            self = URLComicType(rawValue: type) ?? .unknown
        } else {
            self = .unknown
        }
    }
}

struct APIComicResult: Codable {
    var data: APIComicData
}

struct APIComicData: Codable {
    var count: Int
    var results: [ComicModel]
}

struct ComicModel: Identifiable, Codable {
    var id: Int
    var title: String
    var description: String?
    var thumbnail: ComicThumbnail
    var urls: [URLComicElement]

    var thumbnailURL: String {
        return "\(thumbnail.path).\(thumbnail.extension)"
    }

    // Function to get URL based on type
    func url(forType type: URLComicType) -> String? {
        return urls.first { $0.type == type }?.url
    }

    // CodingKeys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case id
        case title
        case description
        case thumbnail
        case urls
    }
}

struct ComicThumbnail: Codable {
    var path: String
    var `extension`: String

    // CodingKeys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case path
        case `extension`
    }
}

struct URLComicElement: Codable, Hashable {
    var type: URLComicType
    var url: String

    // CodingKeys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case type
        case url
    }

    // Custom initializer to handle decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(URLComicType.self, forKey: .type)
        url = try container.decode(String.self, forKey: .url)
    }

    // Encoder to handle encoding
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(type, forKey: .type)
        try container.encode(url, forKey: .url)
    }
}
