//
//  AIInferenceResult.swift
//  TAMINGO
//
//  Created by Claude on 2/5/26.
//

import Foundation

struct AIInferenceResult {
    let category: String
    let placeName: String?
    let address: String?
    let latitude: Double?
    let longitude: Double?
    let duration: Int  // 분 단위
    
    /// UI 표시용 장소 문자열
    var locationDisplay: String {
        placeName ?? "장소 미지정"
    }
    
    /// UI 표시용 시간 문자열 ("1시간 10분" 형식)
    var durationDisplay: String {
        let hours = duration / 60
        let minutes = duration % 60
        
        if hours > 0 && minutes > 0 {
            return "\(hours)시간 \(minutes)분"
        } else if hours > 0 {
            return "\(hours)시간"
        } else {
            return "\(minutes)분"
        }
    }
}
