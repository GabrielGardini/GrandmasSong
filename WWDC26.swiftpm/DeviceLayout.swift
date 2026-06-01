//
//  DeviceLayout.swift
//  WWDC26
//
//  Centralized responsive layout utilities.
//  All device-specific sizing decisions live here — no scattered conditionals
//  throughout the rest of the codebase.
//
//  Usage pattern:
//    DeviceLayout.isPhone          → Bool
//    DeviceLayout.chatFontSize     → CGFloat
//    DeviceLayout.chatAvatarSize(boxSize:)  → CGFloat
//    DeviceLayout.aboutCardSize(for:)       → CGFloat  (needs GeometryProxy)
//

import SwiftUI

enum DeviceLayout {

    // MARK: - Device Detection

    /// `true` when running on any iPhone model.
    static var isPhone: Bool {
        UIDevice.current.userInterfaceIdiom == .phone
    }

    /// `true` when running on any iPad model.
    static var isPad: Bool {
        UIDevice.current.userInterfaceIdiom == .pad
    }

    // MARK: - ChatBox

    /// Font size for VT323 dialogue text.
    /// iPad keeps the original 50 pt; iPhone drops to 34 pt so text
    /// stays readable inside the smaller chatbox container.
    static var chatFontSize: CGFloat {
        isPhone ? 34 : 50
    }

    /// Avatar image size inside the ChatBox.
    /// On iPhone the avatar is capped at 90 pt so it doesn't crowd the
    /// text area on narrow/short screens; on iPad it stays proportional
    /// to the container height (the original `boxSize` value).
    static func chatAvatarSize(boxSize: CGFloat) -> CGFloat {
        isPhone ? min(boxSize, 90) : boxSize
    }

    /// Leading padding applied to the text when the `.none` character
    /// variant is used (invisible avatar still occupies space).
    /// Scales with the actual rendered avatar size so the text slides
    /// correctly over the empty avatar area on both device types.
    static func chatNoneLeadingPadding(avatarSize: CGFloat) -> CGFloat {
        isPhone ? -(avatarSize * 0.45) : -100
    }

    /// Trailing padding for the "next scene" arrow button.
    static var chatNextButtonTrailingPadding: CGFloat {
        isPhone ? 16 : 50
    }

    // MARK: - About Me Card

    /// Size (width = height) of the info card in the About Me screen.
    /// Uses the shorter screen dimension so the card always fits without
    /// overflowing on landscape iPhone.
    static func aboutCardSize(for geometry: GeometryProxy) -> CGFloat {
        guard isPhone else { return 400 }
        let shorter = min(geometry.size.width, geometry.size.height)
        return min(shorter * 0.80, 340)
    }

    /// Horizontal offset for the About Me card.
    /// On iPad the card slides right to align with the background art;
    /// on iPhone it stays centred (offset = 0).
    static func aboutCardOffsetX(for geometry: GeometryProxy) -> CGFloat {
        isPhone ? 0 : geometry.size.width / 4.5
    }

    /// Vertical offset for the About Me card.
    static func aboutCardOffsetY(for geometry: GeometryProxy) -> CGFloat {
        isPhone ? 0 : -geometry.size.width / 13
    }

    // MARK: - Action Buttons

    /// Maximum width for primary CTA buttons (Play, Home, etc.).
    /// On iPhone capped at 55 % of screen width.
    static func buttonMaxWidth(for geometry: GeometryProxy) -> CGFloat {
        isPhone ? min(geometry.size.width * 0.55, 280) : 400
    }

    /// Maximum height for primary CTA buttons.
    /// On iPhone capped at 22 % of screen height (~85 pt in landscape)
    /// so two stacked buttons always fit regardless of image aspect ratio.
    /// On iPad no upper-bound is imposed.
    static func buttonMaxHeight(for geometry: GeometryProxy) -> CGFloat {
        isPhone ? geometry.size.height * 0.22 : .infinity
    }

    // MARK: - Scene Bottom Spacer

    /// Bottom spacer height used in every scene's VStack.
    ///
    /// The GeometryReader inside each scene fills the full screen (because the
    /// ZStack's background uses ignoresSafeArea), so geometry.size.height
    /// includes the home-indicator area on iPhone (~21 pt in landscape).
    /// The original value of height/30 is only ~13 pt on a 390 pt iPhone
    /// screen — less than the indicator — so the chatbox bottom is hidden.
    /// On iPhone we use 1/12 (~32 pt) to clear the indicator with margin.
    /// On iPad the original 1/30 ratio is preserved unchanged.
    static func sceneBottomPadding(for geometry: GeometryProxy) -> CGFloat {
        isPhone ? geometry.size.height / 12 : geometry.size.height / 30
    }
}
