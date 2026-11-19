import Foundation

public struct CategoryItem: Identifiable, Codable, Sendable, Hashable {
    public let id: String
    public let name: String
    public let slug: String
    public let image_url: String?
    public let sort_order: Int?
    public let is_featured: Bool?
    public let is_visible: Bool?
    public let emoji: String?

    public init(
        id: String,
        name: String,
        slug: String,
        image_url: String? = nil,
        sort_order: Int? = 0,
        is_featured: Bool? = true,
        is_visible: Bool? = true,
        emoji: String? = nil
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

    public var displayEmoji: String {
        if let emoji, !emoji.isEmpty { return emoji }
        let s = (slug + " " + name).lowercased()
        if s.contains("bagasse") || s.contains("tray") { return "🍱" }
        if s.contains("paper") || s.contains("tub") || s.contains("container") { return "🥡" }
        if s.contains("cutlery") || s.contains("wood") || s.contains("spoon") { return "🍴" }
        if s.contains("bag") { return "🛍️" }
        if s.contains("areca") || s.contains("plate") { return "🥣" }
        if s.contains("hygiene") || s.contains("clean") || s.contains("chemical") { return "🧼" }
        if s.contains("candle") { return "🕯️" }
        if s.contains("aluminium") || s.contains("foil") { return "🥫" }
        if s.contains("cup") || s.contains("coffee") { return "☕" }
        if s.contains("sample") { return "📦" }
        return "📦"
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
