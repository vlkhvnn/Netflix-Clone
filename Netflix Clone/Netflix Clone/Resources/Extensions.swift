//
//  Extensions.swift
//  Netflix Clone
//
//  Created by Alikhan Tangirbergen on 17.09.2023.
//

import Foundation

extension String {
    func capitilizeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
