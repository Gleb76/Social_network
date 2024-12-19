
import SwiftUI

struct ContactsView: View {
    @State private var searchText = ""
    @State private var selectedContact: Contact? = nil
    @State private var isDetailViewActive = false

    var contacts: [Contact]

    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Text("Контакты")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding([.top, .leading])

                    Spacer()

                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding([.top, .trailing])
                }
                .padding(.horizontal)

                SearchBar(searchText: $searchText)
                    .cornerRadius(15)
                    .padding(.top, 10)

                List {
                    ForEach(contacts.filter { contact in
                        searchText.isEmpty ? true : contact.name.lowercased().contains(searchText.lowercased())
                    }, id: \.id) { contact in
                        ContactsScreenView(contact: contact)
                            .contentShape(Rectangle())
                            .onTapGesture {
                                selectedContact = contact
                                isDetailViewActive = true
                            }
                    }
                }
                .listStyle(PlainListStyle())
                .navigationTitle("")
                .navigationBarHidden(true)
            }
            .background(
                NavigationLink(
                    destination: ContactsViewDetail(contact: selectedContact ?? contacts[0]),
                    isActive: $isDetailViewActive,
                    label: { EmptyView() }
                )
            )
        }
    }
}

#Preview {
    ContactsView(contacts: contacts)
}

