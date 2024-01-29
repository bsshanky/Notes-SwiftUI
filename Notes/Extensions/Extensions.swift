//
//  Extensions.swift
//  Notes
//
//  Created by Shashank  on 1/27/24.
//

import Foundation
import SwiftUI

// MARK: View

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

