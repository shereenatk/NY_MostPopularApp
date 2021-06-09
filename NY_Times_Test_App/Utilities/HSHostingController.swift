//
//  HSHostingController.swift
//  NY_Times_Test_App
//
//  Created by Development  on 09/06/2021.
//

import Foundation
import SwiftUI
import SafariServices

class HSHosting {
    static var controller:UIViewController?
    static var nextModalPresentationStyle:UIModalPresentationStyle?

    static func openSafari(url:URL,tint:UIColor? = nil) {
        guard let controller = controller else {
            preconditionFailure("No controller present. Did you remember to use HSHostingController instead of UIHostingController in your SceneDelegate?")
        }

        let vc = SFSafariViewController(url: url)

        vc.preferredBarTintColor = tint
        //vc.delegate = self

        controller.present(vc, animated: true)
    }
}

class HSHostingController<Content> : UIHostingController<Content> where Content : View {

    override init(rootView: Content) {
        super.init(rootView: rootView)

        HSHosting.controller = self
    }

    @objc required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {

        if let nextStyle = HSHosting.nextModalPresentationStyle {
            viewControllerToPresent.modalPresentationStyle = nextStyle
            HSHosting.nextModalPresentationStyle = nil
        }

        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }

}
