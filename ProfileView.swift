import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var cart: HomeCartManager
    
    @AppStorage("profile_name") private var name: String = ""
    @AppStorage("profile_email") private var email: String = ""
    @AppStorage("profile_address") private var address: String = ""
    @AppStorage("profile_notifications") private var notificationsEnabled: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    TextField("Name", text: $name)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Delivery")) {
                    TextField("Address", text: $address)
                        .autocapitalization(.words)
                        .disableAutocorrection(true)
                }
                
                Section(header: Text("Settings")) {
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    NavigationLink("Cart", destination: CartView())
                    NavigationLink("Checkout", destination: CheckoutView())
                }
                
                Section(header: Text("Account")) {
                    Button("Log Out", role: .destructive) {
                        name = ""
                        email = ""
                        address = ""
                        notificationsEnabled = false
                        cart.clear()
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(HomeCartManager())
}
