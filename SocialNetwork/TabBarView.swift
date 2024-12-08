
import SwiftUI

struct TabBarView: View {
    @State private var activeTab: Tab = .home
    let activeTintColor: Color = .purple
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $activeTab) {
                Text("Home View")
                    .tag(Tab.home)
                Text("Chat View")
                    .tag(Tab.chat)
                Text("Partners View")
                    .tag(Tab.partners)
                Text("Settings View")
                    .tag(Tab.settings)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
            HStack {
                ForEach(Tab.allCases, id: \.self) { tab in
                    TabItem(
                        tint: activeTintColor,
                        inactiveTint: .gray,
                        tab: tab,
                        activeTab: $activeTab
                    )
                }
            }
            .background(.ultraThinMaterial)
        }
    }
}

#Preview {
    TabBarView()
}

/// Tab Bar Item
struct TabItem: View {
    var tint: Color
    var inactiveTint: Color
    var tab: Tab
    @Binding var activeTab: Tab
    
    var body: some View {
        VStack(spacing: 5) {
            Image(systemName: tab.systemImage)
                .font(.title2)
                .foregroundColor(activeTab == tab ? .white : inactiveTint)
                .frame(width: activeTab == tab ? 58 : 35, height: activeTab == tab ? 58 : 35)
                .background {
                    if activeTab == tab {
                        Circle()
                            .fill(tint.gradient)
                            .transition(.scale)
                    }
                }
                .animation(.easeInOut(duration: 0.3), value: activeTab)
            Text(tab.rawValue)
                .font(.caption)
                .foregroundColor(activeTab == tab ? tint : .gray)
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation {
                activeTab = tab
            }
        }
    }
}

enum Tab: String, CaseIterable {
    case home = "Home"
    case chat = "Chat"
    case partners = "Partners"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .home: return "house"
        case .chat: return "person.crop.circle"
        case .partners: return "person.crop.circle.badge.plus"
        case .settings: return "gearshape"
        }
    }
    
    var index: Int {
        return Tab.allCases.firstIndex(of: self) ?? 0
    }
}