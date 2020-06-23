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

    var mainShadowColor: UIColor?
    let exchangeApiRequestsAdapter = ExchangeApiRequestAdapter(env: .prod)
    var appSettingsSource: BehaviorRelay<AppSettings>!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UIImage(named: AppDefaults.DefaultFlagBG)?.getColors { colors in self.mainShadowColor = colors?.primary }
        loadSettingsFromStorage()
        setupSaveSettingsBinder()

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

    private func loadSettingsFromStorage() {
        if let appSettingsJson = UserDefaults.standard.object(forKey: "AppSettings") as? Data {
            let decoder = JSONDecoder()
            if let appSettings = try? decoder.decode(AppSettings.self, from: appSettingsJson) {
                appSettingsSource = .init(value: appSettings)
            } else {
                appSettingsSource = .init(value: AppDefaults.DefaultAppSettings)
            }
        } else {
            appSettingsSource = .init(value: AppDefaults.DefaultAppSettings)
        }
    }

    private func setupSaveSettingsBinder() {
        appSettingsSource
            .subscribe(onNext: { appSettings in
                let encoder = JSONEncoder()
                if let encoded = try? encoder.encode(appSettings) {
                    UserDefaults.standard.set(encoded, forKey: "AppSettings")
                }
            }).disposed(by: disposeBag)
    }
}

extension UIApplication {
    var appDelegate: AppDelegate { delegate as! AppDelegate }

    var mainSadowColor: UIColor? { appDelegate.mainShadowColor }
    var exchangeApiRequestsAdapter: ExchangeApiRequestAdapter { appDelegate.exchangeApiRequestsAdapter }

    var settingsSource: BehaviorRelay<AppSettings> { appDelegate.appSettingsSource }
    var settings: AppSettings { settingsSource.value }

    var topViewController: UIViewController? {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            return topController
        }
        return nil
    }

    func setLoader(_ active: Bool) {
        active ? showLoader() : hideLoader()
    }

    func showLoader() {
        guard !(topViewController is LoaderViewController) else { return }
        let controller = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LoadingViewController")
        controller.modalPresentationStyle = .overFullScreen
        controller.modalTransitionStyle = .crossDissolve
        UIApplication.shared.topViewController?.present(controller, animated: true)
    }

    func hideLoader(_ completion:(() -> ())? = nil, animated: Bool = true) {
        (topViewController as? LoaderViewController)?.dismiss(animated: animated) {
            completion?()
        }
    }
}
