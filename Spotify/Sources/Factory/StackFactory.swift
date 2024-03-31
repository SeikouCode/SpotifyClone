//
//  StackFactory.swift
//  Spotify
//
//  Created by Aneli  on 25.03.2024.
//

import UIKit

final class StackFactory {
    static func createStackView(
    spacing: CGFloat = 2,
    distribution: UIStackView.Distribution = .fillEqually,
    alignment: UIStackView.Alignment = .fill,
    axis: NSLayoutConstraint.Axis = .vertical,
    isSkeletonable: Bool = false,
    skeletonCornerRadius: Float = 2
    ) -> UIStackView {
        let stack = UIStackView()
        stack.spacing = spacing
        stack.distribution = distribution
        stack.alignment = alignment
        stack.axis = axis
        stack.isSkeletonable = isSkeletonable
        stack.skeletonCornerRadius = skeletonCornerRadius
        return stack
    }
}
