import SwiftUI

struct CheckoutView: View {
    @EnvironmentObject var cart: HomeCartManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var showConfirmation = false
    
    var body: some View {
        NavigationStack {
            Group {
                if cart.items.isEmpty {
                    VStack(spacing: 20) {
                        Text("Your cart is empty.")
                            .font(.title2)
                            .foregroundColor(.secondary)
                        Button("Go Back") {
                            dismiss()
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    List {
                        Section("Order Summary") {
                            ForEach(cart.items) { item in
                                HStack {
                                    Text(item.titleLocalized)
                                    Spacer()
                                    Text(item.price, format: .currency(code: Locale.current.currency?.identifier ?? "USD"))
                                }
                            }
                        }
                    }
                    .listStyle(.insetGrouped)
                    VStack {
                        HStack {
                            Text("Total")
                                .font(.title2.bold())
                            Spacer()
                            let total = cart.items.reduce(Decimal(0)) { $0 + $1.price }
                            Text(total as NSDecimalNumber, formatter: NumberFormatter.currency)
                                .font(.title2.bold())
                        }
                        .padding(.vertical, 8)
                        Button("Place Order") {
                            cart.items.removeAll()
                            showConfirmation = true
                        }
                        .buttonStyle(.borderedProminent)
                        .padding(.horizontal)
                        .padding(.bottom)
                    }
                }
            }
            .navigationTitle("Checkout")
            .alert("Order Placed", isPresented: $showConfirmation) {
                Button("OK") {
                    dismiss()
                }
            } message: {
                Text("Thank you for your purchase!")
            }
        }
    }
}

struct CheckoutView_Previews: PreviewProvider {
    static var previews: some View {
        let cart = HomeCartManager()
        cart.items = Dish.sample
        return CheckoutView()
            .environmentObject(cart)
    }
}

fileprivate extension NumberFormatter {
    static var currency: NumberFormatter = {
        let f = NumberFormatter()
        f.numberStyle = .currency
        f.locale = .current
        return f
    }()
}
