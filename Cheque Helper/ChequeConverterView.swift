import SwiftUI
import Combine

struct ChequeConverterView: View {
    @ObservedObject var stateStore = ChequeConverterViewModel()
    
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

class ChequeConverterViewModel: ObservableObject {
    @Published var amountString = ""
    @Published var selectedLanguage = 0
    {
        didSet {
            UIApplication.shared.endEditing()
        }
    }
    @Published var convertedString = ""
    var disposeBag = [AnyCancellable]()
    
    init() {
        disposeBag.append($amountString
            .debounce(for: 0.7, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map(removeFormatting(_:))
            .map(convertNumberString(_:))
            .sink(receiveValue: { self.convertedString = $0 }))
        
        disposeBag.append($amountString
            .debounce(for: 1, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .map(formatTextFieldText(_:))
            .sink { self.amountString = $0 })
        
        disposeBag.append($selectedLanguage
            .removeDuplicates()
            .sink { lang in
                self.convertedString = self.convertNumberString(
                    self.removeFormatting(self.amountString), language: lang
                )
        })
    }
    
    deinit {
        disposeBag.forEach { $0.cancel() }
    }
    
    func convertNumberString(_ str: String) -> String {
        convertNumberString(str, language: selectedLanguage)
    }
    
    func convertNumberString(_ str: String, language: Int) -> String {
        if language == 0 {
            return EnglishChequeConverter().convertNumberString(str)
        } else {
            return ChineseChequeConverter().convertNumberString(str)
        }
    }
    
    func formatTextFieldText(_ text: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        if !text.hasSuffix(formatter.decimalSeparator) {
            let amount = NSDecimalNumber(string:
                text.replacingOccurrences(of: formatter.groupingSeparator, with: "")
                    .replacingOccurrences(of: formatter.decimalSeparator ?? ".", with: ".")
            )
            if !NSDecimalNumber.notANumber.isEqual(to: amount) {
                if let formatted = formatter.string(from: amount) {
                    return formatted
                }
            }
        }
        return text
    }
    
    func removeFormatting(_ text: String) -> String {
        return text
            .replacingOccurrences(of: Locale.current.groupingSeparator ?? "", with: "")
            .replacingOccurrences(of: Locale.current.decimalSeparator ?? ".", with: ".")
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
