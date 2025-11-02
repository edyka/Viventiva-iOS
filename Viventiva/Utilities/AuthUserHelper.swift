//
//  AuthUserHelper.swift
//  Viventiva
//
//  Helper extensions for Supabase AuthUser
//

import Foundation
import Supabase

extension AuthUser {
    /// Converts AuthUser ID to String format compatible with database
    var userIdString: String {
        // AuthUser.id is typically a UUID, but we need it as String
        // Handle both UUID and String representations
        if let uuid = id as? UUID {
            return uuid.uuidString
        }
        return String(describing: id)
    }
}

