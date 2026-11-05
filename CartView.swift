import SwiftUI

fileprivate extension NumberFormatter {
    static var currency: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = .current
        return f
    }()
}

struct CartView: View {
    @EnvironmentObject var cart: HomeCartManager
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack {
            if cart.items.isEmpty {
                Spacer()
                VStack(spacing: 16) {
                    Text("Your cart is empty")
                        .font(.title2)
                        .foregroundColor(.secondary)
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Continue Shopping")
                            .font(.headline)
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(8)
                    }
                }
                Spacer()
            } else {
                List {
                    ForEach(cart.items) { item in
                        HStack(alignment: .top, spacing: 12) {
                            Image(item.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 64, height: 64)
                                .cornerRadius(8)
                                .clipped()
                            VStack(alignment: .leading, spacing: 6) {
                                Text(item.titleLocalized)
                                    .font(.headline)
                                    .lineLimit(2)
                                Text(item.subtitle)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                                    .lineLimit(1)
                                Text(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                    .font(.subheadline)
                            }
                            Spacer()
                        }
                        .padding(.vertical, 8)
                    }
                }
                
                VStack(spacing: 16) {
                    let subtotal = cart.items.reduce(Decimal(0)) { $0 + $1.price }
                    HStack {
                        Text("Total:")
                            .font(.title2.bold())
                        Spacer()
                        Text(subtotal as NSDecimalNumber, formatter: NumberFormatter.currency)
                            .font(.title2.bold())
                    }
                    Button {
                        cart.isCheckoutActive = true
                    } label: {
                        Text("Proceed to Checkout")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(12)
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color(UIColor.systemGroupedBackground))
                .listRowInsets(EdgeInsets())
            }
        }
        .navigationTitle("Cart")
        .navigationBarTitleDisplayMode(.inline)
        .background(
            NavigationLink(
                destination: CheckoutView()
                    .environmentObject(cart),
                isActive: $cart.isCheckoutActive,
                label: { EmptyView() }
            )
            .hidden()
        )
    }
}

struct CartView_Previews: PreviewProvider {
    static var previews: some View {
        let cart = HomeCartManager()
        cart.items = Dish.sample
        return NavigationStack {
            CartView()
                .environmentObject(cart)
        }
    }
}
