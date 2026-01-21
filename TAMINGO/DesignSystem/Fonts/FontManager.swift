//
//  FontManager.swift
//  TAMINGO
//
//  Created by 김도연 on 1/17/25.
//

import SwiftUI

extension Font {
    public enum Pretendard {
        case semibold
        case medium
        case regular
        case bold
        case extraBold
        case light
        case custom(String)
        
        var value: String {
            switch self {
            case .semibold:
                return "Pretendard-SemiBold"
            case .medium:
                return "Pretendard-Medium"
            case .regular:
                return "Pretendard-Regular"
            case .bold:
                return "Pretendard-Bold"
            case .extraBold:
                return "Pretendard-ExtraBold"
            case .light:
                return "Pretendard-Light"
            case .custom(let name):
                return name
            }
        }
    }
    
    static func pretendard(_ type: Pretendard, size: CGFloat = 17) -> Font {
        return .custom(type.value, size: size)
    }
    
    // MARK: - ExtraBold
    static var extraBold24: Font { .pretendard(.extraBold, size: 24) }
    
    // MARK: - Bold
    static var bold18: Font { .pretendard(.bold, size: 18) }
    static var bold22: Font { .pretendard(.bold, size: 22) }
    static var bold24: Font { .pretendard(.bold, size: 24) }
    
    // MARK: - SemiBold
    static var semiBold38: Font { .pretendard(.semibold, size: 38) }
    static var semiBold24: Font { .pretendard(.semibold, size: 24) }
    static var semiBold18: Font { .pretendard(.semibold, size: 18) }
    static var semiBold16: Font { .pretendard(.semibold, size: 16) }
    static var semiBold14: Font { .pretendard(.semibold, size: 14) }
    static var semiBold13: Font { .pretendard(.semibold, size: 13) }
    static var semiBold12: Font { .pretendard(.semibold, size: 12) }
    
    // MARK: - Regular
    static var regular20: Font { .pretendard(.regular, size: 20) }
    static var regular18: Font { .pretendard(.regular, size: 18) }
    static var regular13: Font { .pretendard(.regular, size: 13) }
    static var regular12: Font { .pretendard(.regular, size: 12) }
    static var regular10: Font { .pretendard(.regular, size: 10) }
    static var regular09: Font { .pretendard(.regular, size: 9) }
    
    // MARK: - Medium
    static var medium18: Font { .pretendard(.medium, size: 18) }
    static var medium16: Font { .pretendard(.medium, size: 16) }
    static var medium14: Font { .pretendard(.medium, size: 14) }
    static var medium12: Font { .pretendard(.medium, size: 12) }
    static var medium13: Font { .pretendard(.medium, size: 13) }
    static var medium12: Font { .pretendard(.medium, size: 12) } // 추가
    static var medium10: Font { .pretendard(.medium, size: 10) }
    static var medium8: Font { .pretendard(.medium, size: 8) }
    
    // MARK: - Light
    static var light14: Font { .pretendard(.light, size: 14) }
}
