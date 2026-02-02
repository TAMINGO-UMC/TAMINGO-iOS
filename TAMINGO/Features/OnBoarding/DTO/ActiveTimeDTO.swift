//
//  ActiveTimeDTO.swift
//  TAMINGO
//
//  Created by 권예원 on 1/31/26.
//

struct ActiveTimeDTO: Encodable {
    let startTime: String
    let endTime: String
}

extension ActiveTime {
    func toDTO() -> ActiveTimeDTO {
        ActiveTimeDTO(
            startTime: startTime.toString(format: "HH:mm"),
            endTime: endTime.toString(format: "HH:mm")
        )
    }
}
