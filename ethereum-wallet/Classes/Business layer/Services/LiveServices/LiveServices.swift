//
//  LiveServices.swift
//  ethereum-wallet
//
//  Created by Artur Guseinov on 01/06/2018.
//  Copyright © 2018 Artur Guseinov. All rights reserved.
//

import Foundation


class LiveServices {
  
  lazy var locker: LockerProtocol = {
    return LockerFactory().create()
  }()
  
  lazy var backupper: BackupServiceProtocol = {
    let keychain = Keychain()
    let accountService = AccountService(keychain: keychain)
    return BackupService(keychain: keychain, accountService: accountService)
  }()
  
  lazy var screenLocker: ScreenLockerProtocol = {
    return ScreenLocker()
  }()
  
  lazy var pushConfigurator: PushConfiguratorProtocol = {
    return PushConfigurator(pushNetworkService: PushNetworkService(),
                            walletDataStoreService: WalletDataStoreService())
  }()
}

