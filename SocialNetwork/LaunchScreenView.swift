//
//  LaunchScreenView.swift
//  SocialNetwork
//
//  Created by Глеб Клыга on 26.10.24.
//

import SwiftUI
 
struct LaunchScreenView: View {
 
    @State var progress: CGFloat = 0
    @State var doneLoading: Bool = false
     
    var body: some View {
        ZStack {
            if doneLoading {
                OnboardingView()
                    .transition(AnyTransition.opacity.animation(.easeInOut(duration: 1.0)))
            } else {
                LoadingView(content: Image(systemName: "star.fill")
                                        .resizable()
                                        .scaledToFit()
                                        .padding(.horizontal, 50),
                            progress: $progress)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            withAnimation {
                                self.progress = 0
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
                                withAnimation {
                                    self.doneLoading = true
                                }
                                 
                            }
                        }
                    }
            }
        }
    }
}
 
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        LaunchScreenView()
    }
}
 
 
struct ScaledMaskModifier<Mask: View>: ViewModifier {
     
    var mask: Mask
    var progress: CGFloat
     
    func body(content: Content) -> some View {
        content
            .mask(GeometryReader(content: { geometry in
                self.mask.frame(width: self.calculateSize(geometry: geometry) * self.progress,
                                height: self.calculateSize(geometry: geometry) * self.progress,
                                alignment: .center)
            }))
    }
     
    func calculateSize(geometry: GeometryProxy) -> CGFloat {
        if geometry.size.width > geometry.size.height {
            return geometry.size.width
        }
        return geometry.size.height
    }
 
}
 
struct LoadingView<Content: View>: View {
 
    var content: Content
    @Binding var progress: CGFloat
    @State var logoOffset: CGFloat = 0
     
    var body: some View {
        content
            .modifier(ScaledMaskModifier(mask: Circle(), progress: progress))
            .offset(x: 0, y: logoOffset)
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 1)) {
                    self.progress = 1.0
                }
                withAnimation(Animation.easeInOut(duration: 0.4).repeatForever(autoreverses: true)) {
                    self.logoOffset = 10
                }
            }
    }
}
