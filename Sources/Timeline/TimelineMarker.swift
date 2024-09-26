//
// Created by Mauricio Zaquia
//

import SwiftUI

/// A marker is a visual decoration attached to a specific entry in a ``Timeline``.
/// It is provided as a parameter to ``TimelineEntry/init(marker:content:)``.
public struct TimelineMarker {
    let builder: (_ index: Int) -> AnyView

    /// Creates a new, custom marker that can be used in a ``TimelineEntry``.
    ///
    /// - Parameter builder: The closure that builds the marker view. It receives the index of the entry.
    public init<Marker: View>(@ViewBuilder _ builder: @escaping (_ index: Int) -> Marker) {
        self.builder = { index in AnyView(builder(index)) }
    }
}

public extension TimelineMarker {
    /// A default marker for an entry.
    static var `default`: Self {
        Self { _ in
            Image(systemName: "circle.fill")
                .resizable()
                .frame(
                    width: 12,
                    height: 12
                )
                .foregroundStyle(.tint)
        }
    }
}
