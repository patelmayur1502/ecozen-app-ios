import Foundation

public struct CartItem: Identifiable, Sendable, Hashable {
    public let id: UUID
    public let product: Product
    public var unit: PackagingUnit
    public var quantity: Int

    public init(id: UUID = UUID(), product: Product, unit: PackagingUnit, quantity: Int = 1) {
        self.id = id
        self.product = product
        self.unit = unit
        self.quantity = quantity
    }

    public var itemTotal: Double {
        product.effectivePrice(for: unit) * Double(quantity)
    }
}

public enum OrderStatus: String, Codable, Sendable {
    case placed = "placed"
    case packed = "packed"
    case outForDelivery = "out_for_delivery"
    case delivered = "delivered"
    case cancelled = "cancelled"

    public var title: String {
        switch self {
        case .placed: return "Order Placed"
        case .packed: return "Packed at Warehouse"
        case .outForDelivery: return "Borzo Courier On Route"
        case .delivered: return "Delivered"
        case .cancelled: return "Cancelled"
        }
    }
}

public struct OrderRecord: Identifiable, Sendable {
    public let id: String
    public let orderNumber: String
    public let createdAt: Date
    public var status: OrderStatus
    public let totalAmount: Double
    public let itemCount: Int
    public let borzoCourierName: String?
    public let borzoCourierPhone: String?
    public let borzoVehicle: String?
    public let etaMinutes: Int
    public let deliveryAddress: String
    public let gstInvoiceNumber: String?

    public init(
        id: String,
        orderNumber: String,
        createdAt: Date = Date(),
        status: OrderStatus = .outForDelivery,
        totalAmount: Double,
        itemCount: Int,
        borzoCourierName: String? = "Rajesh Naik",
        borzoCourierPhone: String? = "+91 98221 23456",
        borzoVehicle: String? = "Activa (GA-03-9214)",
        etaMinutes: Int = 26,
        deliveryAddress: String = "Cafe Horizon, Anjuna Beach Rd, North Goa",
        gstInvoiceNumber: String? = "EZP-202611-0492"
    ) {
        self.id = id
        self.orderNumber = orderNumber
        self.createdAt = createdAt
        self.status = status
        self.totalAmount = totalAmount
        self.itemCount = itemCount
        self.borzoCourierName = borzoCourierName
        self.borzoCourierPhone = borzoCourierPhone
        self.borzoVehicle = borzoVehicle
        self.etaMinutes = etaMinutes
        self.deliveryAddress = deliveryAddress
        self.gstInvoiceNumber = gstInvoiceNumber
    }
}

