//
// Created by Mauricio Zaquia
//

import SwiftUI

/// A `Timeline` view renders connected entries, with optional view in-between.
public struct Timeline<Content: View>: View {
    private let verticalSpacing: CGFloat?
    private let content: Content

    @Namespace private var timelineCoordinateNamespace
    @State private var maxMarkerWidth: CGFloat?

    public var body: some View {
        content.variadic { children in
            VStack(alignment: .leading, spacing: verticalSpacing) {
                ForEach(Array(children.enumerated()), id: \.0) { index, child in
                    Label {
                        child
                    } icon: {
                        if let timelineEntryInfo = child[TimelineEntryInfoTrait.self] {
                            timelineEntryInfo.marker.builder(index)
                                .background(GeometryReader { proxy in
                                    Color.clear
                                        .preference(
                                            key: MaxDimensionPreferenceKey.self,
                                            value: proxy.size.width
                                        )
                                        .preference(
                                            key: MarkerInfoPreferenceKey.self,
                                            value: [
                                                index: (
                                                    timelineEntryInfo.connector,
                                                    proxy.frame(in: .named(timelineCoordinateNamespace))
                                                )
                                            ]
                                        )
                                })
                                .frame(width: maxMarkerWidth)
                        } else {
                            Color.clear
                                .frame(width: maxMarkerWidth, height: 0)
                        }
                    }
                    .labelStyle(.titleAndIcon)
                }
            }
            .onPreferenceChange(MaxDimensionPreferenceKey.self) {
                maxMarkerWidth = $0
            }
            .coordinateSpace(name: timelineCoordinateNamespace)
            .backgroundPreferenceValue(MarkerInfoPreferenceKey.self) { markerInfo in
                let sortedKeys = markerInfo.keys.sorted()
                let markersCount = sortedKeys.count
                let lineCount = markersCount - 1
                ForEach(0..<lineCount, id: \.self) { index in
                    let rect = markerInfo[sortedKeys[index]]?.1 ?? CGRect.zero
                    let nextRect = markerInfo[sortedKeys[index + 1]]?.1 ?? CGRect.zero

                    let connector = markerInfo[sortedKeys[index]]?.0 ?? .default
                    let lineWidth: CGFloat = 2
                    let distance = nextRect.minY - rect.maxY - (lineWidth * 2)

                    VLine()
                        .stroke(
                            connector.style,
                            style: StrokeStyle(
                                lineWidth: lineWidth,
                                lineCap: .round,
                                dash: connector.dashed ? [lineWidth, lineWidth * 2] : []
                            )
                        )
                        .frame(height: distance)
                        .position(x: rect.midX, y: rect.maxY + lineWidth)
                        .offset(y: distance / 2)
                }
            }
        }
    }

    /// Creates a new ``Timeline``.
    ///
    /// - Parameters:
    ///   - verticalSpacing: The spacing between every view in the timeline.
    ///   - content: The entries and additional views.
    public init(
        verticalSpacing: CGFloat? = nil,
        @ViewBuilder content: () -> Content
    ) {
        self.verticalSpacing = verticalSpacing
        self.content = content()
    }
}

// MARK: - Preferences

private struct MarkerInfoPreferenceKey: PreferenceKey {
    static let defaultValue: [Int: (TimelineConnector, CGRect)] = [:]
    static func reduce(
        value: inout [Int: (TimelineConnector, CGRect)],
        nextValue: () -> [Int: (TimelineConnector, CGRect)]
    ) {
        value = value.merging(nextValue()) { _, new in new }
    }
}

// MARK: - Preview

#Preview {
    Timeline {
        TimelineEntry(marker: .init { _, _ in Image(systemName: "checkmark.seal") }) {
                Text("Entry with custom marker")
            }
            Text("Additional content")
                .font(.title)
            TimelineEntry {
                Text("Timeline continuation, defaults")
            }
            TimelineEntry(connector: .init(style: .orange, dashed: true)) {
                Text("Custom connectors")
            }
            TimelineEntry {
                Text("The end")
            }
        }
    }
}
