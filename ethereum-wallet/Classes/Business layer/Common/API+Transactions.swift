//
//  API+Transactions.swift
//  ethereum-wallet
//
//  Created by Artur Guseinov on 11/04/2018.
//  Copyright © 2018 Artur Guseinov. All rights reserved.
//

import Alamofire

extension API {
  
  enum Transactions {
    case transactions(address: String, page: Int, limit: Int)
  }
  
}

extension API.Transactions: APIMethodProtocol {
  
  var path: String {
    switch self {
    case .transactions:
      let chain = Defaults.chain
      return chain.backend + "/transactions"
    }
  }
  
  var method: HTTPMethod {
    switch self {
    case .transactions:
      return .get
    }
  }
  
  var params: APIMethodProtocol.Params? {
    switch self {
    case .transactions(let address, let page, let limit):
      return [
        "address": address,
        "limit": limit,
        "page": page
      ]
    }
  }
  
}