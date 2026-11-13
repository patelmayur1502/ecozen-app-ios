import Foundation
import Combine

public final class CartManager: ObservableObject, @unchecked Sendable {
    public static let shared = CartManager()

    @Published public var items: [CartItem] = []
    @Published public var couponCode: String = ""
    @Published public var discountAmount: Double = 0.0
    @Published public var riderTip: Double = 30.0
    @Published public var hasGstInputTaxCredit: Bool = true
    @Published public var gstinNumber: String = "30AABCE1234F1Z8"
    @Published public var businessName: String = "Cafe Horizon LLP"
    @Published public var deliveryAddress: String = "Cafe Horizon, Anjuna Beach Rd, North Goa"

    public init() {
        // Seed default items matching real restaurant test orders
        let defaultProduct1 = CatalogService.shared.allProducts.first ?? Product(
            id: 101,
            name: "CHUK 500ml Square Container",
            loose_price: 665.60,
            box_price: 5824.00
        )
        let defaultProduct2 = CatalogService.shared.allProducts.dropFirst().first ?? Product(
            id: 102,
            name: "750ml White Paper Tub with Lid",
            loose_price: 990.00,
            box_price: 8700.00
        )

        self.items = [
            CartItem(product: defaultProduct1, unit: .box, quantity: 1),
            CartItem(product: defaultProduct2, unit: .loose, quantity: 1)
        ]
    }

    public var totalItemCount: Int {
        items.reduce(0) { $0 + $1.quantity }
    }

    public var subtotal: Double {
        items.reduce(0.0) { $0 + $1.itemTotal }
    }

    public var deliveryFee: Double {
        if subtotal >= SupabaseConfig.freeDeliveryThreshold || subtotal == 0 {
            return 0.0
        } else {
            return SupabaseConfig.baseDeliveryFee
        }
    }

    public var freeDeliveryRemaining: Double {
        max(0.0, SupabaseConfig.freeDeliveryThreshold - subtotal)
    }

    public var gstAmount: Double {
        subtotal * 0.18
    }

    public var grandTotal: Double {
        max(0.0, subtotal - discountAmount) + deliveryFee + gstAmount + riderTip
    }

    public func add(product: Product, unit: PackagingUnit = .loose, quantity: Int = 1) {
        if let idx = items.firstIndex(where: { $0.product.id == product.id && $0.unit == unit }) {
            items[idx].quantity += quantity
        } else {
            items.append(CartItem(product: product, unit: unit, quantity: quantity))
        }
    }

    public func remove(product: Product, unit: PackagingUnit) {
        if let idx = items.firstIndex(where: { $0.product.id == product.id && $0.unit == unit }) {
            if items[idx].quantity > 1 {
                items[idx].quantity -= 1
            } else {
                items.remove(at: idx)
            }
        }
    }

    public func quantity(of product: Product, unit: PackagingUnit) -> Int {
        items.first(where: { $0.product.id == product.id && $0.unit == unit })?.quantity ?? 0
    }

    public func clear() {
        items.removeAll()
    }
}

