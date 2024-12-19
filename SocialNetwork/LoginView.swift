// LoginView.swift
// SocialNetwork

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel = LoginViewModel()
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            GeometryReader { proxy in
                Path { path in
                    path.move(to: CGPoint(x: 0, y: 0))
                    path.addLine(to: CGPoint(x: proxy.size.width * 0.65, y: 0))
                    path.addLine(to: CGPoint(x: proxy.size.width * 0.35, y: proxy.size.height))
                    path.addLine(to: CGPoint(x: 0, y: proxy.size.height))
                    path.closeSubpath()
                }
                .fill(viewModel.pageColors[0])
            }
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                // Заголовок
                Text("Welcome Back")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 50)
                    .multilineTextAlignment(.center)
                
                // Поля ввода
                VStack(spacing: 20) {
                    CustomTextField(placeholder: "Email", text: $viewModel.email)
                    PasswordTF(title: "Password", text: $viewModel.password)
                }
                .padding(.horizontal, 50)
                
                // Кнопка входа
                LoginButton(action: viewModel.loginAction)
                
                Spacer()
                
                // Кнопка перехода к регистрации
                Button(action: viewModel.navigateToSignUp) {
                    Text("Don't have an account? Sign Up")
                        .font(.system(size: 14))
                        .foregroundStyle(.gray)
                }
                .padding(.bottom, 30)
            }
        }
    }
}

// CustomTextField - поле ввода Email
struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    
    var body: some View {
        TextField(placeholder, text: $text)
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(10)
            .foregroundStyle(.white)
            .padding(.horizontal, 5)
    }
}

// LoginButton - кнопка входа с градиентом
struct LoginButton: View {
    var action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Rectangle()
                .fill(Color.clear)
                .frame(height: 50)
                .commonLinearGradient(colors: [.greenishGray, .oliveGreen]) // Используем градиент
                .cornerRadius(10)
                .shadow(color: .shadowColor, radius: 7.5, y: 5)
                .overlay(
                    Text("LOGIN")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .bold))
                        .kerning(1.2)
                )
        }
        .padding(.horizontal, 50)
    }
}

// LoginViewModel для работы с данными
class LoginViewModel: ObservableObject {
    @Published var email: String = ""
    @Published var password: String = ""
    
    // Цветовая гамма, как в OnboardingView
    var pageColors: [Color] = [.greenishGray, .oliveGreen]
    
    func loginAction() {
        // Логика входа
    }
    
    func navigateToSignUp() {
        // Навигация к регистрации
    }
}

#Preview {
    LoginView()
}


struct PasswordTF: View {
    var title: String
    @Binding var text: String
    @FocusState private var isActive: Bool
    @State private var showPassword: Bool = false
    
    var body: some View {
        ZStack(alignment: .leading) {
            if showPassword {
                TextField(title, text: $text)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .focused($isActive)
                    .background(Color.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 16))
                    .animation(.easeInOut, value: text)
            } else {
                SecureField(title, text: $text)
                    .padding(.leading)
                    .frame(maxWidth: .infinity)
                    .frame(height: 55)
                    .focused($isActive)
                    .background(Color.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 16))
                    .animation(.easeInOut, value: text)
            }

            if text.isEmpty {
                Text(title)
                    .padding(.leading)
                    .foregroundColor(.secondary)
                    .offset(y: isActive ? -20 : 0)
                    .scaleEffect(isActive ? 0.85 : 1.0, anchor: .leading)
                    .animation(.spring(response: 0.5), value: isActive)
            }
        }
        .overlay(alignment: .trailing) {
            Image(systemName: showPassword ? "eye.fill" : "eye.slash.fill")
                .foregroundStyle(showPassword ? .primary : .secondary)
                .padding(16)
                .onTapGesture {
                    withAnimation { showPassword.toggle() }
                }
        }
    }
}
