//
//  WidgetFucntions.swift
//  nntu pre-alpha
//
//  Created by Дмитрий Юдин on 06.02.2021.
//  Copyright © 2021 Алексей Шерстнев. All rights reserved.
//

import Foundation

// MARK: ShortType
func shortType(_ type: String) -> String {
    let lowercasedType = type.lowercased()
    
    if lowercasedType.contains("прак") {
        return "пр."
    }
    else if lowercasedType.contains("лекц") {
        return "лек."
    }
    else if lowercasedType.contains("лаб") {
        return "лаб."
    }
    
    return type
}
