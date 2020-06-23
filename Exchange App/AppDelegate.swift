//
//  AppDelegate.swift
//  Exchange App
//
//  Created by Marius Ilie on 20/06/2020.
//  Copyright © 2020 Marius Ilie. All rights reserved.
//

import UIKit
import CoreData
import RxSwift
import RxCocoa

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    let disposeBag = DisposeBag()
    var window: UIWindow?

    let exchangeApiRequestsAdapter = ExchangeApiRequestAdapter(env: .prod)
    let appSettingsSource = BehaviorRelay<AppSettings>(value: AppDefaults.DefaultAppSettings)

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        return true
    }

    // MARK: UISceneSession Lifecycle
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        appSettingsSource.subscribe { event in
            print(event)
        }.disposed(by: disposeBag)
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    }
}

extension UIApplication {
    var appDelegate: AppDelegate { delegate as! AppDelegate }

    var exchangeApiRequestsAdapter: ExchangeApiRequestAdapter {
        return appDelegate.exchangeApiRequestsAdapter
    }

    var settingsSource: BehaviorRelay<AppSettings> {
        return appDelegate.appSettingsSource
    }

    var settings: AppSettings { settingsSource.value }
}
