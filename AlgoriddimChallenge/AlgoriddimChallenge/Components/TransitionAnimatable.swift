//
//  TransitionAnimatable.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 27.04.25.
//

import UIKit

typealias TransitionAnimatableView = any UIView & TransitionAnimatable

@MainActor
protocol TransitionAnimatable {
    func animateTransitionIn(backwards: Bool, completion: @escaping () -> Void)
    func animateTransitionOut(backwards: Bool, completion: @escaping () -> Void)
}
