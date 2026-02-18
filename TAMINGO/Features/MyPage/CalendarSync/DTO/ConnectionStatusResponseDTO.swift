//
//  ConnectionStatusResponseDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 2/12/26.
//

import Foundation


struct ConnectionStatusResponseDTO : Codable{
    let enabled: Bool
        let status: String   // ACTIVE / INACTIVE
        let lastSyncedAt: String?
}
