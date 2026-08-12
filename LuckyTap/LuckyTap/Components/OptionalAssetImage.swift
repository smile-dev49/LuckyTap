import SwiftUI
import UIKit

/// Loads a named asset when present; otherwise shows the provided placeholder.
/// Keeps the app compiling and running before custom art is added.
struct OptionalAssetImage<Placeholder: View>: View {
    let name: String
    @ViewBuilder var placeholder: () -> Placeholder

    var body: some View {
        if UIImage(named: name) != nil {
            Image(name)
                .resizable()
                .scaledToFit()
        } else {
            placeholder()
        }
    }
}
