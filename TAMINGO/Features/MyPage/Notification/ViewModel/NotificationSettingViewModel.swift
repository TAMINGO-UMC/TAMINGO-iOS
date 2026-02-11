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
    
    // 로딩 상태 (UI 표시용)
    private var isFetching: Bool = false
    
    // 서버와 동기화된 마지막 설정값 (비교용)
    private var lastSyncedSettings: NotificationSettingResult?
    
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
        setupPipeline()
    }
    
    // MARK: - Combine Setup
    private func setupPipeline() {
        updateSubject
            .debounce(for: .seconds(1), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                self?.requestUpdateAPI()
            }
            .store(in: &cancellables)
    }

    // MARK: - Public Methods
    
    func dispatchUpdate() {
        // fetch 중에는 업데이트 방지
        guard !isFetching else { return }
        updateSubject.send()
    }

    func fetchSettings() {
        isFetching = true
        provider.request(.getNotificationSettings) { [weak self] result in
            guard let self = self else { return }
            
            // 로딩 종료 (응답 오면 바로 종료)
            defer { self.isFetching = false }
            
            if case .success(let response) = result {
                if let decoded = try? response.map(BaseResponse<NotificationSettingResult>.self),
                   let res = decoded.result {
                    
                    // UI 업데이트
                    self.departureAlertEnabled = res.departureAlertEnabled
                    self.departureAlertMinutes = ArrivalBufferType(rawValue: res.departureLeadMinutes) ?? .ten
                    self.latenessRiskAlertEnabled = res.latenessRiskAlertEnabled
                    self.realtimeTransitEnabled = res.realtimeTransitEnabled
                    self.todoRecommendEnabled = res.todoProposalEnabled
                    self.locationMoveCheckEnabled = res.locationMoveCheckEnabled
                    
                    // 마지막 동기화 데이터 저장 (fetch 시점의 기준점)
                    self.lastSyncedSettings = res
                }
            }
        }
    }
    
    // MARK: - Private API Call
    private func requestUpdateAPI() {
        // 현재 UI 상태를 기반으로 요청 객체 생성
        let request = NotificationSettingResult(
            departureAlertEnabled: departureAlertEnabled,
            departureLeadMinutes: departureAlertMinutes.rawValue,
            latenessRiskAlertEnabled: latenessRiskAlertEnabled,
            realtimeTransitEnabled: realtimeTransitEnabled,
            todoProposalEnabled: todoRecommendEnabled,
            locationMoveCheckEnabled: locationMoveCheckEnabled
        )
        
        // 변경 사항 확인: 마지막으로 동기화된 값과 현재 요청값이 같으면 API 호출 중단
        guard request != lastSyncedSettings else { print("중단"); return }
        
        provider.request(.updateNotificationSettings(request: request)) { [weak self] result in
            switch result {
            case .success:
                // 성공 시 기준점(lastSyncedSettings)을 현재 요청값으로 업데이트
                print("update")
                self?.lastSyncedSettings = request
                
            case .failure(let error):
                print("\(error.localizedDescription)")
            }
        }
    }
}
