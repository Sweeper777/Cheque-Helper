import UIKit
import StoreKit
import SCLAlertView
import EZLoadingActivity

extension ViewController {
    @IBAction func promptRemoveAds() {
        view.endEditing(true)
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

extension ViewController: SKProductsRequestDelegate {
    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        EZLoadingActivity.hide()
        if let product = response.products.first {
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency
            numberFormatter.locale = product.priceLocale
            let price = numberFormatter.string(from: product.price)
            let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        } else {
            showIAPError(message: "Unable to get product information. Please check your Internet connection.".localized)
        }
    }
    func showIAPError(message: String) {
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton("OK".localized, action: {})
        alert.showError("Oops!".localized, subTitle: message)
    }
}
