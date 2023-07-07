//
//  RedButton.swift
//  DabangSwift
//
//  Created by you dong woo on 2021/04/28.
//

import UIKit

// MARK: - Basic Button

class RedLineButton: ComponentButton, RedLineButtonStyle {}

class RedSolidButton: ComponentButton, RedSolidButtonStyle {}

class RedLineIconButton: RedLineButton, ButtonIconSupportable {}

class RedSolidIconButton: RedSolidButton, ButtonIconSupportable {}

class RedTextButton: ComponentButton, RedTextButtonStyle {}

class RedTextIconButton: RedTextButton, ButtonIconSupportable {}

// MARK: - Line Button

final class RedLineXLargeButton: RedLineButton, ButtonXLargeHeightSupportable {}

final class RedLineLargeButton: RedLineButton, ButtonLargeHeightSupportable {}

final class RedLineMediumButton: RedLineButton, ButtonMediumHeightSupportable {}

final class RedLineSmallButton: RedLineButton, ButtonSmallHeightSupportable {}

// MARK: - Line Icon Button

final class RedLineIconXLargeButton: RedLineIconButton, ButtonXLargeHeightSupportable {}

final class RedLineIconLargeButton: RedLineIconButton, ButtonLargeHeightSupportable {}

final class RedLineIconMediumButton: RedLineIconButton, ButtonMediumHeightSupportable {}

final class RedLineIconSmallButton: RedLineIconButton, ButtonSmallHeightSupportable {}

// MARK: - Solid Button

final class RedSolidXLargeButton: RedSolidButton, ButtonXLargeHeightSupportable {}

final class RedSolidLargeButton: RedSolidButton, ButtonLargeHeightSupportable {}

final class RedSolidMediumButton: RedSolidButton, ButtonMediumHeightSupportable {}

final class RedSolidSmallButton: RedSolidButton, ButtonSmallHeightSupportable {}

// MARK: - Solid Icon Button

final class RedSolidIconXLargeButton: RedSolidIconButton, ButtonXLargeHeightSupportable {}

final class RedSolidIconLargeButton: RedSolidIconButton, ButtonLargeHeightSupportable {}

final class RedSolidIconMediumButton: RedSolidIconButton, ButtonMediumHeightSupportable {}

final class RedSolidIconSmallButton: RedSolidIconButton, ButtonSmallHeightSupportable {}

// MARK: - Text Button

final class RedTextXLargeButton: RedTextButton, ButtonXLargeHeightSupportable {}

final class RedTextLargeButton: RedTextButton, ButtonLargeHeightSupportable {}

final class RedTextMediumButton: RedTextButton, ButtonMediumHeightSupportable {}

final class RedTextSmallButton: RedTextButton, ButtonSmallHeightSupportable {}

// MARK: - Text Icon Button

final class RedTextIconXLargeButton: RedTextIconButton, ButtonXLargeHeightSupportable {}

final class RedTextIconLargeButton: RedTextIconButton, ButtonLargeHeightSupportable {}

final class RedTextIconMediumButton: RedTextIconButton, ButtonMediumHeightSupportable {}

final class RedTextIconSmallButton: RedTextIconButton, ButtonSmallHeightSupportable {}
