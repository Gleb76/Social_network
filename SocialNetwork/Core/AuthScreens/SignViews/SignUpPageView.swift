import SwiftUI
import FirebaseAuth

struct SignUpPageView: View {
    @StateObject var viewModel: SignInEmailViewModel
    @State private var points: [SIMD2<Float>] = [
        SIMD2(0.0, 0.0), SIMD2(0.5, 0.0), SIMD2(1.0, 0.0),
        SIMD2(0.5, 1.0), SIMD2(0.7, 0.5), SIMD2(1.0, 0.7),
        SIMD2(0.0, 1.0), SIMD2(0.0, 0.5), SIMD2(0.5, 0.5)
    ]
    @State private var buttonScale: CGFloat = 1.0
    @State private var formOpacity: Double = 0

    var body: some View {
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
                    .transition(.opacity)
                }
            } else {
                LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                               startPoint: .top,
                               endPoint: .bottom)
                    .ignoresSafeArea()
            }

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 15) {
                    Text("Create Account")
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .opacity(formOpacity)

                    CustomTextField(icon: "envelope",
                                    title: "Email",
                                    hint: "Your email",
                                    value: $viewModel.email,
                                    showPassword: .constant(false))
                        .padding(.top, 15)
                        .opacity(formOpacity)

                    CustomTextField(icon: "lock",
                                    title: "Password",
                                    hint: "Your password",
                                    value: $viewModel.password,
                                    showPassword: .constant(false))
                        .padding(.top, 15)
                        .opacity(formOpacity)

                    Button {
                        Task {
                            await handleSignUp()
                        }
                    } label: {
                        Text("Sign Up")
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
                            .scaleEffect(buttonScale)
                            .onTapGesture {
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.3)) {
                                    buttonScale = 0.95
                                }
                                withAnimation(.spring(response: 0.3, dampingFraction: 0.6, blendDuration: 0.3).delay(0.1)) {
                                    buttonScale = 1.0
                                }
                            }
                    }
                    .padding(.top, 15)
                    .opacity(formOpacity)
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
            .onAppear {
                withAnimation(.easeIn(duration: 1.0)) {
                    formOpacity = 1.0
                }
            }
        }
    }

    private func handleSignUp() async {
        do {
            try await viewModel.signUp()
            print("SignUp successful!")
        } catch {
            print("Sign up failed: \(error.localizedDescription)")
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
    SignUpPageView(viewModel: SignInEmailViewModel())
}
