import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""

    enum Route: Hashable { case home }
    @State private var path: [Route] = []

    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 0) {
                ScrollView(showsIndicators: false) {
                    VStack(spacing: 35) {
                        Spacer(minLength: 0)
                        LoginCard(email: $email, password: $password, onSignIn: { path.append(.home) })
                            .padding(.top, 135)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 27)
                    .frame(maxHeight: .infinity)
                }
            }
            .background(Color.bgVeryLight.edgesIgnoringSafeArea(.all))
            .navigationBarHidden(true)
            .navigationDestination(for: Route.self) { route in
                switch route {
                case .home:
                    HomeView()
                        .navigationBarBackButtonHidden(true)
                }
            }
        }
    }
}

// MARK: - Login Card

fileprivate struct LoginCard: View {
    @Binding var email: String
    @Binding var password: String
    var onSignIn: () -> Void = {}

    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to Haochi!")
                .font(.system(.title2, design: .serif))
                .fontWeight(.bold)
                .foregroundColor(Color.cardTitle)

            VStack(spacing: 16) {
                InputField(icon: "envelope", placeholder: "Email", text: $email, isSecure: false)
                InputField(icon: "lock", placeholder: "Password", text: $password, isSecure: true)
            }

            VStack(spacing: 16) {
                Button(action: onSignIn) {
                    Text("Sign In")
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, minHeight: 48)
                        .background(Color.warmBurgundy)
                        .foregroundColor(.white)
                        .clipShape(Capsule())
                        .shadow(color: Color.warmBurgundy.opacity(0.6), radius: 8, x: 0, y: 4)
                }

                Button(action: {}) {
                    HStack(spacing: 12) {
                        Image(systemName: "applelogo")
                            .font(.title3.weight(.medium))
                        Text("Sign in with Apple")
                            .fontWeight(.semibold)
                    }
                    .frame(maxWidth: .infinity, minHeight: 48)
                    .background(Color.black)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .shadow(color: Color.black.opacity(0.5), radius: 8, x: 0, y: 4)
                }
            }

            HStack(spacing: 24) {
                Link("Create account", destination: URL(string: "https://example.com/create-account")!)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(Color.linkTint)
                Spacer()
                Link("Forgot password?", destination: URL(string: "https://example.com/forgot-password")!)
                    .font(.footnote.weight(.semibold))
                    .foregroundColor(Color.linkTint)
            }
            .padding(.top, 4)
        }
        .padding(28)
        .background(Color.cardBackground)
        .cornerRadius(28)
        .shadow(color: Color.black.opacity(0.09), radius: 18, x: 0, y: 8)
    }
}

fileprivate struct InputField: View {
    var icon: String
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool = false

    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color.inputIcon)
                .frame(width: 24)
            Group {
                if isSecure {
                    SecureField(placeholder, text: $text)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                } else {
                    TextField(placeholder, text: $text)
                        .keyboardType(icon == "envelope" ? .emailAddress : .default)
                        .autocapitalization(.none)
                        .disableAutocorrection(true)
                }
            }
            .foregroundColor(Color.inputText)
            .font(.system(size: 16, weight: .medium))
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 14)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.inputBorder, lineWidth: 1.2)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.inputBackground)
                )
        )
    }
}

// MARK: - Footer Tab Bar

fileprivate struct FooterTabBar: View {
    @State private var selected = 0

    private let tabs: [(icon: String, title: String)] = [
        ("list.dash", "Menu"),
        ("bookmark", "Saved"),
        ("bag", "Orders"),
        ("person.crop.circle", "Me")
    ]

    var body: some View {
        HStack(spacing: 24) {
            ForEach(Array(tabs.enumerated()), id: \.offset) { index, tab in
                Button {
                    selected = index
                } label: {
                    VStack(spacing: 6) {
                        ZStack {
                            if selected == index {
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.warmBurgundy.opacity(0.15))
                                    .frame(width: 44, height: 44)
                            }
                            Image(systemName: tab.icon)
                                .font(.system(size: 22, weight: .semibold))
                                .foregroundColor(selected == index ? Color.warmBurgundy : Color.tabBarIcon)
                        }
                        Text(tab.title)
                            .font(.footnote.weight(.semibold))
                            .foregroundColor(selected == index ? Color.warmBurgundy : Color.tabBarIcon)
                    }
                    .frame(minWidth: 50)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
}

// MARK: - Colors

fileprivate extension Color {
    static let warmBurgundy = Color(red: 122 / 255, green: 46 / 255, blue: 46 / 255)
    static let warmOverlay = Color(red: 163 / 255, green: 79 / 255, blue: 64 / 255)
    static let chipBackground = Color(red: 242 / 255, green: 226 / 255, blue: 223 / 255)
    static let accentText = Color(red: 112 / 255, green: 61 / 255, blue: 59 / 255)
    static let cardBackground = Color.white
    static let cardTitle = Color(red: 74 / 255, green: 40 / 255, blue: 38 / 255)
    static let inputBackground = Color(red: 250 / 255, green: 246 / 255, blue: 244 / 255)
    static let inputBorder = Color(red: 225 / 255, green: 214 / 255, blue: 210 / 255)
    static let inputIcon = Color(red: 145 / 255, green: 114 / 255, blue: 110 / 255)
    static let inputText = Color(red: 74 / 255, green: 40 / 255, blue: 38 / 255)
    static let accentPrice = Color(red: 125 / 255, green: 42 / 255, blue: 42 / 255)
    static let linkTint = Color(red: 122 / 255, green: 46 / 255, blue: 46 / 255).opacity(0.85)
    static let tabBarIcon = Color(red: 133 / 255, green: 100 / 255, blue: 94 / 255)
    static let bgLight = Color(red: 254 / 255, green: 249 / 255, blue: 247 / 255)
    static let bgVeryLight = Color(red: 255 / 255, green: 253 / 255, blue: 252 / 255)
}

// MARK: - Preview

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            LoginView()
                .previewDisplayName("Login View")
                .preferredColorScheme(.light)
                .environment(\.colorScheme, .light)
        }
    }
}
