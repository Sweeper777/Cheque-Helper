import SwiftUI

struct MainView: View {
    var body: some View {
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
