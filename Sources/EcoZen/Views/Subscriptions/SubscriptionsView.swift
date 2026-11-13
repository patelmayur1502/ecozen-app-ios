import SwiftUI

public struct SubscriptionsView: View {
    @Binding public var selectedTab: Int

    @State private var hasSubscription: Bool = true
    @State private var isPaused: Bool = false

    public init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Navbar
            HStack {
                Text("Restaurant Restock")
                    .font(.system(size: 20, weight: .black))
                Spacer()
                Text("AUTOMATIC 10% OFF")
                    .font(.system(size: 8, weight: .black))
                    .padding(.horizontal, 6)
                    .padding(.vertical, 3)
                    .background(Color.yellow)
                    .foregroundColor(.black)
                    .cornerRadius(4)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 16) {
                    // Restock Banner
                    VStack(alignment: .leading, spacing: 4) {
                        Text("AUTOMATIC SCHEDULED SUPPLY")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(Color(red: 0.75, green: 0.98, blue: 0.85))

                        Text("Never Run Out During Peak Weekend Service")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.white)

                        Text("Scheduled deliveries directly from Mapusa warehouse. 10% off cartons with guaranteed stock reservation.")
                            .font(.system(size: 11))
                            .foregroundColor(.white.opacity(0.85))
                            .lineSpacing(2)
                    }
                    .padding(16)
                    .background(
                        LinearGradient(
                            colors: [Color(red: 0.05, green: 0.38, blue: 0.22), Color(red: 0.08, green: 0.55, blue: 0.35)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .cornerRadius(20)

                    // Active Subscription Card
                    if hasSubscription {
                        VStack(alignment: .leading, spacing: 12) {
                            HStack {
                                Text(isPaused ? "PAUSED" : "SCHEDULED WEEKLY")
                                    .font(.system(size: 9, weight: .black))
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 3)
                                    .background(isPaused ? Color.orange.opacity(0.2) : Color.green.opacity(0.15))
                                    .foregroundColor(isPaused ? .orange : Color(red: 0.08, green: 0.64, blue: 0.29))
                                    .cornerRadius(6)

                                Spacer()

                                Text("Next: Friday, 10:00 AM")
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.secondary)
                            }

                            HStack(spacing: 12) {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(uiColor: .secondarySystemBackground))
                                    .frame(width: 50, height: 50)
                                    .overlay(Text("🍱").font(.system(size: 24)))

                                VStack(alignment: .leading, spacing: 2) {
                                    Text("CHUK 500ml Square Container")
                                        .font(.system(size: 13, weight: .bold))

                                    Text("Bulk Carton (1,000 pcs) • Weekly")
                                        .font(.system(size: 10))
                                        .foregroundColor(.secondary)

                                    HStack(spacing: 6) {
                                        Text("₹5,241 / week")
                                            .font(.system(size: 12, weight: .black))
                                            .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))

                                        Text("₹5,824")
                                            .font(.system(size: 10))
                                            .strikethrough()
                                            .foregroundColor(.secondary)

                                        Text("(10% Off)")
                                            .font(.system(size: 9, weight: .bold))
                                            .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                                    }
                                }
                            }

                            Divider()

                            HStack(spacing: 10) {
                                Button(action: {
                                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                                    isPaused.toggle()
                                }) {
                                    Text(isPaused ? "Resume Restock" : "Pause Restock")
                                        .font(.system(size: 11, weight: .bold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color(uiColor: .secondarySystemBackground))
                                        .foregroundColor(.primary)
                                        .cornerRadius(10)
                                }

                                Button(action: {
                                    selectedTab = 1
                                }) {
                                    Text("Modify Items")
                                        .font(.system(size: 11, weight: .bold))
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.15))
                                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                                        .cornerRadius(10)
                                }
                            }
                        }
                        .padding(14)
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(18)
                    }

                    // Add New Subscription CTA
                    Button(action: {
                        selectedTab = 1
                    }) {
                        VStack(spacing: 8) {
                            Circle()
                                .fill(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.12))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    Image(systemName: "plus")
                                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                                        .font(.system(size: 16, weight: .bold))
                                )

                            Text("Subscribe Another Item")
                                .font(.system(size: 13, weight: .bold))
                                .foregroundColor(.primary)

                            Text("Add meal trays, paper tubs, wooden cutlery, or bio bags to your auto-restock schedule.")
                                .font(.system(size: 10))
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 20)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 24)
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(18)
                        .overlay(
                            RoundedRectangle(cornerRadius: 18)
                                .stroke(style: StrokeStyle(lineWidth: 1.5, dash: [5]))
                                .foregroundColor(Color(uiColor: .separator))
                        )
                    }

                    Spacer().frame(height: 80)
                }
                .padding(16)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

