//
//  UIView+SlideAnimation.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 25.04.25.
//

import UIKit

/// Common constants of the animation duration.
struct AnimationDuration {
    static let fast: TimeInterval = 0.25
    static let medium: TimeInterval = 0.35
    static let normal: TimeInterval = 0.5
    static let slow: TimeInterval = 0.75
}

/// The direction of a slide animation.
enum SlideDirection {
    case rightToMiddle
    case middleToLeft
}

/// A UIView extension that adds a slide animation to itself.
@MainActor
extension UIView {
    func slideAnimate(
        direction: SlideDirection,
        delay: TimeInterval = 0,
        duration: TimeInterval = AnimationDuration.medium,
        backwards: Bool = false,
        completion: @escaping () -> Void = {}
    ) {
        prepareSlideAnimation(direction: direction, backwards: backwards)

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.updateSlideAnimation(direction: direction, backwards: backwards)
            },
            completion: { _ in
                completion()
            }
        )
    }

    private func prepareSlideAnimation(direction: SlideDirection, backwards: Bool) {
        switch direction {
        case .rightToMiddle:
            alpha = backwards ? 1 : 0
            transform = backwards ? .identity : CGAffineTransform(translationX: bounds.width, y: 0)

        case .middleToLeft:
            alpha = backwards ? 0 : 1
            transform = backwards ? CGAffineTransform(translationX: -bounds.width, y: 0) : .identity
        }
    }

    private func updateSlideAnimation(direction: SlideDirection, backwards: Bool) {
        switch direction {
        case .rightToMiddle:
            alpha = backwards ? 0 : 1
            transform = backwards ? CGAffineTransform(translationX: bounds.width, y: 0) : .identity

        case .middleToLeft:
            alpha = backwards ? 1 : 0
            transform = backwards ? .identity : CGAffineTransform(translationX: -bounds.width, y: 0)
        }
    }
}

@MainActor
extension UIView {
    func fadeOut(
        duration: TimeInterval = AnimationDuration.fast,
        delay: TimeInterval = 0,
        backwards: Bool = false,
        completion: @escaping () -> Void = {}
    ) {
        alpha = backwards ? 0 : 1
        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.alpha = backwards ? 1 : 0
            },
            completion: { _ in
                completion()
            }
        )
    }

    func fadeIn(
        duration: TimeInterval = AnimationDuration.fast,
        delay: TimeInterval = 0,
        backwards: Bool = false,
        completion: @escaping () -> Void = {}
    ) {

        alpha = backwards ? 1 : 0

        UIView.animate(
            withDuration: duration,
            delay: delay,
            options: [.curveEaseInOut],
            animations: { [weak self] in
                self?.alpha = backwards ? 0 : 1
            },
            completion: { _ in
                completion()
            }
        )
    }
}
