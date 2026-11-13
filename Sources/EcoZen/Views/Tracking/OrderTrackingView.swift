import SwiftUI

public struct OrderTrackingView: View {
    @Binding public var selectedTab: Int

    @State private var currentOrder = OrderRecord(
        id: "ord-9284",
        orderNumber: "EZP-9284",
        totalAmount: 8070.0,
        itemCount: 2
    )

    @State private var showCancelConfirmation: Bool = false
    @State private var isCancelled: Bool = false

    public init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
    }

    public var body: some View {
        VStack(spacing: 0) {
            // Navbar
            HStack {
                Button(action: {
                    selectedTab = 0
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundColor(.primary)
                }

                Spacer()

                Text("Order #\(currentOrder.orderNumber)")
                    .font(.system(size: 14, weight: .black))

                Spacer()

                Button(action: {}) {
                    Image(systemName: "headphones")
                        .font(.system(size: 15))
                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color(uiColor: .systemBackground))

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 14) {
                    // Live Status Banner
                    liveStatusHero

                    // 4-Stage Progress Line
                    progressTimelineSection

                    // Borzo Partner Card
                    borzoCourierCard

                    // WhatsApp PDF Tax Invoice Button
                    whatsappInvoiceButton

                    // Order Cancellation & Return Management
                    orderActionsSection

                    Spacer().frame(height: 40)
                }
                .padding(16)
            }
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .alert("Cancel Order?", isPresented: $showCancelConfirmation) {
            Button("Cancel Order", role: .destructive) {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                isCancelled = true
                currentOrder.status = .cancelled
            }
            Button("Keep Order", role: .cancel) {}
        } message: {
            Text("Are you sure you want to cancel? If paid via Razorpay, an instant refund will be initiated to your original payment method.")
        }
    }

    private var liveStatusHero: some View {
        VStack(spacing: 6) {
            Text("🛵")
                .font(.system(size: 40))

            Text("BORZO EXPRESS ACTIVE")
                .font(.system(size: 9, weight: .black))
                .padding(.horizontal, 6)
                .padding(.vertical, 2)
                .background(Color.black.opacity(0.2))
                .foregroundColor(Color(red: 0.75, green: 0.98, blue: 0.85))
                .cornerRadius(4)

            Text(isCancelled ? "Order Cancelled" : "Reaching Cafe in \(currentOrder.etaMinutes) Mins")
                .font(.system(size: 18, weight: .black))
                .foregroundColor(.white)

            Text(isCancelled ? "Stock restored and refund queued to Razorpay." : "Rider \(currentOrder.borzoCourierName ?? "Rajesh") picked up boxes from Mapusa warehouse.")
                .font(.system(size: 11))
                .foregroundColor(.white.opacity(0.85))
                .multilineTextAlignment(.center)
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: isCancelled ? [Color.red.opacity(0.8), Color.red] : [Color(red: 0.08, green: 0.64, blue: 0.29), Color(red: 0.05, green: 0.50, blue: 0.22)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
        .cornerRadius(22)
    }

    private var progressTimelineSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("LIVE DELIVERY TIMELINE")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.secondary)

            HStack {
                stepItem(title: "Placed", isDone: true, isCurrent: false)
                stepConnector(isDone: true)
                stepItem(title: "Packed", isDone: true, isCurrent: false)
                stepConnector(isDone: !isCancelled)
                stepItem(title: "On Route", isDone: !isCancelled, isCurrent: !isCancelled)
                stepConnector(isDone: false)
                stepItem(title: "Delivered", isDone: false, isCurrent: false)
            }
        }
        .padding(16)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(18)
    }

    private func stepItem(title: String, isDone: Bool, isCurrent: Bool) -> some View {
        VStack(spacing: 4) {
            Circle()
                .fill(isDone ? Color(red: 0.08, green: 0.64, blue: 0.29) : Color(uiColor: .tertiarySystemFill))
                .frame(width: 24, height: 24)
                .overlay(
                    Image(systemName: isDone ? "checkmark" : "circle")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(isDone ? .white : .secondary)
                )

            Text(title)
                .font(.system(size: 9, weight: isCurrent ? .black : .medium))
                .foregroundColor(isCurrent ? Color(red: 0.08, green: 0.64, blue: 0.29) : .secondary)
        }
    }

    private func stepConnector(isDone: Bool) -> some View {
        Rectangle()
            .fill(isDone ? Color(red: 0.08, green: 0.64, blue: 0.29) : Color(uiColor: .tertiarySystemFill))
            .frame(height: 2)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 14)
    }

    private var borzoCourierCard: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color(uiColor: .secondarySystemBackground))
                .frame(width: 44, height: 44)
                .overlay(Text("👨‍✈️").font(.system(size: 24)))

            VStack(alignment: .leading, spacing: 2) {
                Text(currentOrder.borzoCourierName ?? "Rajesh Naik")
                    .font(.system(size: 13, weight: .bold))

                Text("Borzo Partner • \(currentOrder.borzoVehicle ?? "GA-03")")
                    .font(.system(size: 10))
                    .foregroundColor(.secondary)
            }

            Spacer()

            Button(action: {}) {
                Circle()
                    .fill(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.12))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "phone.fill")
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                    )
            }
        }
        .padding(14)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(18)
    }

    private var whatsappInvoiceButton: some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
        }) {
            HStack(spacing: 10) {
                Image(systemName: "message.fill")
                    .foregroundColor(Color.green)
                    .font(.system(size: 16))

                VStack(alignment: .leading, spacing: 1) {
                    Text("Download GST Tax Invoice (PDF)")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.primary)

                    Text("Invoice #\(currentOrder.gstInvoiceNumber ?? "EZP-001") • Sent via WhatsApp")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Image(systemName: "arrow.down.doc.fill")
                    .font(.system(size: 12))
                    .foregroundColor(.secondary)
            }
            .padding(14)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(16)
        }
    }

    private var orderActionsSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("ORDER MANAGEMENT & RETURNS")
                .font(.system(size: 10, weight: .black))
                .foregroundColor(.secondary)

            HStack(spacing: 10) {
                if !isCancelled {
                    Button(action: {
                        showCancelConfirmation = true
                    }) {
                        Text("Cancel Order")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundColor(.red)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 10)
                            .background(Color.red.opacity(0.1))
                            .cornerRadius(12)
                    }
                }

                Button(action: {
                    UIImpactFeedbackGenerator(style: .light).impactOccurred()
                }) {
                    Text("Request Return")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(Color(uiColor: .secondarySystemBackground))
                        .cornerRadius(12)
                }
            }

            Text("Instant Razorpay refund is credited if cancelled prior to courier pickup. Return requests are accepted within 48 hours of delivery.")
                .font(.system(size: 9))
                .foregroundColor(.secondary)
                .padding(.top, 2)
        }
        .padding(14)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(18)
    }
}

