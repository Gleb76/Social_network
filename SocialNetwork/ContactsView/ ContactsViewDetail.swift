
import SwiftUI

struct ContactsViewDetail: View {
    
    @Environment(\.presentationMode) var presentationMode
    
    let contact: Contact
    var body: some View {
        VStack {
            if let profileImage = contact.profileImage {
                ZStack{
                    Image(profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 200, height: 200)
                        .offset(CGSize(width: 0, height: -140))
                }
            }
            VStack{
                Text(contact.name)
                    .font(.system(size: 24))
                    .fontWeight(.bold)
                    .offset(CGSize(width: 0, height: -100))
                Text("+7-999-99-99-909")
                    .font(.system(size: 20))
                    .frame(width: 300)
                    .foregroundColor(.wbDisable)
                    .offset(CGSize(width: 0, height: -90))

            }
            HStack {
                Image(.twitter)
                    .resizable()
                    .frame(width: 72, height: 40)
                Image(.instagram)
                    .resizable()
                    .frame(width: 72, height: 40)
                Image(.linkedIn)
                    .resizable()
                    .frame(width: 72, height: 40)
                Image(.facebookWB)
                    .resizable()
                    .frame(width: 72, height: 40)
            }
            .offset(CGSize(width: 0, height: -50))
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(.backBarItem)
                        .resizable()
                        .frame(width: 24, height: 24)
                    Text("Профиль")
                        .foregroundColor(.wbDarkTextBG)
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                    
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Image(.edit)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.wbDarkTextBG)
                }
                .padding()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    ContactsViewDetail(contact: Contact(name: "Анастасия Иванова", lastSeen: "Last seen yesterday", profileImage: "anastasia", stories: true, isOnline: true))
}
