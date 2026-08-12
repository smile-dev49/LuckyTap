import SwiftUI
import UIKit

/// Loads a named asset when present; otherwise shows the provided placeholder.
struct OptionalAssetImage<Placeholder: View>: View {
    let name: String
    var contentMode: ContentMode = .fit
    @ViewBuilder var placeholder: () -> Placeholder

    var body: some View {
        Group {
            if UIImage(named: name) != nil {
                Image(name)
                    .resizable()
                    .aspectRatio(contentMode: contentMode)
            } else {
                placeholder()
            }
        }
    }
}
