
import SwiftUI

struct ForgetPageView: View {
    @State private var email: String = ""
    @State private var showConfirmationMessage = false

    var body: some View {
        VStack {
            // Заголовок страницы
            VStack {
                Text("Forgot Password")
                    .font(.system(size: 45, weight: .bold))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.leading)
                    .padding()
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing)
                            .ignoresSafeArea()
                    )
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            }
            .frame(height: getRect().height / 3.5)
    

            // Основное содержимое
            VStack(spacing: 20) {
                Text("Enter your email to receive a reset link")
                    .font(.title3)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)

                // Поле для ввода email
                CustomTextField(icon: "envelope", title: "Email", hint: "you@example.com", value: $email, showPassword: .constant(false))
                    .padding(.horizontal)

                // Кнопка отправки
                Button(action: {
                    // Здесь можно добавить логику для отправки запроса восстановления пароля
                    withAnimation {
                        showConfirmationMessage = true
                    }
                }) {
                    Text("Send Reset Link")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .cornerRadius(15)
                        .shadow(radius: 5)
                }
                .padding(.top, 20)
            
                // Подтверждающее сообщение
                if showConfirmationMessage {
                    Text("A reset link has been sent to your email.")
                        .font(.body)
                        .foregroundColor(.green)
                        .transition(.opacity)
                }
            }
            .padding()
            .background(Color.white.clipShape(CustomCorners(corners: [.topLeft, .topRight], radius: 25)))
            .padding(.top, -20)
            .ignoresSafeArea(edges: .bottom)
        }
        .background(
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]),
                           startPoint: .top,
                           endPoint: .bottom)
                .ignoresSafeArea()
        )
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
            
            TextField(hint, text: value)
                .padding(.top, 5)
            
            Divider()
                .background(Color.gray.opacity(0.5))
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(10)
    }
}

#Preview {
    ForgetPageView()
}
