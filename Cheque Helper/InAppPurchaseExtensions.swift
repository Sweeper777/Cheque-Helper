import UIKit
import StoreKit
import SCLAlertView
import EZLoadingActivity

extension ViewController {
    @IBAction func promptRemoveAds() {
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton("Yes".localized) { [weak self] in
            self?.productRequest = SKProductsRequest(productIdentifiers: [removeAdsProductID])
            self?.productRequest.delegate = self
            self?.productRequest.start()
            EZLoadingActivity.show("Loading...".localized, disableUI: true)
        }
        alert.addButton("Cancel".localized, action: {})
        alert.showInfo("Remove Ads".localized, subTitle: "Do you want to not see ads anymore?".localized)
    }
}
