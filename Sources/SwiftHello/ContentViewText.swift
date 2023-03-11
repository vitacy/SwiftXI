import SwiftUI

struct MyContentView: View {
    var body: some View {
        VStack{
            Color.green.padding()
            Circle().fill(Color.red)
            Color.purple
                .frame(width: 100, height: 100)
        }
    }
}
