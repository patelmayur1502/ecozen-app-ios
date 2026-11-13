import Foundation

public struct CategoryItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let slug: String
    public let image_url: String?
    public let sort_order: Int?
    public let is_featured: Bool?
    public let is_visible: Bool?
    public let emoji: String

    public init(
        id: String,
        name: String,
        slug: String,
        image_url: String? = nil,
        sort_order: Int? = 0,
        is_featured: Bool? = true,
        is_visible: Bool? = true,
        emoji: String = "📦"
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.image_url = image_url
        self.sort_order = sort_order
        self.is_featured = is_featured
        self.is_visible = is_visible
        self.emoji = emoji
    }
}

public struct BrandItem: Identifiable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let subtitle: String
    public let tag: String
    public let colorHex: String

    public init(id: String, name: String, subtitle: String, tag: String, colorHex: String) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.tag = tag
        self.colorHex = colorHex
    }
}

