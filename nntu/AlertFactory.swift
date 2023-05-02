//
//  AlertFactory.swift
//  nntu
//
//  Created by Алексей Шерстнёв on 29.03.2022.
//  Copyright © 2022 Алексей Шерстнев. All rights reserved.
//

import UIKit

final class AlertFactory {
    static let shared = AlertFactory()
    private init() {}
    func makePrompt(title: String? = nil, message: String? = nil, buttonText: String? = nil) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: buttonText ?? "OK", style: .default)
        alert.addAction(ok)
        return alert
    }
}
