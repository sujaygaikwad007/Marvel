import Foundation

// Enum to represent different types of URLs
enum URLType: String, Codable {
    case detail = "detail"
    case wiki = "wiki"
    case comiclink = "comiclink"
}

struct APICharacterResult: Codable {
    var data: APICharacterData
}

struct APICharacterData: Codable {
    var count: Int
    var results: [CharactersModel]
}

struct CharactersModel: Identifiable, Codable {
    var id: Int
    var name: String
    var description: String
    var thumbnail: Thumbnail
    var urls: [URLElement]

    var thumbnailURL: String {
        return "\(thumbnail.path).\(thumbnail.extension)"
    }

    // Function to get URL based on type
    func url(forType type: URLType) -> String? {
        return urls.first { $0.type == type }?.url
    }
}

struct Thumbnail: Codable {
    var path: String
    var `extension`: String
}

// URL element structure
struct URLElement: Codable, Hashable {
    var type: URLType
    var url: String

    // CodingKeys to map JSON keys to struct properties
    enum CodingKeys: String, CodingKey {
        case type
        case url
    }

    // Custom initializer to handle decoding
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        type = try container.decode(URLType.self, forKey: .type)
        url = try container.decode(String.self, forKey: .url)
    }
    
    
}
