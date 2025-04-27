//
//  OnboardingCustomView.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 27.04.25.
//

import UIKit

final class OnboardingCustomView: UIView {
    // MARK: Init

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

extension OnboardingCustomView: TransitionAnimatable {
    func animateTransitionIn(backwards: Bool, completion: @escaping () -> Void) {
        slideAnimate(direction: .rightToMiddle, backwards: backwards, completion: completion)
    }

    func animateTransitionOut(backwards: Bool, completion: @escaping () -> Void) {
        completion()
    }
}
