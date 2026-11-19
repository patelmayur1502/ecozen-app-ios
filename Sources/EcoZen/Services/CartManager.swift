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
    @Published public var lastOrder: OrderRecord? = nil

    public init() {
        self.items = []
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

    public var taxableSubtotal: Double {
        max(0.0, subtotal - discountAmount)
    }

    public var gstAmount: Double {
        taxableSubtotal * 0.18
    }

    public var grandTotal: Double {
        taxableSubtotal + deliveryFee + gstAmount + riderTip
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
        discountAmount = 0.0
        couponCode = ""
    }

    @discardableResult
    public func createOrderFromCart() -> OrderRecord {
        let orderNum = "EZP-\(Int.random(in: 1000...9999))"
        let currentMonth = Calendar.current.component(.month, from: Date())
        let currentYear = Calendar.current.component(.year, from: Date())
        let invoiceNum = String(format: "EZP-%04d%02d-%04d", currentYear, currentMonth, Int.random(in: 100...999))

        let newOrder = OrderRecord(
            id: orderNum,
            orderNumber: orderNum,
            createdAt: Date(),
            status: .outForDelivery,
            totalAmount: grandTotal,
            itemCount: totalItemCount,
            borzoCourierName: "Rajesh Naik",
            borzoCourierPhone: "+91 98221 23456",
            borzoVehicle: "Activa (GA-03-9214)",
            etaMinutes: 26,
            deliveryAddress: deliveryAddress,
            gstInvoiceNumber: invoiceNum
        )
        self.lastOrder = newOrder
        self.clear()
        return newOrder
    }
}
