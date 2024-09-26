//
// Created by Mauricio Zaquia
//

import SwiftUI

/// A preference key that collects the maximum dimension in a view tree.
public struct MaxDimensionPreferenceKey: PreferenceKey {
    public static let defaultValue: CGFloat = .zero
    public static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}
