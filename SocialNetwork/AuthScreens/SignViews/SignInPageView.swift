import SwiftUI
import FirebaseAuth
import GoogleSignIn
import GoogleSignInSwift

@MainActor
final class AuthenticationViewModel: ObservableObject {
    func signIn() async throws {
//        guard let topVC = Utilities.shared.topViewController else {
//            throw URLError(.cannotFindHost)
//        }
//        let gidSignInResult = GIDSignIn.sharedInstance.signIn(withPresenting: topVC)
//        guard let user = gidSignInResult?.user.idToken?.tokenString else {
//            throw URLError(.badServerResponse)
//        }
//        let accessToken: String = gidSignInResult.user.accessToken.tokenString
//        let credential = GoogleAuthProvider.credential(withIDToken: idToken, accessToken: accessToken)
    }
}


struct SignInPageView: View {
    
    @StateObject private var googleViewModel = AuthenticationViewModel()
    @StateObject var viewModel: SignInEmailViewModel
    @State private var points: [SIMD2<Float>] = [
        SIMD2(0.0, 0.0), SIMD2(0.5, 0.0), SIMD2(1.0, 0.0),
        SIMD2(0.5, 1.0), SIMD2(0.7, 0.5), SIMD2(1.0, 0.7),
        SIMD2(0.0, 1.0), SIMD2(0.0, 0.5), SIMD2(0.5, 0.5)
    ]
    
    var body: some View {
        NavigationView {
            VStack {
                if #available(iOS 18.0, *) {
                    ZStack {
                        MeshGradient(
                            width: 3,
                            height: 3,
                            points: points,
                            colors: [
                                .teal, .purple, .indigo,
                                .purple, .blue, .pink,
                                .purple, .red, .purple
                            ]
                        )
                        .ignoresSafeArea()
                        .shadow(color: .gray, radius: 25, x: -10, y: 10)
                        .onAppear {
                            startAnimatingPoints()
                        }
                    }
                } else {
                    LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                   startPoint: .top,
                                   endPoint: .bottom)
                        .ignoresSafeArea()
                }
                
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 15) {
                        Text("Welcome Back!")
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        
                        CustomTextField(icon: "envelope",
                                        title: "Email",
                                        hint: "Your email",
                                        value: $viewModel.email,
                                        showPassword: .constant(false))
                            .padding(.top, 15)
                        
                        CustomTextField(icon: "lock",
                                        title: "Password",
                                        hint: "Your password",
                                        value: $viewModel.password,
                                        showPassword: .constant(false))
                            .padding(.top, 15)
                        
                        Button {
                            Task {
                                await handleSignIn()
                            }
                        } label: {
                            Text("Sign In")
                                .font(.system(size: 20, weight: .bold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(LinearGradient(
                                    gradient: Gradient(colors: [.blue, .purple]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                ))
                                .cornerRadius(15)
                                .shadow(radius: 5)
                        }
                        .padding(.top, 15)
                        NavigationLink(destination: SignUpPageView(viewModel: viewModel)) {
                            Text("Don't have an account? Sign Up")
                                .font(.caption)
                                .foregroundColor(.purple)
                        }
                        .padding(.top, 10)
                        VStack {
                            Text("Or sign in with:")
                                .font(.caption)
                                .foregroundColor(.gray)
                            HStack {
                                GoogleSignInButton(viewModel: GoogleSignInButtonViewModel(scheme: .dark, style: .icon, state: .normal)) {
                                    
                                }
                            }
                        }
                    }
                    .padding(20)
                    .frame(maxHeight: .infinity)
                }
                .background(
                    Color.white
                        .clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25))
                )
                .padding(.top, -140)
                .ignoresSafeArea()
            }
        }
    }
    
    private func handleSignIn() async {
        do {
            try await viewModel.signIn()
            print("SignIn successful!")
        } catch {
            print("Sign in failed: \(error.localizedDescription)")
        }
    }
    
    func startAnimatingPoints() {
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { _ in
            withAnimation(.easeInOut(duration: 1.5)) {
                points = points.map { point in
                    SIMD2(
                        Float.random(in: point.x - 0.05...point.x + 0.05),
                        Float.random(in: point.y - 0.05...point.y + 0.05)
                    )
                }
            }
        }
    }

    
    @ViewBuilder
    func CustomTextField(icon: String, title: String, hint: String, value: Binding<String>, showPassword: Binding<Bool>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Label {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.gray)
            } icon: {
                Image(systemName: icon)
            }
            
            if title.contains("Password") && !showPassword.wrappedValue {
                SecureField(hint, text: value)
                    .padding(.top, 5)
            } else {
                TextField(hint, text: value)
                    .padding(.top, 5)
            }
            
            Divider()
                .background(Color.gray.opacity(0.5))
            
            if title.contains("Password") {
                HStack {
                    Spacer()
                    Button(action: {
                        showPassword.wrappedValue.toggle()
                    }) {
                        Text(showPassword.wrappedValue ? "Hide" : "Show")
                            .font(.caption)
                            .foregroundColor(.purple)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    SignInPageView(viewModel: SignInEmailViewModel())
}
