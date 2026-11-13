import SwiftUI

public struct HomeView: View {
    @ObservedObject private var catalogService = CatalogService.shared
    @ObservedObject private var cartManager = CartManager.shared

    @State private var searchQuery: String = ""
    @Binding public var selectedTab: Int
    @Binding public var activeProduct: Product?

    public init(selectedTab: Binding<Int>, activeProduct: Binding<Product?>) {
        self._selectedTab = selectedTab
        self._activeProduct = activeProduct
    }

    private var displayedProducts: [Product] {
        if !searchQuery.isEmpty {
            return catalogService.searchProducts(query: searchQuery)
        }
        return []
    }

    public var body: some View {
        ZStack(alignment: .bottom) {
            Color(uiColor: .systemGroupedBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top Green Header & Search Bar
                headerView

                // Scrollable Feed
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 20) {
                        if !searchQuery.isEmpty {
                            searchResultsSection
                        } else {
                            bannerCarouselSection
                            categoriesSection
                            brandsSection
                            bestsellersSection
                            trendingSection
                            newArrivalsSection
                            whoWeServeSection
                        }

                        // Bottom Spacer for Floating Cart and Tab Bar
                        Spacer().frame(height: 90)
                    }
                    .padding(.top, 12)
                }
            }

            // Floating Cart Pill
            FloatingCartBar(onOpenCart: {
                selectedTab = 3 // Jump to Cart Tab
            })
        }
    }

    // MARK: - Header
    private var headerView: some View {
        VStack(spacing: 10) {
            HStack(alignment: .center, spacing: 10) {
                // Lightning Bolt Icon
                Circle()
                    .fill(Color.white.opacity(0.18))
                    .frame(width: 36, height: 36)
                    .overlay(
                        Image(systemName: "bolt.fill")
                            .font(.system(size: 16))
                            .foregroundColor(.yellow)
                    )

                // Location & ETA
                VStack(alignment: .leading, spacing: 2) {
                    HStack(spacing: 4) {
                        Text("45 MINS DISPATCH")
                            .font(.system(size: 9, weight: .black))
                            .foregroundColor(Color(red: 0.75, green: 0.98, blue: 0.85))

                        Text("BORZO")
                            .font(.system(size: 8, weight: .black))
                            .padding(.horizontal, 4)
                            .padding(.vertical, 1)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(4)
                    }

                    HStack(spacing: 3) {
                        Text(cartManager.deliveryAddress)
                            .font(.system(size: 13, weight: .bold))
                            .foregroundColor(.white)
                            .lineLimit(1)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                }

                Spacer()

                // Account Avatar Button
                Button(action: {
                    selectedTab = 4 // Account Tab
                }) {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 36, height: 36)
                        .overlay(
                            Image(systemName: "person.fill")
                                .font(.system(size: 15))
                                .foregroundColor(.white)
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 6)

            // Search Bar
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                    .font(.system(size: 14))

                TextField("Search bagasse, paper tubs, wooden cutlery...", text: $searchQuery)
                    .font(.system(size: 13))
                    .autocorrectionDisabled()

                if !searchQuery.isEmpty {
                    Button(action: { searchQuery = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                } else {
                    Image(systemName: "mic.fill")
                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                        .font(.system(size: 13))
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(Color(uiColor: .systemBackground))
            .cornerRadius(14)
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
        .background(
            LinearGradient(
                colors: [Color(red: 0.07, green: 0.52, blue: 0.24), Color(red: 0.08, green: 0.64, blue: 0.29)],
                startPoint: .top,
                endPoint: .bottom
            )
        )
    }

    // MARK: - Banner Carousel
    private var bannerCarouselSection: some View {
        VStack(alignment: .leading, spacing: 6) {
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 0.05, green: 0.38, blue: 0.22), Color(red: 0.08, green: 0.55, blue: 0.35)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )

                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("GOA RESTAURANT PARTNERSHIP")
                            .font(.system(size: 8, weight: .black))
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.yellow)
                            .foregroundColor(.black)
                            .cornerRadius(4)

                        Text("Bulk Cartons Up to 25% Off")
                            .font(.system(size: 15, weight: .black))
                            .foregroundColor(.white)

                        Text("Instant Borzo courier dispatch from Mapusa warehouse to your kitchen.")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(Color(red: 0.85, green: 0.98, blue: 0.90))
                            .lineLimit(2)

                        Button(action: {
                            selectedTab = 2 // Restock Tab
                        }) {
                            Text("Setup Weekly Restock ➔")
                                .font(.system(size: 10, weight: .bold))
                                .foregroundColor(.white)
                                .padding(.horizontal, 10)
                                .padding(.vertical, 5)
                                .background(Color.white.opacity(0.2))
                                .cornerRadius(8)
                        }
                        .padding(.top, 4)
                    }

                    Spacer()

                    Text("🌱")
                        .font(.system(size: 48))
                        .opacity(0.8)
                }
                .padding(14)
            }
            .frame(height: 135)
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Shop by Category
    private var categoriesSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("SHOP BY CATEGORY")
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(.primary)

                Spacer()

                Button("View All (14)") {
                    selectedTab = 1 // Catalog Tab
                }
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(catalogService.categories) { cat in
                        Button(action: {
                            selectedTab = 1
                        }) {
                            VStack(spacing: 6) {
                                Circle()
                                    .fill(Color(uiColor: .systemBackground))
                                    .frame(width: 58, height: 58)
                                    .shadow(color: Color.black.opacity(0.04), radius: 4, y: 2)
                                    .overlay(
                                        Text(cat.emoji)
                                            .font(.system(size: 26))
                                    )

                                Text(cat.name)
                                    .font(.system(size: 10, weight: .bold))
                                    .foregroundColor(.primary)
                                    .lineLimit(1)
                            }
                            .frame(width: 68)
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Shop by Brand
    private var brandsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text("SHOP BY BRAND")
                    .font(.system(size: 12, weight: .black))
                    .foregroundColor(.primary)

                Spacer()

                Text("Verified Partners")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.secondary)
            }
            .padding(.horizontal, 16)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(catalogService.brands) { brand in
                        HStack(spacing: 10) {
                            Circle()
                                .fill(Color(red: 0.08, green: 0.64, blue: 0.29).opacity(0.15))
                                .frame(width: 38, height: 38)
                                .overlay(
                                    Text(String(brand.name.prefix(2)))
                                        .font(.system(size: 12, weight: .black))
                                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
                                )

                            VStack(alignment: .leading, spacing: 2) {
                                Text(brand.name)
                                    .font(.system(size: 12, weight: .black))
                                    .foregroundColor(.primary)

                                Text(brand.subtitle)
                                    .font(.system(size: 9, weight: .medium))
                                    .foregroundColor(.secondary)
                            }
                        }
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(uiColor: .systemBackground))
                        .cornerRadius(14)
                        .shadow(color: Color.black.opacity(0.03), radius: 4, y: 1)
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }

    // MARK: - Best Sellers Section
    private var bestsellersSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("★ BEST SELLERS")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))

                    Text("Top ordered by Goa restaurants this week")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }

                Spacer()

                Button("See All") {
                    selectedTab = 1
                }
                .font(.system(size: 11, weight: .bold))
                .foregroundColor(Color(red: 0.08, green: 0.64, blue: 0.29))
            }
            .padding(.horizontal, 16)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(catalogService.bestsellers) { product in
                    ProductCardView(product: product) {
                        activeProduct = product
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Trending Now Section
    private var trendingSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("🔥 TRENDING NOW")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.red)

                    Text("Surging demand in Anjuna & Calangute")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, 16)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(catalogService.trendingProducts) { product in
                    ProductCardView(product: product) {
                        activeProduct = product
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - New Arrivals Section
    private var newArrivalsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text("✨ NEW ARRIVALS")
                        .font(.system(size: 13, weight: .black))
                        .foregroundColor(.teal)

                    Text("Newly launched eco-packaging in warehouse")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundColor(.secondary)
                }

                Spacer()
            }
            .padding(.horizontal, 16)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                ForEach(catalogService.newArrivals) { product in
                    ProductCardView(product: product) {
                        activeProduct = product
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }

    // MARK: - Who We Serve
    private var whoWeServeSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("WHO WE SERVE ACROSS GOA")
                .font(.system(size: 11, weight: .black))
                .foregroundColor(.secondary)
                .padding(.horizontal, 16)

            LazyVGrid(columns: [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)], spacing: 8) {
                sectorCard(emoji: "🍕", title: "Restaurants & Cafes", subtitle: "Bulk carton restock")
                sectorCard(emoji: "🛵", title: "Cloud Kitchens", subtitle: "Tamper-proof trays")
                sectorCard(emoji: "🏖️", title: "Beach Shacks", subtitle: "Eco plates & cutlery")
                sectorCard(emoji: "🏨", title: "Luxury Resorts", subtitle: "Hygiene & tableware")
            }
            .padding(.horizontal, 16)
        }
    }

    private func sectorCard(emoji: String, title: String, subtitle: String) -> some View {
        HStack(spacing: 10) {
            Text(emoji)
                .font(.system(size: 20))

            VStack(alignment: .leading, spacing: 1) {
                Text(title)
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(.primary)

                Text(subtitle)
                    .font(.system(size: 9))
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(10)
        .background(Color(uiColor: .systemBackground))
        .cornerRadius(12)
    }

    // MARK: - Search Results
    private var searchResultsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("SEARCH RESULTS (\(displayedProducts.count))")
                .font(.system(size: 12, weight: .black))
                .padding(.horizontal, 16)

            if displayedProducts.isEmpty {
                VStack(spacing: 8) {
                    Text("🔍 No products found")
                        .font(.system(size: 14, weight: .bold))
                    Text("Try searching for 'bagasse', 'paper tub', or 'spoon'")
                        .font(.system(size: 11))
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 40)
            } else {
                LazyVGrid(columns: [GridItem(.flexible(), spacing: 10), GridItem(.flexible(), spacing: 10)], spacing: 10) {
                    ForEach(displayedProducts) { product in
                        ProductCardView(product: product) {
                            activeProduct = product
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

