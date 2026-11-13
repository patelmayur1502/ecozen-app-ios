import SwiftUI

public struct MainTabView: View {
    @State private var selectedTab: Int = 0
    @State private var activeProduct: Product? = nil
    @ObservedObject private var cartManager = CartManager.shared

    public init() {}

    public var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab, activeProduct: $activeProduct)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)

            CatalogView(activeProduct: $activeProduct, selectedTab: $selectedTab)
                .tabItem {
                    Label("Catalog", systemImage: "square.grid.2x2.fill")
                }
                .tag(1)

            SubscriptionsView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Restock", systemImage: "repeat.circle.fill")
                }
                .tag(2)

            CartView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Cart", systemImage: "bag.fill")
                }
                .badge(cartManager.totalItemCount > 0 ? "\(cartManager.totalItemCount)" : nil)
                .tag(3)

            AccountView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Account", systemImage: "person.crop.circle.fill")
                }
                .tag(4)
        }
        .tint(Color(red: 0.08, green: 0.64, blue: 0.29))
        .sheet(item: $activeProduct) { product in
            ProductDetailView(product: product) {
                activeProduct = nil
            }
        }
    }
}

