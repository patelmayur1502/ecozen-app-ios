import Foundation

public enum PackagingUnit: String, Codable, CaseIterable, Sendable {
    case loose = "loose"
    case box = "box"

    public var displayName: String {
        switch self {
        case .loose: return "Pack"
        case .box: return "Carton / Box"
        }
    }
}

public struct Product: Identifiable, Codable, Sendable, Hashable {
    public let id: Int
    public let name: String
    public let slug: String?
    public let category: String?
    public let category_id: String?
    public let brand: String?
    public let description: String?
    public let material: String?
    public let dimensions: String?
    public let hsn_code: String?

    public let loose_price: Double?
    public let loose_quantity: Int?
    public let box_price: Double?
    public let box_quantity: Int?

    public let mrp: Double?
    public let discount_pct: Double?
    public let image_url: String?
    public let stock_quantity: Int?

    public let is_bestseller: Bool?
    public let is_trending: Bool?
    public let is_new: Bool?
    public let is_visible: Bool?
    public let rating: Double?

    public init(
        id: Int,
        name: String,
        slug: String? = nil,
        category: String? = nil,
        category_id: String? = nil,
        brand: String? = nil,
        description: String? = nil,
        material: String? = nil,
        dimensions: String? = nil,
        hsn_code: String? = nil,
        loose_price: Double? = nil,
        loose_quantity: Int? = 100,
        box_price: Double? = nil,
        box_quantity: Int? = 1000,
        mrp: Double? = nil,
        discount_pct: Double? = nil,
        image_url: String? = nil,
        stock_quantity: Int? = 100,
        is_bestseller: Bool? = false,
        is_trending: Bool? = false,
        is_new: Bool? = false,
        is_visible: Bool? = true,
        rating: Double? = 4.8
    ) {
        self.id = id
        self.name = name
        self.slug = slug
        self.category = category
        self.category_id = category_id
        self.brand = brand
        self.description = description
        self.material = material
        self.dimensions = dimensions
        self.hsn_code = hsn_code
        self.loose_price = loose_price
        self.loose_quantity = loose_quantity
        self.box_price = box_price
        self.box_quantity = box_quantity
        self.mrp = mrp
        self.discount_pct = discount_pct
        self.image_url = image_url
        self.stock_quantity = stock_quantity
        self.is_bestseller = is_bestseller
        self.is_trending = is_trending
        self.is_new = is_new
        self.is_visible = is_visible
        self.rating = rating
    }

    public func effectivePrice(for unit: PackagingUnit) -> Double {
        switch unit {
        case .loose:
            return loose_price ?? 0.0
        case .box:
            return box_price ?? ((loose_price ?? 0.0) * 8.5)
        }
    }

    public func unitQuantityText(for unit: PackagingUnit) -> String {
        switch unit {
        case .loose:
            return "\(loose_quantity ?? 100) pcs"
        case .box:
            return "Box (\(box_quantity ?? 1000) pcs)"
        }
    }

    public func unitPerPieceText(for unit: PackagingUnit) -> String {
        let price = effectivePrice(for: unit)
        let count = Double(unit == .loose ? (loose_quantity ?? 100) : (box_quantity ?? 1000))
        guard count > 0 else { return "" }
        let perPiece = price / count
        return String(format: "₹%.2f / pc", perPiece)
    }
}

