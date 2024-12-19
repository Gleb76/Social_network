import SwiftUI

struct SettingsView: View {
    @StateObject var viewModel: SettingsViewModel
    @StateObject var userData: UserViewModel
    @Binding var showSignInView: Bool
    var body: some View {
//        ProfileImageView(photoUrl: userData.photoUrl, newPhoto: userData.photoUrl)
        List {
            Button("Log out") {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            }
            
            Button(role: .destructive) {
                Task {
                    do {
                        try viewModel.logOut()
                        showSignInView = true
                    } catch {
                        print(error)
                    }
                }
            } label: {
                Text("Delete account")
            }
            Button("Reset password") {
                Task {
                    do {
                        try await viewModel.resetPassword()
                        print("Password reset")
                    } catch {
                        print(error)
                    }
                }
            }
            Button("Update password") {
                Task {
                    do {
                        try await viewModel.updatePassword()
                        print("Password Update")
                    } catch {
                        print(error)
                    }
                }
            }
            Button("Update email") {
                Task {
                    do {
                        try await viewModel.updateEmail()
                        print("Email Update")
                    } catch {
                        print(error)
                    }
                }
            }
            Button("Privacy and Terms") {
            }
        }
        .onAppear {
            viewModel.loadAuthProviders()
        }
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel(), userData: UserViewModel(), showSignInView: .constant(false))
}

struct ProfileImageView: View {
    let photoUrl: String
    @Binding var newPhoto: UIImage?
    
    var body: some View {
        Group {
            if let newPhoto = newPhoto {
                Image(uiImage: newPhoto)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.gray, lineWidth: 2))
            } else if let url = URL(string: photoUrl) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.gray, lineWidth: 2))
                } placeholder: {
                    ProgressView()
                        .frame(width: 100, height: 100)
                }
            } else {
                Circle()
                    .fill(Color.gray.opacity(0.5))
                    .frame(width: 100, height: 100)
                    .overlay(Text("Add Photo").font(.caption))
            }
        }
    }
}

// ImagePicker для выбора фото
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    var onComplete: (UIImage?) -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let selectedImage = info[.editedImage] as? UIImage ?? info[.originalImage] as? UIImage {
                parent.image = selectedImage
                parent.onComplete(selectedImage)
            }
            picker.dismiss(animated: true)
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.onComplete(nil)
            picker.dismiss(animated: true)
        }
    }
}
