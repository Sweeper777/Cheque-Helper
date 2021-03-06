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
            alert.addButton(String(format: "Remove ads for %@".localized, price!)) { [weak self] in
                guard let `self` = self else { return }
                if SKPaymentQueue.canMakePayments() {
                    SKPaymentQueue.default().add(self)
                    SKPaymentQueue.default().add(SKPayment(product: product))
                    EZLoadingActivity.show("Loading...".localized, disableUI: true)
                } else {
                    self.showIAPError(message: "Purchases are disabled on this device!".localized)
                }
            }
            alert.addButton("Restore Purchase".localized) { [weak self] in
                guard let `self` = self else { return }
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().restoreCompletedTransactions()
                EZLoadingActivity.show("Loading...".localized, disableUI: true)
            }
            alert.addButton("Cancel".localized, action: {})
            alert.showInfo("Remove Ads".localized, subTitle: String(format: "Do you want to remove ads for %@?".localized, price!))
        } else {
            showIAPError(message: "Unable to get product information. Please check your Internet connection.".localized)
        }
    }
    
    func request(_ request: SKRequest, didFailWithError error: Error) {
        EZLoadingActivity.hide()
        showIAPError(message: "Unable to get product information. Please check your Internet connection.".localized)
    }
    
    func showIAPError(message: String) {
        let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
        alert.addButton("OK".localized, action: {})
        alert.showError("Oops!".localized, subTitle: message)
    }
}

extension ViewController: SKPaymentTransactionObserver {
    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        EZLoadingActivity.hide()
        if queue.transactions.isEmpty {
            showIAPError(message: "You have not purcheased this yet, so you cannot restore this purchase!".localized)
        } else {
            UserDefaults.standard.set(true, forKey: "adsRemoved")
            let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
            alert.addButton("OK".localized, action: {})
            alert.showSuccess("Success!".localized, subTitle: "No more ads will be shown to you!".localized)
            navigationItem.rightBarButtonItems?.removeAll()
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        EZLoadingActivity.hide()
        for transaction:AnyObject in transactions {
            if let trans = transaction as? SKPaymentTransaction {
                switch trans.transactionState {
                case .purchased:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    UserDefaults.standard.set(true, forKey: "adsRemoved")
                    let alert = SCLAlertView(appearance: SCLAlertView.SCLAppearance(showCloseButton: false))
                    alert.addButton("OK".localized, action: {})
                    alert.showSuccess("Success!".localized, subTitle: "No more ads will be shown to you!".localized)
                    navigationItem.rightBarButtonItems?.removeAll()
                case .failed:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                    showIAPError(message: "Unable to purchase. Please check your Internet connection.".localized)
                case .restored:
                    SKPaymentQueue.default().finishTransaction(transaction as! SKPaymentTransaction)
                default: break
                }
            }
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
