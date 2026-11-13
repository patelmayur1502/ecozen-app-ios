import SwiftUI

public struct ProductDetailView: View {
    public let product: Product
    public let onDismiss: () -> Void

    @ObservedObject private var cartManager = CartManager.shared
    @State private var selectedUnit: PackagingUnit = .box
    @State private var quantity: Int = 1

    public init(product: Product, onDismiss: @escaping () -> Void) {
        self.product = product
        self.onDismiss = onDismiss
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Navbar
            HStack {
                Button(action: onDismiss) {
                    Circle()
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "chevron.left")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.primary)
                        )
                }

                Spacer()

                Text("Product Specifications")
                    .font(.system(size: 14, weight: .black))

                Spacer()

                Button(action: {}) {
                    Circle()
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "square.and.arrow.up")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.primary)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))

            // Scrollable Content
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // Hero Visual Showcase
                    ZStack(alignment: .topLeading) {
                        RoundedRectangle(cornerRadius: 24)
                            .fill(Color(uiColor: .secondarySystemBackground))
                            .frame(height: 220)
                            .overlay(
                                Text(productEmoji)
                                    .font(.system(size: 84))
                            )

                        HStack(spacing: 6) {
                            Text("100% COMPOSTABLE")
                                .font(.system(size: 9, weight: .black))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.15))
                                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                                .cornerRadius(6)

                            Text("MICROWAVE SAFE")
                                .font(.system(size: 9, weight: .black))
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange.opacity(0.15))
                                .foregroundColor(.orange)
                                .cornerRadius(6)
                        }
                        .padding(12)
                    }

                    // Title & Description
                    VStack(alignment: .leading, spacing: 6) {
                        HStack(spacing: 4) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.orange)
                                .font(.system(size: 11))
                            Text("4.9")
                                .font(.system(size: 12, weight: .black))
                            Text("(184 Goa restaurants review)")
                                .font(.system(size: 11))
                                .foregroundColor(.secondary)
                        }

                        Text(product.name)
                            .font(.system(size: 18, weight: .black))
                            .foregroundColor(.primary)

                        Text(product.description ?? "Sustainable, commercial-grade food packaging for takeaways and dining.")
                            .font(.system(size: 12))
                            .foregroundColor(.secondary)
                            .lineSpacing(3)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(14)
                    .background(Color(uiColor: .systemBackground))
                    .cornerRadius(18)

                    // Matching Lid Card (Website Sync: MatchingLidCard.tsx)
                    matchingLidCard

                    // Packaging Volume Selector Cards
                    packagingSelectionSection

                    // Technical Specifications Table
                    specsTableSection

                    // Environmental Impact Box
                    ecoImpactBox

                    Spacer().frame(height: 20)
                }
                .padding(16)
            }

            // Bottom Sticky Add To Cart CTA
            bottomActionSheet
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var productEmoji: String {
        let cat = (product.category ?? "").lowercased()
        if cat.contains("baggase") || cat.contains("tray") { return "🍱" }
        if cat.contains("paper") || cat.contains("tub") { return "🥡" }
        if cat.contains("cutlery") { return "🍴" }
        if cat.contains("bag") { return "🛍️" }
        return "📦"
    }

    private var matchingLidCard: some View {
        HStack(spacing: 12) {
            Text("🔒")
                .font(.system(size: 28))

            VStack(alignment: .leading, spacing: 2) {
                Text("FREQUENTLY BOUGHT TOGETHER")
                    .font(.system(size: 8, weight: .black))
                    .foregroundColor(.blue)

                Text("Matching Leakproof Lid (100 pcs)")
                    .font(.system(size: 12, weight: .bold))

                Text("₹420 per pack • Perfect snap-fit")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                let lid = Product(
                    id: 998,
                    name: "Matching 500ml Leakproof Lid",
                    loose_price: 420.0,
                    box_price: 3600.0
                )
                cartManager.add(product: lid, unit: .loose, quantity: 1)
            }) {
                Text("+ ADD LID")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.blue)
                    .cornerRadius(8)
            }
        }
        .padding(12)
        .background(Color.blue.opacity(0.08))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.blue.opacity(0.2), lineWidth: 1)
        )
    }

    private var packagingSelectionSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SELECT PACKAGING VOLUME")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.secondary)

            // Carton Option (Bulk)
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                selectedUnit = .box
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        HStack(spacing: 6) {
                            Text("Bulk Carton (\(product.box_quantity ?? 1000) pcs)")
                                .font(.system(size: 13, weight: .black))
                                .foregroundColor(.primary)

                            Text("SAVE 15%")
                                .font(.system(size: 8, weight: .black))
                                .padding(.horizontal, 5)
                                .padding(.vertical, 2)
                                .background(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.15))
                                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                                .cornerRadius(4)
                        }

                        Text("Commercial restaurant pack • \(product.unitPerPieceText(for: .box))")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    VStack(alignment: .trailing, spacing: 1) {
                        Text(String(format: "₹%.0f", product.effectivePrice(for: .box)))
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))

                        Text(String(format: "₹%.0f", (product.effectivePrice(for: .box) * 1.18)))
                            .font(.system(size: 10))
                            .strikethrough()
                            .foregroundColor(.secondary)
                    }
                }
                .padding(14)
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(selectedUnit == .box ? Color(red: 0.08, green: 0.64, blue: 0.29) : Color.clear, lineWidth: 2)
                )
            }

            // Loose Pack Option (Trial / Emergency)
            Button(action: {
                UIImpactFeedbackGenerator(style: .light).impactOccurred()
                selectedUnit = .loose
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Pack of \(product.loose_quantity ?? 100) pcs")
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.primary)

                        Text("Emergency top-up / Trial pack • \(product.unitPerPieceText(for: .loose))")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Text(String(format: "₹%.0f", product.effectivePrice(for: .loose)))
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                }
                .padding(14)
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(16)
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(selectedUnit == .loose ? Color(red: 0.08, green: 0.64, blue: 0.29) : Color.clear, lineWidth: 2)
                )
            }
        }
    }

    private var specsTableSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("SPECIFICATIONS")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.secondary)

            VStack(spacing: 8) {
                specRow(label: "Material", value: product.material ?? "Sugarcane Agro Bagasse")
                Divider()
                specRow(label: "Dimensions", value: product.dimensions ?? "135 x 135 x 45 mm")
                Divider()
                specRow(label: "HSN Code", value: product.hsn_code ?? "48237090")
                Divider()
                specRow(label: "Thermal Range", value: "-20°C to +120°C")
            }
            .padding(14)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(16)
        }
    }

    private func specRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(.primary)
        }
    }

    private var ecoImpactBox: some View {
        HStack(spacing: 12) {
            Text("🌱")
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: 2) {
                Text("Environmental Sustainability")
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(Color(red: 0.05, green: 0.45, blue: 0.25))

                Text("This order diverts approx 2.8 kg of single-use plastic from Goa's beaches.")
                    .font(.system(size: 10))
                    .foregroundColor(Color(red: 0.15, green: 0.55, blue: 0.35))
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.1))
        .cornerRadius(16)
    }

    private var bottomActionSheet: some View {
        HStack(spacing: 12) {
            // Quantity Stepper
            HStack(spacing: 12) {
                Button(action: {
                    if quantity > 1 {
                        UIImpactFeedbackGenerator(style: .light).impactOccurred()
                        quantity -= 1
                    }
                }) {
                    Text("−")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }

                Text("\(quantity)")
                    .font(.system(size: 14, weight: .black))

                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                    quantity += 1
                }) {
                    Text("+")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(.primary)
                }
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(Color(uiColor: .secondarySystemBackground))
            .cornerRadius(14)

            // Add To Cart Button
            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                cartManager.add(product: product, unit: selectedUnit, quantity: quantity)
                onDismiss()
            }) {
                HStack {
                    Text("Add \(selectedUnit == .box ? "Carton" : "Pack") to Cart")
                        .font(.system(size: 13, weight: .black))

                    Spacer()

                    Text(String(format: "₹%.0f", product.effectivePrice(for: selectedUnit) * Double(quantity)))
                        .font(.system(size: 14, weight: .black))
                }
                .foregroundColor(.white)
                .padding(.horizontal, 16)
                .padding(.vertical, 14)
                .background(Color(red: 0.08, green: 0.64, blue: 0.29))
                .cornerRadius(16)
                .shadow(color: Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.3), radius: 6, y: 3)
            }
        }
        .padding(16)
        .background(Color(uiColor: .systemBackground))
        .shadow(color: Color.black.opacity(0.05), radius: 8, y: -2)
    }
}

