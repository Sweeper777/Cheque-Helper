import SwiftUI
import Combine

struct ChequeConverterView: View {
    
    var body: some View {
    }
}

struct ChequeConverterView_Previews: PreviewProvider {
    static var previews: some View {
        ChequeConverterView()
    }
}

class ChequeConverterStateStore: ObservableObject {
    @Published var amountString = ""
    @Published var selectedLanguage = 0
    @Published var convertedString = ""
    var disposeBag = [AnyCancellable]()
    
}
