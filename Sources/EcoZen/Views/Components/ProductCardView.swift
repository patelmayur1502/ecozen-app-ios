import SwiftUI

public struct ProductCardView: View {
    public let product: Product
    public let onSelect: () -> Void

    @ObservedObject private var cartManager = CartManager.shared
    @State private var selectedUnit: PackagingUnit = .loose

    public init(product: Product, onSelect: @escaping () -> Void) {
        self.product = product
        self.onSelect = onSelect
    }

    private var currentQuantity: Int {
        cartManager.quantity(of: product, unit: selectedUnit)
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            // Product Visual & Badges
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(uiColor: .secondarySystemBackground))
                    .frame(height: 120)
                    .overlay(
                        Text(categoryEmoji(for: product.category ?? ""))
                            .font(.system(size: 48))
                    )
                    .onTapGesture {
                        onSelect()
                    }

                // Badge
                if product.is_bestseller == true {
                    Text("BESTSELLER")
                        .font(.system(size: 8, weight: .black))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.yellow)
                        .foregroundColor(.black)
                        .cornerRadius(6)
                        .padding(6)
                } else if product.is_trending == true {
                    Text("TRENDING")
                        .font(.system(size: 8, weight: .black))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.red.opacity(0.15))
                        .foregroundColor(.red)
                        .cornerRadius(6)
                        .padding(6)
                } else if product.is_new == true {
                    Text("NEW")
                        .font(.system(size: 8, weight: .black))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 3)
                        .background(Color.teal.opacity(0.15))
                        .foregroundColor(.teal)
                        .cornerRadius(6)
                        .padding(6)
                }
            }

            // ETA Tag
            HStack(spacing: 4) {
                Image(systemName: "bolt.fill")
                    .font(.system(size: 9))
                    .foregroundColor(.orange)
                Text("45 mins dispatch")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
            }

            // Title
            Text(product.name)
                .font(.system(size: 12, weight: .bold))
                .lineLimit(2)
                .foregroundColor(.primary)
                .onTapGesture {
                    onSelect()
                }

            // Dual Unit Packaging Toggle Pill
            HStack(spacing: 2) {
                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    selectedUnit = .loose
                }) {
                    Text(product.unitQuantityText(for: .loose))
                        .font(.system(size: 9, weight: selectedUnit == .loose ? .black : .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .background(selectedUnit == .loose ? Color.white : Color.clear)
                        .foregroundColor(selectedUnit == .loose ? Color(red: 0.08, green: 0.64, blue: 0.29) : .secondary)
                        .cornerRadius(6)
                        .shadow(color: selectedUnit == .loose ? Color.black.opacity(0.08) : .clear, radius: 1)
                }

                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    selectedUnit = .box
                }) {
                    Text(product.unitQuantityText(for: .box))
                        .font(.system(size: 9, weight: selectedUnit == .box ? .black : .medium))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .background(selectedUnit == .box ? Color.white : Color.clear)
                        .foregroundColor(selectedUnit == .box ? Color(red: 0.08, green: 0.64, blue: 0.29) : .secondary)
                        .cornerRadius(6)
                        .shadow(color: selectedUnit == .box ? Color.black.opacity(0.08) : .clear, radius: 1)
                }
            }
            .padding(2)
            .background(Color(uiColor: .tertiarySystemFill))
            .cornerRadius(8)

            // Price & Add Button
            HStack(alignment: .bottom) {
                VStack(alignment: .leading, spacing: 1) {
                    Text(String(format: "₹%.0f", product.effectivePrice(for: selectedUnit)))
                        .font(.system(size: 14, weight: .black))
                        .foregroundColor(.primary)

                    Text(product.unitPerPieceText(for: selectedUnit))
                        .font(.system(size: 9, weight: .medium))
                        .foregroundColor(.secondary)
                }

                Spacer()

                // Blinkit ADD Button or Stepper
                if currentQuantity == 0 {
                    Button(action: {
                        UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                        cartManager.add(product: product, unit: selectedUnit, quantity: 1)
                    }) {
                        Text("+ ADD")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(.white)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(red: 0.08, green: 0.64, blue: 0.29))
                            .cornerRadius(8)
                            .shadow(color: Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.3), radius: 3, y: 1)
                    }
                } else {
                    HStack(spacing: 8) {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            cartManager.remove(product: product, unit: selectedUnit)
                        }) {
                            Text("−")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                        }

                        Text("\(currentQuantity)")
                            .font(.system(size: 11, weight: .black))
                            .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))

                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            cartManager.add(product: product, unit: selectedUnit, quantity: 1)
                        }) {
                            Text("+")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.12))
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color(red: 0.08, green: 0.64, blue: 0.29), lineWidth: 1)
                    )
                }
            }
            .padding(.top, 2)
        }
        .padding(10)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(18)
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: 2)
    }

    private func categoryEmoji(for category: String) -> String {
        let cat = category.lowercased()
        if cat.contains("baggase") || cat.contains("tray") { return "🍱" }
        if cat.contains("paper") || cat.contains("tub") { return "🥡" }
        if cat.contains("cutlery") || cat.contains("spoon") { return "🍴" }
        if cat.contains("bag") { return "🛍️" }
        if cat.contains("candle") { return "🕯️" }
        if cat.contains("hygiene") || cat.contains("spray") { return "🧼" }
        return "📦"
    }
}

