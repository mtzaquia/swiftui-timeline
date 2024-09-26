//
// Created by Mauricio Zaquia
//

import SwiftUI

extension View {
    func variadic<Result: View>(
        @ViewBuilder transform: @escaping (_VariadicView.Children) -> Result
    ) -> some View {
        modifier(VariadicModifier(helper: Helper(process: transform)))
    }
}

private struct VariadicModifier<Result: View>: ViewModifier {
    var helper: Helper<Result>
    func body(content: Content) -> some View {
        _VariadicView.Tree(helper) { content }
    }
}

private struct Helper<Result: View>: _VariadicView_MultiViewRoot {
    var process: (_VariadicView.Children) -> Result
    func body(children: _VariadicView.Children) -> some View {
        process(children)
    }
}
