import SwiftUI

public struct FloatingCartBar: View {
    public let onOpenCart: () -> Void
    @ObservedObject private var cartManager = CartManager.shared

    public init(onOpenCart: @escaping () -> Void) {
        self.onOpenCart = onOpenCart
    }

    public var body: some View {
        if cartManager.totalItemCount > 0 {
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                onOpenCart()
            }) {
                HStack(spacing: 12) {
                    // Item Counter Badge
                    Text("\(cartManager.totalItemCount)")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.white)
                        .frame(width: 30, height: 30)
                        .background(Color.white.opacity(0.22))
                        .cornerRadius(10)

                    // Price & Free Delivery Tag
                    VStack(alignment: .leading, spacing: 1) {
                        Text(String(format: "₹%.0f", cartManager.subtotal))
                            .font(.system(size: 14, weight: .black))
                            .foregroundColor(.white)

                        if cartManager.deliveryFee == 0 {
                            Text("FREE 45-Min Borzo Delivery Unlocked")
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color.green.opacity(0.3).opacity(0.9).opacity(1))
                                .foregroundColor(Color(red: 0.75, green: 0.98, blue: 0.85))
                        } else {
                            Text(String(format: "Add ₹%.0f more for FREE delivery", cartManager.freeDeliveryRemaining))
                                .font(.system(size: 10, weight: .medium))
                                .foregroundColor(Color(red: 1.0, green: 0.92, blue: 0.65))
                        }
                    }

                    Spacer()

                    // Right CTA Arrow
                    HStack(spacing: 6) {
                        Text("Review Cart")
                            .font(.system(size: 13, weight: .black))
                            .textCase(.uppercase)

                        Image(systemName: "arrow.right")
                            .font(.system(size: 11, weight: .black))
                    }
                    .foregroundColor(.white)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(
                    LinearGradient(
                        colors: [Color(red: 0.08, green: 0.64, blue: 0.29), Color(red: 0.05, green: 0.52, blue: 0.24)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .cornerRadius(20)
                .shadow(color: Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.4), radius: 10, y: 5)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 8)
            .transition(.move(edge: .bottom).combined(with: .opacity))
        }
    }
}

