import Foundation
import Combine

public final class CatalogService: ObservableObject, @unchecked Sendable {
    public static let shared = CatalogService()

    @Published public var allProducts: [Product] = []
    @Published public var categories: [CategoryItem] = []
    @Published public var brands: [BrandItem] = []
    @Published public var isLoading: Bool = false

    public init() {
        loadDefaultVerifiedCatalog()
        Task {
            await fetchFromSupabase()
        }
    }

    public var bestsellers: [Product] {
        let marked = allProducts.filter { $0.is_bestseller == true }
        return marked.isEmpty ? Array(allProducts.prefix(8)) : marked
    }

    public var trendingProducts: [Product] {
        let marked = allProducts.filter { $0.is_trending == true }
        return marked.isEmpty ? Array(allProducts.dropFirst(2).prefix(8)) : marked
    }

    public var newArrivals: [Product] {
        let marked = allProducts.filter { $0.is_new == true }
        return marked.isEmpty ? Array(allProducts.dropFirst(4).prefix(8)) : marked
    }

    public func searchProducts(query: String) -> [Product] {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return allProducts
        }
        let q = query.lowercased()
        return allProducts.filter { p in
            p.name.lowercased().contains(q) ||
            (p.category?.lowercased().contains(q) ?? false) ||
            (p.material?.lowercased().contains(q) ?? false) ||
            (p.brand?.lowercased().contains(q) ?? false)
        }
    }

    public func products(for categoryName: String) -> [Product] {
        allProducts.filter { p in
            p.category?.lowercased().contains(categoryName.lowercased()) ?? false
        }
    }

    @MainActor
    public func fetchFromSupabase() async {
        let endpoint = SupabaseConfig.url.appendingPathComponent("rest/v1/products")
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            URLQueryItem(name: "is_visible", value: "eq.true"),
            URLQueryItem(name: "select", value: "*"),
            URLQueryItem(name: "limit", value: "50")
        ]

        guard let queryURL = components?.url else { return }

        var request = URLRequest(url: queryURL)
        request.addValue(SupabaseConfig.anonKey, forHTTPHeaderField: "apikey")
        request.addValue("Bearer \(SupabaseConfig.anonKey)", forHTTPHeaderField: "Authorization")

        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode == 200 {
                let decoded = try JSONDecoder().decode([Product].self, from: data)
                if !decoded.isEmpty {
                    self.allProducts = decoded
                }
            }
        } catch {
            // Offline or cache fallback in effect
        }
    }

    private func loadDefaultVerifiedCatalog() {
        self.brands = [
            BrandItem(id: "chuk", name: "CHUK", subtitle: "100% Bagasse", tag: "OEM Partner", colorHex: "#16a34a"),
            BrandItem(id: "ecozen", name: "EcoZen Essentials", subtitle: "Tableware & Boxes", tag: "Direct Brand", colorHex: "#f59e0b"),
            BrandItem(id: "hygiene", name: "EcoHygiene", subtitle: "Cleaning Chemicals", tag: "Commercial", colorHex: "#0d9488"),
            BrandItem(id: "naturalia", name: "Naturalia", subtitle: "Birchwood Cutlery", tag: "Eco Tableware", colorHex: "#ea580c")
        ]

        self.categories = [
            CategoryItem(id: "bagasse", name: "Baggase Products", slug: "baggase-products", emoji: "🍱"),
            CategoryItem(id: "paper", name: "Paper Containers", slug: "paper-containers", emoji: "🥡"),
            CategoryItem(id: "cutlery", name: "Wooden Cutlery", slug: "wooden-cutlery", emoji: "🍴"),
            CategoryItem(id: "bags", name: "Bio Carry Bags", slug: "bio-bags", emoji: "🛍️"),
            CategoryItem(id: "areca", name: "Areca Palm Plates", slug: "areca-palm", emoji: "🥣"),
            CategoryItem(id: "hygiene", name: "Commercial Hygiene", slug: "cleaning-chemicals", emoji: "🧼"),
            CategoryItem(id: "candles", name: "Eco Candles", slug: "candles", emoji: "🕯️"),
            CategoryItem(id: "samples", name: "Restaurant Samples", slug: "sample-kits", emoji: "📦")
        ]

        self.allProducts = [
            Product(
                id: 101,
                name: "CHUK 500ml Square Container (Bagasse)",
                slug: "chuk-500ml-container-square",
                category: "Baggase Products",
                brand: "CHUK",
                description: "100% biodegradable sugarcane bagasse. Microwave safe up to 120°C, freezer safe, leak-resistant.",
                material: "Sugarcane Bagasse",
                dimensions: "135 x 135 x 45 mm",
                hsn_code: "48237090",
                loose_price: 665.60,
                loose_quantity: 100,
                box_price: 5824.00,
                box_quantity: 1000,
                mrp: 750.00,
                discount_pct: 15,
                image_url: "https://pub-2cda0b12aa12459bb001445e0f6cc0e9.r2.dev/products/chuk/chuk-500ml.png",
                stock_quantity: 4200,
                is_bestseller: true,
                is_trending: true,
                is_new: false
            ),
            Product(
                id: 102,
                name: "750ml White Paper Tub with Paper Lid",
                slug: "750ml-white-paper-tub-lid",
                category: "Paper Containers",
                brand: "EcoZen Essentials",
                description: "Heavy-duty paper soup and biryani tub with tight snap-fit lid. Keeps food piping hot.",
                material: "Food Grade Kraft Paper",
                dimensions: "140 x 140 x 60 mm",
                hsn_code: "48237090",
                loose_price: 990.00,
                loose_quantity: 100,
                box_price: 8700.00,
                box_quantity: 1000,
                mrp: 1150.00,
                discount_pct: 14,
                image_url: "https://pub-2cda0b12aa12459bb001445e0f6cc0e9.r2.dev/products/catalog/tub-750.png",
                stock_quantity: 3500,
                is_bestseller: true,
                is_trending: false,
                is_new: false
            ),
            Product(
                id: 103,
                name: "Wooden Spoon 14cm (100 pcs pack)",
                slug: "wooden-spoon-14cm-100pcs",
                category: "Wooden Cutlery",
                brand: "Naturalia",
                description: "Smooth birchwood spoon, splinter-free, 100% compostable. Standard size for Goa takeaways.",
                material: "Birchwood",
                dimensions: "140 mm",
                hsn_code: "44199090",
                loose_price: 62.70,
                loose_quantity: 1,
                box_price: 551.00,
                box_quantity: 10,
                mrp: 75.00,
                discount_pct: 16,
                image_url: "https://pub-2cda0b12aa12459bb001445e0f6cc0e9.r2.dev/products/catalog/spoon-14.png",
                stock_quantity: 8000,
                is_bestseller: false,
                is_trending: true,
                is_new: false
            ),
            Product(
                id: 104,
                name: "Kraft Paper Carrier Handle Bag (Medium)",
                slug: "kraft-paper-handle-bag-medium",
                category: "Bio Carry Bags",
                brand: "EcoZen Essentials",
                description: "Reinforced twisted paper handle carrier bag. Holds up to 5kg of restaurant takeout boxes.",
                material: "Recycled Kraft Paper",
                dimensions: "260 x 130 x 320 mm",
                hsn_code: "48194000",
                loose_price: 240.00,
                loose_quantity: 50,
                box_price: 1950.00,
                box_quantity: 500,
                mrp: 280.00,
                discount_pct: 14,
                image_url: "https://pub-2cda0b12aa12459bb001445e0f6cc0e9.r2.dev/products/catalog/kraft-bag.png",
                stock_quantity: 2800,
                is_bestseller: false,
                is_trending: true,
                is_new: false
            ),
            Product(
                id: 105,
                name: "CHUK 3-Compartment Meal Tray with Lid",
                slug: "chuk-3-compartment-meal-tray",
                category: "Baggase Products",
                brand: "CHUK",
                description: "Tamper-proof 3-compartment bento meal box. Perfect for thalis, executive lunches, and combo curries.",
                material: "Sugarcane Bagasse",
                dimensions: "240 x 180 x 40 mm",
                hsn_code: "48237090",
                loose_price: 1150.00,
                loose_quantity: 100,
                box_price: 9800.00,
                box_quantity: 1000,
                mrp: 1350.00,
                discount_pct: 15,
                image_url: "https://pub-2cda0b12aa12459bb001445e0f6cc0e9.r2.dev/products/chuk/chuk-3cp.png",
                stock_quantity: 1500,
                is_bestseller: false,
                is_trending: false,
                is_new: true
            ),
            Product(
                id: 106,
                name: "Ripple Kraft Insulated Coffee Cup 250ml",
                slug: "ripple-kraft-coffee-cup-250ml",
                category: "Paper Containers",
                brand: "EcoZen Essentials",
                description: "Triple wall corrugated ripple barrier. No heat sleeve needed for piping hot cappuccinos & teas.",
                material: "Insulated Kraft Paper",
                dimensions: "250 ml (8 oz)",
                hsn_code: "48237090",
                loose_price: 320.00,
                loose_quantity: 50,
                box_price: 2750.00,
                box_quantity: 500,
                mrp: 380.00,
                discount_pct: 16,
                image_url: "https://pub-2cda0b12aa12459bb001445e0f6cc0e9.r2.dev/products/catalog/ripple-cup.png",
                stock_quantity: 4500,
                is_bestseller: false,
                is_trending: false,
                is_new: true
            )
        ]
    }
}

