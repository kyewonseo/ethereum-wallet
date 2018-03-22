// ethereum-wallet https://github.com/flypaper0/ethereum-wallet
// Copyright (C) 2018 Artur Guseinov
//
// This program is free software: you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the Free
// Software Foundation, either version 3 of the License, or (at your option)
// any later version.
//
// This program is distributed in the hope that it will be useful, but WITHOUT
// ANY WARRANTY; without even the implied warranty of  MERCHANTABILITY or
// FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
// more details.
//
// You should have received a copy of the GNU General Public License along with
// this program.  If not, see <http://www.gnu.org/licenses/>.


import UIKit


class BalanceViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  @IBOutlet weak var titleLabel: UILabel!
  @IBOutlet weak var balanceLabel: UILabel!
  @IBOutlet weak var receiveButton: UIButton!
  @IBOutlet weak var receiveLabel: UILabel!
  @IBOutlet weak var sendButton: UIButton!
  @IBOutlet weak var sendLabel: UILabel!
  @IBOutlet weak var tokenCountLabel: UILabel!
  @IBOutlet weak var tokenBalanceLabel: UILabel!
    
  var output: BalanceViewOutput!
  
  private var tokens = [Token]()
  private var localCurrency = Constants.Wallet.defaultCurrency
  
  // MARK: Life cycle

  override func viewDidLoad() {
    super.viewDidLoad()
    setupTableView()
    localize()
    output.viewIsReady()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: animated)
    output.viewIsAppear()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: animated)
  }
  
  // MARK: - Privates
  
  private func setupTableView() {
    let tableWidth = view.bounds.width
    let size = CGSize(width: tableWidth, height: tableWidth+50)
    tableView.tableHeaderView?.frame = CGRect(origin: .zero, size: size)
    tableView.contentInsetAdjustmentBehavior = .never
    tableView.backgroundColor = Theme.Color.lightGray
  }
  
  private func localize() {
    titleLabel.text = Localized.balanceEthTitle()
    receiveLabel.text = Localized.balanceReceive()
    sendLabel.text = Localized.balanceSend()
  }
  
  private func updateTokensDetails() {
    var summ: Double = 0
    for token in tokens {
      summ += token.rawAmount(for: localCurrency)
    }
    
    tokenBalanceLabel.text = FiatCurrencyFactory.amount(amount: summ, iso: localCurrency)
    tokenCountLabel.text = Localized.balanceTokenCount("\(tokens.count)")
  }
  
  // MARK: - Actions
  
  @IBAction func sendPressed(_ sender: UIButton) {
    output.didSendPressed()
  }
  
  @IBAction func receivePressed(_ sender: UIButton) {
    output.didReceivePressed()
  }
}

// MARK: - TableView

extension BalanceViewController: UITableViewDataSource, UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeue(TokenCell.self, for: indexPath)
    cell.configure(with: tokens[indexPath.row])
    cell.layer.zPosition = 1
    return cell
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tokens.count
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 184
  }
    
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    output.didSelectToken(tokens[indexPath.row])
  }

}


// MARK: - BalanceViewInput

extension BalanceViewController: BalanceViewInput {
  
  func setupInitialState() {
  }
  
  func didReceiveWallet(_ wallet: Wallet) {
    self.localCurrency = wallet.localCurrency
    updateTokensDetails()
  }
  
  func didReceiveTokens(_ tokens: [Token]) {
    self.tokens = tokens
    tableView.reloadData()
    updateTokensDetails()
    
  }
  
  func didReceiveCoin(_ coin: Coin) {
    balanceLabel.text = coin.balance.amountString
  }

}
