//
//  NotificationSettingViewModel.swift
//  TAMINGO
//
//  Created by 권예원 on 1/25/26.
//

import Foundation
import Moya
import Observation
import Combine

@Observable
final class NotificationSettingViewModel {
    private let provider = MoyaProvider<NotificationTarget>()
    
    // UI 상태값
    var departureAlertEnabled: Bool = false
    var departureAlertMinutes: ArrivalBufferType = .ten
    var latenessRiskAlertEnabled: Bool = false
    var realtimeTransitEnabled: Bool = false
    var todoRecommendEnabled: Bool = false
    var locationMoveCheckEnabled: Bool = false
    
    // Combine
    private var cancellables = Set<AnyCancellable>()
    
    // 변경 사항을 흘려보낼 파이프라인
    private let updateSubject = PassthroughSubject<Void, Never>()
    
    // 초기 로딩 상태 관리
    private var isFetching: Bool = false
    
    var currentSettings: [AnyHashable] {
        [
            departureAlertEnabled,
            departureAlertMinutes,
            latenessRiskAlertEnabled,
            realtimeTransitEnabled,
            todoRecommendEnabled,
            locationMoveCheckEnabled
        ]
    }

    init() {
        // Combine 파이프라인 설정
        setupPipeline()
    }
    
    // MARK: - Combine Setup
    private func setupPipeline() {
        updateSubject
            // 0.5초 동안 추가 입력이 없으면 실행
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            // 중복된 요청 제거
            .sink { [weak self] _ in
                self?.requestUpdateAPI()
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods
    
    // View에서 값이 바뀔 때 호출할 메서드
    func dispatchUpdate() {
        // 데이터 로딩 중이 아닐 때만 신호 보냄
        guard !isFetching else { return }
        updateSubject.send()
    }

    func fetchSettings() {
        isFetching = true
        provider.request(.getNotificationSettings) { [weak self] result in
            guard let self = self else { return }
            
            if case .success(let response) = result {
                if let decoded = try? response.map(BaseResponse<NotificationSettingResult>.self) {
                    if let res = decoded.result {
                        self.departureAlertEnabled = res.departureAlertEnabled
                        self.departureAlertMinutes = ArrivalBufferType(rawValue: res.departureLeadMinutes) ?? .ten
                        self.latenessRiskAlertEnabled = res.latenessRiskAlertEnabled
                        self.realtimeTransitEnabled = res.realtimeTransitEnabled
                        self.todoRecommendEnabled = res.todoProposalEnabled
                        self.locationMoveCheckEnabled = res.locationMoveCheckEnabled
                    }
                }
            }
            
            // 약간의 딜레이 후 페칭 상태 해제 (초기 로딩 시 update 트리거 방지)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.isFetching = false
            }
        }
    }
    
    // MARK: - Private API Call
    private func requestUpdateAPI() {
        let request = NotificationSettingResult(
            departureAlertEnabled: departureAlertEnabled,
            departureLeadMinutes: departureAlertMinutes.rawValue,
            latenessRiskAlertEnabled: latenessRiskAlertEnabled,
            realtimeTransitEnabled: realtimeTransitEnabled,
            todoProposalEnabled: todoRecommendEnabled,
            locationMoveCheckEnabled: locationMoveCheckEnabled
        )
        
        provider.request(.updateNotificationSettings(request: request)) { result in
            switch result {
            case .success:
                print("설정 업데이트 완료")
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}
