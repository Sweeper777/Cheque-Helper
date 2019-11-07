import SwiftUI
import Combine

struct ChequeConverterView: View {
    
    var body: some View {
        VStack {
            TextField(NSLocalizedString("Amount", comment: ""), text: $stateStore.amountString)
            Picker(selection: $stateStore.selectedLanguage, label: Text("")) {
                Text(NSLocalizedString("English", comment: "")).tag(0)
                Text(NSLocalizedString("中文", comment: "")).tag(1)
            }
            Text(stateStore.convertedString)
            Spacer()
        }.padding()
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
