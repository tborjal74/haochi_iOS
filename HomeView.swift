import SwiftUI

extension Color {
    static let appMaroon = Color(red: 0.5, green: 0.0, blue: 0.0)
}

struct HomeView: View {
    @State private var selectedCategory: Category = .steamed
    @State private var searchText: String = ""
    @State private var favourites: [Dish] = Dish.sample

    var body: some View {
        NavigationStack {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    header
                    hero
                    categoryChips
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                    favouritesHeader
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                    favouritesList
                        .padding(.horizontal, 16)
                        .padding(.bottom, 24)
                }
            }
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    HStack(spacing: 8) {
                        Image(systemName: "seal.fill")
                            .symbolRenderingMode(.palette)
                            .foregroundStyle(Color.appMaroon.opacity(0.95), Color.appMaroon.opacity(0.25))
                        VStack(alignment: .leading, spacing: 2) {
                            Text("DELIVER TO")
                                .font(.caption2)
                                .foregroundStyle(.secondary)
                                .textCase(.uppercase)
                            HStack(spacing: 4) {
                                Text("8 Lantern Lane")
                                    .font(.callout.weight(.semibold))
                                Image(systemName: "chevron.down")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    HStack(spacing: 12) {
                        Button {
                            // search action
                        } label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundStyle(Color.appMaroon)
                        }
                        Button {
                            // cart action
                        } label: {
                            Image(systemName: "cart")
                                .foregroundStyle(Color.appMaroon)
                        }
                    }
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .safeAreaPadding(.bottom, 8)
        }
    }

    // MARK: Header hero
    private var header: some View {
        EmptyView() // Navigation bar acts as header per design
    }

    private var hero: some View {
        ZStack(alignment: .bottomLeading) {
            Image("dimsum")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: 260)
                .clipped()
                .overlay {
                    LinearGradient(colors: [Color.black.opacity(0.0), Color.black.opacity(0.35)], startPoint: .center, endPoint: .bottom)
                }
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 8) {
                    Chip(text: "STEAMED", style: .filled)
                    Chip(text: "MOM'S", style: .outline)
                }
                .padding(.bottom, 4)
                Text("Good fortune,\none bite at a\ntime.")
                    .font(.system(size: 34, weight: .semibold, design: .serif))
                    .foregroundStyle(.white)
                    .lineSpacing(2)
                HStack(spacing: 12) {
                    CategoryBadge(icon: "seal", text: "點心")
                }
                .padding(.top, 6)
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 16)
        }
        .background(.ultraThinMaterial)
    }

    // MARK: Category chips
    private var categoryChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Category.allCases, id: \.self) { category in
                    Button {
                        selectedCategory = category
                    } label: {
                        Chip(text: category.title, style: selectedCategory == category ? .filled : .soft)
                    }
                }
            }
            .padding(.vertical, 6)
        }
    }

    // MARK: Favourites header
    private var favouritesHeader: some View {
        HStack(alignment: .firstTextBaseline) {
            VStack(alignment: .leading, spacing: 6) {
                Text("精 選")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                Text("Today’s favourites")
                    .font(.title2.weight(.semibold))
            }
            Spacer()
            Button("View all") {}
                .font(.callout.weight(.semibold))
                .foregroundStyle(Color.appMaroon)
        }
    }

    // MARK: Favourites list
    private var favouritesList: some View {
        LazyVStack(spacing: 14, pinnedViews: []) {
            ForEach(favourites) { dish in
                DishCard(dish: dish)
            }
        }
    }
}

// MARK: - Components

private struct Chip: View {
    enum Style { case filled, outline, soft }
    var text: String
    var style: Style = .soft

    var body: some View {
        Text(text)
            .font(.footnote.weight(.semibold))
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(background)
            .foregroundStyle(foreground)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .strokeBorder(borderColor, lineWidth: style == .outline ? 1 : 0)
            )
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var background: some ShapeStyle {
        switch style {
        case .filled: Color.appMaroon
        case .outline: Color.clear
        case .soft: Color.appMaroon.opacity(0.08)
        }
    }

    private var foreground: Color {
        switch style {
        case .filled: .white
        case .outline: .appMaroon
        case .soft: .appMaroon
        }
    }

    private var borderColor: Color {
        switch style {
        case .outline: .appMaroon.opacity(0.6)
        default: .clear
        }
    }
}

private struct CategoryBadge: View {
    var icon: String
    var text: String

    var body: some View {
        HStack(spacing: 6) {
            Image(systemName: icon)
            Text(text)
                .font(.callout.weight(.semibold))
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 6)
        .background(Color.appMaroon.opacity(0.12), in: Capsule())
        .foregroundStyle(Color.appMaroon)
    }
}

private struct DishCard: View {
    var dish: Dish

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack(alignment: .topLeading) {
                Image(dish.imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 86, height: 86)
                    .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
                    .overlay(
                        RoundedRectangle(cornerRadius: 14, style: .continuous)
                            .strokeBorder(Color.appMaroon.opacity(0.12))
                    )
                if let tag = dish.tag {
                    Text(tag)
                        .font(.caption2.weight(.bold))
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial, in: Capsule())
                        .padding(6)
                }
            }
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 6) {
                    Text(dish.titleLocalized)
                        .font(.subheadline)
                    Spacer()
                    Text(dish.price, format: .currency(code: "USD"))
                        .font(.subheadline.weight(.semibold))
                }
                Text(dish.subtitle)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Spacer(minLength: 0)
                HStack {
                    Spacer()
                    Button {
                        // add to cart
                    } label: {
                        Image(systemName: "plus")
                            .font(.headline.weight(.bold))
                            .foregroundStyle(.white)
                            .frame(width: 32, height: 32)
                            .background(Color.appMaroon, in: Circle())
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.04), radius: 10, x: 0, y: 6)
        )
    }
}

// MARK: - Models

private enum Category: String, CaseIterable, Hashable {
    case steamed, crispy, buns, veggie

    var title: String {
        switch self {
        case .steamed: return "Steamed"
        case .crispy: return "Crispy"
        case .buns: return "Buns"
        case .veggie: return "Veg"
        }
    }
}

private struct Dish: Identifiable, Hashable {
    var id = UUID()
    var titleLocalized: String
    var subtitle: String
    var price: Decimal
    var imageName: String
    var tag: String?

    static let sample: [Dish] = [
        Dish(titleLocalized: "Har Gao", subtitle: "Crystal prawn dumplings", price: 8.50, imageName: "har-gao", tag: "MOST LOVED"),
        Dish(titleLocalized: "Xiao Long Bao", subtitle: "Soup dumplings", price: 9.00, imageName: "xiao-long-bao", tag: "CHEF'S PICK"),
        Dish(titleLocalized: "Char Siu Bao", subtitle: "BBQ pork buns", price: 7.50, imageName: "char-siu-bao", tag: nil)
    ]
}

// MARK: - Preview
#Preview("HomeView") {
    NavigationStack {
        HomeView()
    }
}
