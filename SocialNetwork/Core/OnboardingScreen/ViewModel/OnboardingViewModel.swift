//
//  OnboardingViewModel.swift
//  SocialNetwork
//
//  Created by Глеб Клыга on 26.10.24.
//

import SwiftUI

class OnboardingViewModel : ObservableObject{
    @Published var onboardingPages: [OnboardingPageModel] = [
        OnboardingPageModel(imageName: "onboarding1",
                            title: "Welcome to Our Social Network!",
                            description: "Connect with friends, share moments, and explore what’s happening around the world."),
        OnboardingPageModel(imageName: "onboarding2",
                            title: "Stay Connected Anytime, Anywhere",
                            description: "Keep in touch with your friends and family, no matter where they are."),
        OnboardingPageModel(imageName: "onboarding3",
                            title: "Discover and Share",
                            description: "Find interesting content, follow your favorite creators, and share your thoughts with the world."),
    ]
    
    @Published var pageColors : [Color] = [.background.opacity(0.33), .background.opacity(0.66), .background]
    @Published var currentPageIndex : Int = 0
  
    func goToNextPage(){
        if currentPageIndex < onboardingPages.count - 1{
            withAnimation{
                currentPageIndex += 1
            }
        }
    }
 
    func goToPreviousPage(){
        if currentPageIndex > 0 {
            withAnimation{
                currentPageIndex -= 1
            }
        }
    }
    
    func skipOnboarding(){
        withAnimation{
            currentPageIndex = onboardingPages.count - 1
        }
    }
}

