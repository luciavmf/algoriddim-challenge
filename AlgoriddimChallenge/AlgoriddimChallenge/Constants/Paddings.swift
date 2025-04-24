//
//  Paddings.swift
//  AlgoriddimChallenge
//
//  Created by Lucia Medina Fretes on 25.04.25.
//

import UIKit

/// The paddings of the screen. It's half for smaller screens
@MainActor
struct Paddings {
    // If the app is started in landscape mode then the width is equal to the UIScreen height, so we take the min of both values.
    private static var deviceWidth: CGFloat =
        min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)

    static var normal: CGFloat {
        Self.deviceWidth <= 375 ? 16 : 32
    }
}
