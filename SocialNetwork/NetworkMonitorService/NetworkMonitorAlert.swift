//
//  NetworkMonitorAlert.swift
//  SocialNetwork
//
//  Created by Глеб Клыга on 27.10.24.
//

import SwiftUI

struct NetworkMonitorAlert: View {
    var body: some View {
        VStack {
            Text("Hello world!")
        }
        .offlineAlert()
    }
}

struct OfflineAlertView: ViewModifier {
    @EnvironmentObject var monitor: NetworkMonitor
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if !monitor.hasNetworkConnection{
                ZStack {
                    HStack{
                        Image(systemName: "network.slash")
                            .foregroundStyle(.white.opacity(0.8))
                        Text("No connection")
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    .padding()
                    .background(.black.opacity(0.8))
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                .padding()
                .transition(.move(edge: .leading))
            }
        }
    }
}

extension View {
    func offlineAlert() -> some View {
        self.modifier(OfflineAlertView())
    }
}
