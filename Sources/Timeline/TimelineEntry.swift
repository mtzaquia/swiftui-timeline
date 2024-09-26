//
// Created by Mauricio Zaquia
//

import SwiftUI

/// Entries that are listed and inter-connected in ``Timeline``.
public struct TimelineEntry<Content: View>: View {
    private let marker: TimelineMarker
    private let connector: TimelineConnector
    private let content: Content

    public var body: some View {
        content
            .timelineEntryInfo(TimelineEntryInfo(marker: marker, connector: connector))
    }

    /// Creates a new decorated entry in a ``Timeline``.
    ///
    /// - Parameters:
    ///   - marker: The design of the marker that decorates this entry.
    ///   - connector: The design of the connector between this entry and the one below it.
    ///   - content: The content of this entry.
    public init(
        marker: TimelineMarker = .default,
        connector: TimelineConnector = .default,
        @ViewBuilder content: () -> Content
    ) {
        self.marker = marker
        self.connector = connector
        self.content = content()
    }
}

// MARK: - TimelineEntryInfoTrait

struct TimelineEntryInfo {
    let marker: TimelineMarker
    let connector: TimelineConnector
}

struct TimelineEntryInfoTrait: _ViewTraitKey {
    static var defaultValue: TimelineEntryInfo?
}

private extension View {
    func timelineEntryInfo(_ info: TimelineEntryInfo) -> some View {
        _trait(TimelineEntryInfoTrait.self, info)
    }
}
