import SwiftUI

public struct AccountView: View {
    @ObservedObject private var cartManager = CartManager.shared
    @Binding public var selectedTab: Int

    public init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Navbar
            HStack {
                Text("Restaurant Account")
                    .font(.system(size: 20, weight: .black))
                Spacer()
                Button("Log Out") {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.red)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 14) {
                    // Business Profile Card
                    profileHeaderCard

                    // Quick Actions
                    accountLinksSection

                    // Support on WhatsApp
                    whatsappSupportCard

                    // Policies & Institutional Information
                    policiesSection

                    Spacer().frame(height: 40)
                }
                .padding(16)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }

    private var profileHeaderCard: some View {
        HStack(spacing: 14) {
            Circle()
                .fill(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.15))
                .frame(width: 54, height: 54)
                .overlay(
                    Text("CH")
                        .font(.system(size: 20, weight: .black))
                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                )

            VStack(alignment: .leading, spacing: 3) {
                Text(cartManager.businessName)
                    .font(.system(size: 15, weight: .black))

                Text("GSTIN: \(cartManager.gstinNumber)")
                    .font(.system(size: 10, weight: .medium))
                    .fontDesign(.monospaced)
                    .foregroundColor(.secondary)

                HStack(spacing: 4) {
                    Image(systemName: "checkmark.seal.fill")
                        .font(.system(size: 10))
                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))

                    Text("Verified B2B Account (Tier 1 Volume Pricing)")
                        .font(.system(size: 9, weight: .bold))
                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                }
                .padding(.top, 1)
            }
            Spacer()
        }
        .padding(14)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(18)
    }

    private var accountLinksSection: some View {
        VStack(spacing: 0) {
            linkRow(icon: "receipt", title: "Order History & Invoices", badge: "2 Orders") {
                selectedTab = 4 // Tracking view
            }
            Divider().padding(.leading, 44)

            linkRow(icon: "repeat", title: "Restock Subscriptions", badge: "1 Active") {
                selectedTab = 2 // Subscriptions view
            }
            Divider().padding(.leading, 44)

            linkRow(icon: "mappin.and.ellipse", title: "Kitchen Delivery Addresses", badge: "North Goa") {}
            Divider().padding(.leading, 44)

            linkRow(icon: "creditcard", title: "Saved Payment Methods", badge: "UPI / Cards") {}
        }
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(18)
    }

    private func linkRow(icon: String, title: String, badge: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                    .frame(width: 20)

                Text(title)
                    .font(.system(size: 12, weight: .bold))
                    .foregroundColor(.primary)

                Spacer()

                if let badge {
                    Text(badge)
                        .font(.system(size: 9, weight: .bold))
                        .padding(.horizontal, 6)
                        .padding(.vertical, 2)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .foregroundColor(.secondary)
                        .cornerRadius(6)
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 10, weight: .bold))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 14)
        }
    }

    private var whatsappSupportCard: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        }) {
            HStack(spacing: 12) {
                Image(systemName: "message.circle.fill")
                    .font(.system(size: 26))
                    .foregroundColor(.green)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Chat with Goa Dispatch on WhatsApp")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)

                    Text("Direct escalation for urgent bulk orders or courier coordination.")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.secondary)
            }
            .padding(14)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(18)
        }
    }

    private var policiesSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("POLICIES & LEGAL")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.secondary)

            VStack(spacing: 0) {
                policyRow(title: "Who We Serve (Goa Hospitality)")
                Divider()
                policyRow(title: "Goa Delivery Zones & Borzo Fleet Rules")
                Divider()
                policyRow(title: "Return & Refund Policy (Instant Reversal)")
                Divider()
                policyRow(title: "Terms of Service & Privacy Policy")
            }
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(18)
        }
    }

    private func policyRow(title: String) -> some View {
        HStack {
            Text(title)
                .font(.system(size: 11))
                .foregroundColor(.primary)
            Spacer()
            Image(systemName: "chevron.right")
                .font(.system(size: 9))
                .foregroundColor(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
    }
}

