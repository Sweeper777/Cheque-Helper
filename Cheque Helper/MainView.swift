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
