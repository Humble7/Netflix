//
//  Extensions.swift
//  Netflix Clone
//
//  Created by ChenZhen on 22/1/23.
//

import Foundation

extension String {
    func captializeFirstLetter() -> String {
        return self.prefix(1).uppercased() + self.lowercased().dropFirst()
    }
}
