import SwiftUI

public struct CatalogView: View {
    @ObservedObject private var catalogService = CatalogService.shared
    @Binding public var activeProduct: Product?
    @Binding public var selectedTab: Int

    @State private var selectedCategorySlug: String = "all"
    @State private var selectedMaterial: String = "all"

    public init(activeProduct: Binding<Product?>, selectedTab: Binding<Int>) {
        self._activeProduct = activeProduct
        self._selectedTab = selectedTab
    }

    private var filteredProducts: [Product] {
        var list = catalogService.allProducts

        if selectedCategorySlug != "all" {
            let cat = catalogService.categories.first(where: { $0.slug == selectedCategorySlug })?.name ?? ""
            list = list.filter { ($0.category?.lowercased().contains(cat.lowercased()) ?? false) }
        }

        if selectedMaterial != "all" {
            list = list.filter { ($0.material?.lowercased().contains(selectedMaterial.lowercased()) ?? false) }
        }

        return list.isEmpty ? catalogService.allProducts : list
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Nav
                HStack {
                    Text("Product Catalog")
                        .font(.system(size: 20, weight: .black))
                    Spacer()
                    Text("\(filteredProducts.count) Items")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal, 16)
                .padding(.top, 10)
                .padding(.bottom, 8)
                .background(Color(uiColor: .systemBackground))

                // Material Quick Filters
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        materialFilterPill(title: "All", tag: "all")
                        materialFilterPill(title: "Sugarcane Bagasse", tag: "bagasse")
                        materialFilterPill(title: "Kraft Paper", tag: "kraft")
                        materialFilterPill(title: "Birchwood", tag: "birch")
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                }
                .background(Color(uiColor: .systemBackground))

                // Catalog Scrollable Content
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 14) {
                        // Sample Kit Promo (₹49)
                        sampleKitPromoBanner

                        // Product Grid
                        LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                            ForEach(filteredProducts) { product in
                                ProductCardView(product: product) {
                                    activeProduct = product
                                }
                            }
                        }
                        .padding(.horizontal, 16)

                        Spacer().frame(height: 90)
                    }
                    .padding(.top, 12)
                }
            }

            FloatingCartBar {
                selectedTab = 3
            }
        }
    }

    private func materialFilterPill(title: String, tag: String) -> some View {
        Button(action: {
            UIImpactFeedbackGenerator(style: .light).impactOccurred()
            selectedMaterial = tag
        }) {
            Text(title)
                .font(.system(size: 11, weight: selectedMaterial == tag ? .black : .medium))
                .foregroundColor(selectedMaterial == tag ? .white : .primary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(selectedMaterial == tag ? Color(red: 0.08, green: 0.64, blue: 0.29) : Color(uiColor: .secondarySystemFill))
                .cornerRadius(12)
        }
    }

    private var sampleKitPromoBanner: some View {
        HStack(spacing: 12) {
            Text("📦")
                .font(.system(size: 32))

            VStack(alignment: .leading, spacing: 2) {
                Text("Restaurant Sample Kit (₹49)")
                    .font(.system(size: 13, weight: .black))
                    .foregroundColor(Color(red: 0.45, green: 0.25, blue: 0.05))

                Text("Test lid fitment and food heat retention before ordering bulk cartons.")
                    .font(.system(size: 10))
                    .foregroundColor(Color(red: 0.55, green: 0.35, blue: 0.15))
            }

            Spacer()

            Button(action: {
                UIImpactFeedbackGenerator(style: .medium).impactOccurred()
                let sampleProduct = Product(
                    id: 999,
                    name: "Restaurant Sample Kit (Curated 10 Pcs)",
                    loose_price: 49.0,
                    box_price: 49.0
                )
                CartManager.shared.add(product: sampleProduct, unit: .loose, quantity: 1)
            }) {
                Text("+ ORDER")
                    .font(.system(size: 10, weight: .black))
                    .foregroundColor(.black)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color.yellow)
                    .cornerRadius(8)
            }
        }
        .padding(12)
        .background(Color.yellow.opacity(0.18))
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.yellow.opacity(0.4), lineWidth: 1)
        )
        .padding(.horizontal, 16)
    }
}

