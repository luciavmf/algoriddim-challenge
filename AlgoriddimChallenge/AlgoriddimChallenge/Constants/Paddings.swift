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
    static var half: CGFloat {
        DeviceScreenSize.width <= 375 ? 8 : 16
    }

    static var normal: CGFloat {
        DeviceScreenSize.width <= 375 ? 16 : 32
    }

    static var third: CGFloat {
        DeviceScreenSize.width <= 375 ? 12 : 24
    }

    static var checkbox: CGFloat {
        DeviceScreenSize.width <= 375 ? 10 : 12
    }
}

/// The device screen size. If the app is started in landscape mode then the width is equal to the UIScreen height, so we take the min of both values.
@MainActor
struct DeviceScreenSize {
    static var width: CGFloat =
        min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)
}

@MainActor
struct FontConstants {
    static var titleFontSize: CGFloat = DeviceScreenSize.width <= 375 ? 22 : 34
}
