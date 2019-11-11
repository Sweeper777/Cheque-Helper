import SwiftUI
import SCLAlertView

struct MainView: View {
    @Published var amountText = ""
    var body: some View {
        NavigationView {
            ChequeConverterView(amountText: $amountText)
                .navigationBarTitle(Text(NSLocalizedString("Cheque Helper", comment: "")), displayMode: .inline)
                .navigationBarItems(trailing:
                    Button(
                        action: {},
                        label: { Text(NSLocalizedString("Ads?", comment: "")) }
                    )
                )
        }
    }
    
    func showRateMsg() {
        UIApplication.shared.endEditing()
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton(NSLocalizedString("Rate!", comment: "")) {
            UIApplication.shared.open(
                URL(string: "https://itunes.apple.com/us/app/pocket-cheque-helper/id1072718086?mt=8")!,
                options: [:], completionHandler: nil)
        }
        alert.addButton(NSLocalizedString("Send Feedback", comment: "")) {
            UIApplication.shared.open(
                URL(string: "mailto:sumulang.apps@gmail.com?subject=Cheque Helper Feedback".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlPathAllowed)!)!,
                options: [:], completionHandler: nil)
        }
        alert.addButton(NSLocalizedString("Maybe Later", comment: ""), action: {})
        _ = alert.showCustom(NSLocalizedString("Enjoying Cheque Helper?", comment: ""), subTitle: NSLocalizedString("You can rate this app, or send me feedback!", comment: ""), color: UIColor(hex: "5abb5a"), circleIconImage: UIImage())
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}

class MainViewController: UIHostingController<MainView> {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder, rootView: MainView())
        
    }
}
