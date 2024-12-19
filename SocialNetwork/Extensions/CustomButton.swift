//
//  CustomButton.swift
//  SocialNetwork
//
//  Created by Глеб Клыга on 10.11.24.
//

import SwiftUI

struct CustomButton<ButtonContent: View>: View {
    var content: () -> ButtonContent
    /// Button Action
    var action: () async -> TaskStatus
    /// View Properties
    @State private var isLoading: Bool = false
    @State private var taskStatus: TaskStatus = .idle
    @State private var isFailed: Bool = false
    @State private var wiggle: Bool = false
    /// Popup Properties
    @State private var showPopup: Bool = false
    @State private var popupMessage: String = ""
    
    var body: some View {
        Button(action: {
            Task {
                isLoading = true
                let taskStatus = await action()
                isLoading = false
                self.taskStatus = taskStatus
                switch taskStatus {
                case .idle:
                    isFailed = false
                case .failed(let string):
                    isFailed = true
                    popupMessage = string
                case .success:
                    isFailed = false
                }
                self.taskStatus = taskStatus
                if isFailed {
                    try? await Task.sleep(nanoseconds: 500_000_000)
                }
                isLoading = false
            }
        }, label:  {
            content()
                .padding(.horizontal, 30)
                .padding(.vertical, 12)
                .opacity(isLoading ? 0 : 1)
                .frame(width: isLoading ? 50 : nil, height: isLoading ? 50 : nil)
                .background(Color(taskStatus == .idle ? .white : taskStatus == .success ? .green : .red).shadow(.drop(color: .black.opacity(0.15), radius: 6)), in: .capsule)
                .overlay {
                    if isLoading && taskStatus == .idle {
                        ProgressView()
                    }
                }
                .overlay {
                    if taskStatus != .idle {
                        Image(systemName: isFailed ? "exclamationmark" : "checkmark")
                            .font(.title2.bold())
                            .foregroundStyle(.white)
                    }
                }
                .wiggle(wiggle)
        })
        .disabled(isLoading)
        .popover(isPresented: $showPopup, content: {
            Text(popupMessage)
                .font(.caption)
                .foregroundStyle(.gray)
                .padding(.horizontal, 10)
                .presentationCompactAdaptation(.popover)
        })
        .animation(.snappy, value: isLoading)
    }
}

/// Wiggle Extension

extension View {
    @ViewBuilder
    func wiggle(_ animate: Bool) -> some View {
        self
            .keyframeAnimator(initialValue: CGFloat.zero, trigger: animate) { view,
                value in
                view
                    .offset(x: value)
            } keyframes: { _ in
                KeyframeTrack {
                    CubicKeyframe(0, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(5, duration: 0.1)
                    CubicKeyframe(-5, duration: 0.1)
                    CubicKeyframe(0, duration: 0.1)
                }
            }
        
    }
}

enum TaskStatus: Equatable {
    case idle
    case failed(String)
    case success
    
    static func ==(lhs: TaskStatus, rhs: TaskStatus) -> Bool {
        switch (lhs, rhs) {
        case (.idle, .idle), (.success, .success):
            return true
        case (.failed(let lhsMessage), .failed(let rhsMessage)):
            return lhsMessage == rhsMessage
        default:
            return false
        }
    }
}

//#Preview {
//    CustomButton(content: {
//        Text("Submit")
//    }, action: {
//        await Task.sleep(nanoseconds: 1_000_000_000)
//        return .success
//    })
//}
