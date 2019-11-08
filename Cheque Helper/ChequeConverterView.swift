import SwiftUI
import Combine

struct ChequeConverterView: View {
    @ObservedObject var stateStore = ChequeConverterStateStore()
    
    var body: some View {
        VStack {
            TextField(NSLocalizedString("Amount", comment: ""), text: $stateStore.amountString)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.decimalPad)
            Picker(selection: $stateStore.selectedLanguage, label: Text("")) {
                Text(NSLocalizedString("English", comment: "")).tag(0)
                Text(NSLocalizedString("中文", comment: "")).tag(1)
            }
                .pickerStyle(SegmentedPickerStyle())
                .fixedSize()
            Text(stateStore.convertedString)
                .font(Font.custom("Times New Roman Italic", size: 20))
                .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                .lineLimit(nil)
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
    {
        didSet {
            UIApplication.shared.endEditing()
        }
    }
    @Published var convertedString = ""
    var disposeBag = [AnyCancellable]()
    
    
    deinit {
        disposeBag.forEach { $0.cancel() }
    }
    
    
    func convertNumberString(_ str: String, language: Int) -> String {
        if language == 0 {
            return EnglishChequeConverter().convertNumberString(str)
        } else {
            return ChineseChequeConverter().convertNumberString(str)
        }
    }
    
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
