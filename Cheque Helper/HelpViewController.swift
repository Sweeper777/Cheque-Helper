import UIKit

class HelpViewController: UIViewController {
    @IBOutlet var webView: UIWebView!
    
    override func viewDidLoad() {
        automaticallyAdjustsScrollViewInsets = true
        let htmlString =
            "<center><h1>Pocket Cheque Helper</h1></center><p>Welcome to Pocket Cheque Helper! If you want to know about how to use this app correctly, please continue reading this.</p><p>歡迎來到 Pocket Cheque Helper！如果你想了解如何正確地使用這個APP，請繼續閱讀。</p><p>You just need to enter an amount of money in the blank provided and press the \"Convert\" button. You will then see the converted result down below.</p><p>你只要輸入想要轉換的幣值，再按“轉換”鈕，轉換後的結果就會被顯示在下方。</p><p>Please note that there are limitations. Any amounts that are less than 1 or larger than 999,999,999,999,999,999 (for the English version) or 9,999,999,999,999,999 (or the Chinese version) are not accepted. In addition, amounts with more than 2 decimal places are treated as 2 decimal places.</p><p>請注意：對於幣值的格式是有所限制的。所有小於 1 或大於 999,999,999,999,999,999（英文版）或9,999,999,999,999,999（中文版）的幣值恕不接受；所有含有多於兩位小數的幣值將會被視為只含有兩位小數。</p>"
        webView.loadHTMLString(htmlString, baseURL: nil)
    }
    
    @IBAction func doneClicked(sender: UIBarButtonItem) {
        performSegueWithIdentifier("exitToMain", sender: self)
    }
}
