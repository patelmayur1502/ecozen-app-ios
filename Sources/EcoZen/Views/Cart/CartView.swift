import SwiftUI

public struct CartView: View {
    @ObservedObject private var cartManager = CartManager.shared
    @Binding public var selectedTab: Int
    @State private var couponInput: String = ""
    @State private var showOrderPlacedAlert: Bool = false

    public init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Navbar
            HStack {
                Text("Review Cart (\(cartManager.totalItemCount))")
                    .font(.system(size: 20, weight: .black))

                Spacer()

                Button("+ Add More") {
                    selectedTab = 1
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))

            if cartManager.items.isEmpty {
                emptyCartView
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Free Delivery Banner
                        deliveryThresholdBanner

                        // Item List
                        cartItemsSection

                        // B2B GST Invoicing Section
                        gstInvoiceSection

                        // Coupon Code Box
                        couponSection

                        // Rider Tip
                        riderTipSection

                        // Bill Summary
                        billSummarySection

                        // Delivery Address Card
                        deliveryAddressCard

                        Spacer().frame(height: 100)
                    }
                    .padding(16)
                }

                // Sticky Bottom Pay CTA
                bottomCheckoutBar
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var emptyCartView: some View {
        VStack(spacing: 12) {
            Spacer()
            Text("🛒")
                .font(.system(size: 64))
            Text("Your cart is empty")
                .font(.system(size: 16, weight: .bold))
            Text("Browse our 100% compostable packaging catalog and stock up your kitchen.")
                .font(.system(size: 12))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)

            Button(action: {
                selectedTab = 0
            }) {
                Text("Start Shopping")
                    .font(.system(size: 13, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                    .background(Color(red: 0.08, green: 0.64, blue: 0.29))
                    .cornerRadius(12)
            }
            .padding(.top, 8)
            Spacer()
        }
    }

    private var deliveryThresholdBanner: some View {
        HStack(spacing: 10) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                .font(.system(size: 18))

            if cartManager.deliveryFee == 0 {
                Text("FREE 45-Min Borzo Dispatch applied to your order (Order > ₹499)")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(red: 0.08, green: 0.52, blue: 0.24))
            } else {
                Text(String(format: "Add ₹%.0f more for FREE 45-min Borzo Delivery", cartManager.freeDeliveryRemaining))
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(Color(red: 0.65, green: 0.45, blue: 0.05))
            }
        }
        .padding(12)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.12))
        .cornerRadius(14)
    }

    private var cartItemsSection: some View {
        VStack(spacing: 12) {
            ForEach(cartManager.items) { item in
                HStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color(uiColor: .secondarySystemBackground))
                        .frame(width: 48, height: 48)
                        .overlay(Text("🍱").font(.system(size: 24)))

                    VStack(alignment: .leading, spacing: 2) {
                        Text(item.product.name)
                            .font(.system(size: 12, weight: .bold))
                            .lineLimit(1)

                        Text("\(item.unit.displayName) (\(item.unit == .loose ? (item.product.loose_quantity ?? 100) : (item.product.box_quantity ?? 1000)) pcs)")
                            .font(.system(size: 10))
                            .foregroundColor(.secondary)

                        Text(String(format: "₹%.0f", item.itemTotal))
                            .font(.system(size: 13, weight: .black))
                            .foregroundColor(.primary)
                    }

                    Spacer()

                    // Stepper
                    HStack(spacing: 8) {
                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            cartManager.remove(product: item.product, unit: item.unit)
                        }) {
                            Text("−")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                        }

                        Text("\(item.quantity)")
                            .font(.system(size: 12, weight: .black))
                            .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))

                        Button(action: {
                            UIImpactFeedbackGenerator(style: .light).impactOccurred()
                            cartManager.add(product: item.product, unit: item.unit, quantity: 1)
                        }) {
                            Text("+")
                                .font(.system(size: 14, weight: .bold))
                                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                        }
                    }
                    .padding(.horizontal, 8)
                    .padding(.vertical, 5)
                    .background(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.1))
                    .cornerRadius(8)
                }
                .padding(12)
                .background(Color(uiColor: .systemBackground))
                .cornerRadius(16)
            }
        }
    }

    private var gstInvoiceSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Toggle(isOn: $cartManager.hasGstInputTaxCredit) {
                HStack(spacing: 6) {
                    Image(systemName: "doc.text.fill")
                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                        .font(.system(size: 12))

                    Text("Claim B2B GST Input Tax Credit")
                        .font(.system(size: 12, weight: .bold))
                }
            }
            .tint(Color(red: 0.08, green: 0.64, blue: 0.29))

            if cartManager.hasGstInputTaxCredit {
                VStack(spacing: 6) {
                    HStack {
                        Text("Business:")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(cartManager.businessName)
                            .font(.system(size: 10, weight: .bold))
                    }
                    HStack {
                        Text("GSTIN:")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(cartManager.gstinNumber)
                            .font(.system(size: 10, weight: .bold))
                            .fontDesign(.monospaced)
                    }
                    Text("✓ Compliant tax invoice will be generated and delivered via WhatsApp.")
                        .font(.system(size: 9))
                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top, 2)
                }
                .padding(10)
                .background(Color(uiColor: .secondarySystemBackground))
                .cornerRadius(12)
            }
        }
        .padding(14)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
    }

    private var couponSection: some View {
        HStack(spacing: 8) {
            Image(systemName: "tag.fill")
                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                .font(.system(size: 12))

            TextField("Coupon Code (e.g. ECOGOA)", text: $couponInput)
                .font(.system(size: 12))
                .textCase(.uppercase)

            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                if couponInput.uppercased() == "ECOGOA" {
                    cartManager.discountAmount = 100.0
                }
            }) {
                Text("APPLY")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.white)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.primary)
                    .cornerRadius(8)
            }
        }
        .padding(12)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(14)
    }

    private var riderTipSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text("Tip Borzo Courier Partner")
                    .font(.system(size: 12, weight: .bold))
                Spacer()
                Text("100% goes to rider")
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }

            HStack(spacing: 8) {
                tipButton(amount: 20)
                tipButton(amount: 30)
                tipButton(amount: 50)
            }
        }
        .padding(14)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
    }

    private func tipButton(amount: Double) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            cartManager.riderTip = amount
        }) {
            Text("₹\(Int(amount))")
                .font(.system(size: 12, weight: cartManager.riderTip == amount ? .black : .bold))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(cartManager.riderTip == amount ? Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.15) : Color(uiColor: .secondarySystemBackground))
                .foregroundColor(cartManager.riderTip == amount ? Color(red: 0.08, green: 0.64, blue: 0.29) : .primary)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(cartManager.riderTip == amount ? Color(red: 0.08, green: 0.64, blue: 0.29) : Color.clear, lineWidth: 1.5)
                )
        }
    }

    private var billSummarySection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Bill Details")
                    .font(.system(size: 12, weight: .black))
                Spacer()
            }
            summaryRow(label: "Item Total", value: String(format: "₹%.2f", cartManager.subtotal))

            if cartManager.discountAmount > 0 {
                summaryRow(label: "Coupon Discount", value: String(format: "-₹%.2f", cartManager.discountAmount), isDiscount: true)
            }

            summaryRow(label: "Borzo Hyperlocal Delivery", value: cartManager.deliveryFee == 0 ? "FREE" : "₹95.00", isFree: cartManager.deliveryFee == 0)
            summaryRow(label: "GST (18% Input Tax Credit)", value: String(format: "₹%.2f", cartManager.gstAmount))
            summaryRow(label: "Courier Partner Tip", value: String(format: "₹%.2f", cartManager.riderTip))

            Divider().padding(.vertical, 2)

            HStack {
                Text("To Pay")
                    .font(.system(size: 14, weight: .black))
                Spacer()
                Text(String(format: "₹%.2f", cartManager.grandTotal))
                    .font(.system(size: 16, weight: .black))
                    .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
            }
        }
        .padding(14)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(16)
    }

    private func summaryRow(label: String, value: String, isFree: Bool = false, isDiscount: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 11))
                .foregroundColor(.secondary)
            Spacer()
            Text(value)
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(isFree || isDiscount ? Color(red: 0.08, green: 0.64, blue: 0.29) : .primary)
        }
    }

    private var deliveryAddressCard: some View {
        HStack(spacing: 10) {
            Image(systemName: "mappin.circle.fill")
                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 2) {
                Text("Delivering to:")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.secondary)
                Text(cartManager.deliveryAddress)
                    .font(.system(size: 11, weight: .bold))
                    .lineLimit(1)
            }

            Spacer()

            Text("Change")
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
        }
        .padding(12)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(14)
    }

    private var bottomCheckoutBar: some View {
        VStack(spacing: 0) {
            Button(action: {
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
                // Transition directly to Live Tracking
                selectedTab = 4
            }) {
                HStack {
                    VStack(alignment: .leading, spacing: 1) {
                        Text(String(format: "₹%.0f", cartManager.grandTotal))
                            .font(.system(size: 15, weight: .black))
                        Text("TOTAL (INCL. GST)")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundColor(Color(red: 0.75, green: 0.98, blue: 0.85))
                    }

                    Spacer()

                    HStack(spacing: 6) {
                        Text("Pay via UPI / COD ➔")
                            .font(.system(size: 13, weight: .black))
                    }
                }
                .foregroundColor(.white)
                .padding(.horizontal, 18)
                .padding(.vertical, 14)
                .background(Color(red: 0.08, green: 0.64, blue: 0.29))
                .cornerRadius(16)
                .shadow(color: Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.35), radius: 8, y: 3)
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)
            .padding(.bottom, 12)
        }
        .background(Color(uiColor: .systemBackground))
        .shadow(color: Color.black.opacity(0.04), radius: 6, y: -2)
    }
}

