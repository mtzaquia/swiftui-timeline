//
// Created by Mauricio Zaquia
//

import SwiftUI

/// A connector is the vertical line between two ``TimelineEntry`` in a ``Timeline``.
public struct TimelineConnector {
    let style: AnyShapeStyle
    let dashed: Bool

    /// Creates a custom connector.
    ///
    /// - Parameters:
    ///   - style: The style to be used when stroking the connector.
    ///   - dashed: Whether the connector should be dashed or not. Defaults to `false`.
    public init(style: some ShapeStyle, dashed: Bool = false) {
        self.style = AnyShapeStyle(style)
        self.dashed = dashed
    }
}

public extension TimelineConnector {
    /// A default style for a connector.
    static var `default`: Self {
        Self(style: .tint, dashed: false)
    }
}

// MARK: - VLine

struct VLine: Shape {
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
        }
    }
}
