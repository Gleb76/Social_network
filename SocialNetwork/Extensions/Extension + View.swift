//
//  Extension + View.swift
//  SocialNetwork
//
//  Created by Глеб Клыга on 26.10.24.
//

import SwiftUI

extension View {
    /// Apply corner radius to specific corners of a view.
    ///
    /// - Parameters:
    ///   - radius: The corner radius to apply.
    ///   - corners: The corners to round.
    ///
    /// - Returns: A modified view with corner radius applied to specified corners.
    func cornerRadius(radius: CGFloat, corners: UIRectCorner) -> some View {
        ModifiedContent(content: self, modifier: CornerRadiusStyle(radius: radius, corners: corners))
    }
    
    /// Apply a linear gradient background to a view.
    ///
    /// - Parameters:
    ///   - colors: An array of `Color` objects representing the gradient colors.
    ///   - startPoint: The starting point of the gradient. Defaults to `.top`.
    ///   - endPoint: The ending point of the gradient. Defaults to `.bottom`.
    ///
    /// - Returns: A modified view with a linear gradient background.
    func commonLinearGradient(colors: [Color], startPoint: UnitPoint = .top, endPoint: UnitPoint = .bottom) -> some View {
        self.background(
            LinearGradient(
                gradient: Gradient(colors: colors),
                startPoint: startPoint,
                endPoint: endPoint
            )
        )
    }
    func getRect() -> CGRect {
        return UIScreen.main.bounds
    }
}

//MARK: - CornerRadiusShape and CornerRadiusStyle 
struct CornerRadiusShape : Shape{
    var radius = CGFloat.infinity
    var corners = UIRectCorner.allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        
        return Path(path.cgPath)
    }
}

struct CornerRadiusStyle : ViewModifier{
    var radius : CGFloat
    var corners : UIRectCorner
    
    func body(content: Content) -> some View {
        content
            .clipShape(CornerRadiusShape(radius: radius,corners: corners))
    }
}
