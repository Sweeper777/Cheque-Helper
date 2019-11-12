import SwiftUI
import SCLAlertView

struct MainView: View {
    var body: some View {
        NavigationView {
            ChequeConverterView()
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
