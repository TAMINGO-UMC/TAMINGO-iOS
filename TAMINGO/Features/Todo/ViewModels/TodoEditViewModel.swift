
import SwiftUI
import Moya

@Observable
class TodoEditViewModel {
    var title: String
    var selectedDate: Date?
    var placeName: String
    var address: String?
    var latitude: Double?
    var longitude: Double?
    var duration: String
    var category: String
    var relatedSchedules: [TodoRelatedScheduleItem]
    var isRoutineEnabled: Bool
    var selectedRoutine: TodoRoutineType
    var routineEndDate: Date
    var hasEndDate: Bool
    
    var isLocationAIGenerated: Bool
    var isDurationAIGenerated: Bool
    var isCategoryAIGenerated: Bool
    var isScheduleAIGenerated: Bool
    
    var showingDatePicker: Bool = false
    var isLocationExpanded: Bool = false
    var locationSearchText: String = ""
    var showingDurationPicker: Bool = false
    var isScheduleExpanded: Bool = false
    
    // Duration picker values
    var selectedHour: Int = 1
    var selectedMinute: Int = 0
    var durationDate: Date = Date()
    
    // 내 장소 목록
    var myLocations: [TodoMyLocation] = []
    
    // 자주 가는 장소 추천 여부
    var isFavoriteRecommendation: Bool = false
    
    // Moya Provider
    private let provider = MoyaProvider<TodoTarget>(
        stubClosure: MoyaProvider.delayedStub(0.5),
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
    )
    
    // 날짜 표시 문자열
    var formattedDate: String {
        guard let date = selectedDate else {
            return "- - - -, - -, - -"
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: date)
    }
    
    // MARK: - init
    init(item: TodoItem) {
        self.title = item.title
        self.selectedDate = item.date
        
        self.placeName = item.placeName ?? ""
        self.address = item.address
        self.latitude = item.latitude
        self.longitude = item.longitude
        self.isLocationAIGenerated = (item.placeName == nil)
        
        self.duration = TodoEditViewModel.formatDuration(minutes: item.estimatedMinutes)
        self.isDurationAIGenerated = (item.estimatedMinutes == nil)
        
        self.category = item.category
        self.isCategoryAIGenerated = item.category.isEmpty
        
        // 관련 일정: item에 저장된 것 사용
        self.relatedSchedules = item.relatedSchedules
        
        // 루틴: item에서 복원
        self.isRoutineEnabled = item.isRoutineEnabled
        self.selectedRoutine = item.routineType
        self.hasEndDate = item.routineEndDate != nil
        self.routineEndDate = item.routineEndDate
            ?? Calendar.current.date(byAdding: .month, value: 1, to: Date())
            ?? Date()
        
        self.isScheduleAIGenerated = true
        self.isFavoriteRecommendation = false
        
        parseDuration()
        
        var components = DateComponents()
        components.hour = selectedHour
        components.minute = selectedMinute
        self.durationDate = Calendar.current.date(from: components) ?? Date()
        
        // 자주 가는 장소 로드
        loadFrequentPlaces()
    }
    
    // MARK: - 자주 가는 장소 로드 (Moya Provider 방식)
    func loadFrequentPlaces() {
        provider.request(.getFrequentPlaces) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decodedData = try filteredResponse.map(BaseResponse<FrequentPlacesResponseDTO>.self)
                    
                    if let places = decodedData.result?.places {
                        self.myLocations = places.map { $0.toTodoMyLocation() }
                    }
                } catch {
                    print("자주 가는 장소 로드 실패: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("자주 가는 장소 네트워크 오류: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - 장소 선택 시 관련 할일 조회 (Moya Provider 방식)
    func selectPlace(name: String, address: String, latitude: Double, longitude: Double) {
        self.placeName = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.isLocationAIGenerated = false
        
        // 관련 할일 조회
        let requestDTO = RelatedTodosRequestDTO(
            placeName: name,
            latitude: latitude,
            longitude: longitude
        )
        
        provider.request(.getRelatedTodos(body: requestDTO)) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                do {
                    let filteredResponse = try response.filterSuccessfulStatusCodes()
                    let decodedData = try filteredResponse.map(BaseResponse<RelatedTodosResponseDTO>.self)
                    
                    if let resultData = decodedData.result {
                        // 근처 할일과 후보 할일을 relatedSchedules에 추가
                        let nearbyItems = resultData.nearbyTodos.map { todo in
                            TodoRelatedScheduleItem(
                                title: todo.title,
                                location: todo.placeName ?? "",
                                isSelected: false,
                                scheduleId: nil
                            )
                        }
                        let candidateItems = resultData.candidateTodos.map { todo in
                            TodoRelatedScheduleItem(
                                title: todo.title,
                                location: todo.placeName ?? "",
                                isSelected: false,
                                scheduleId: nil
                            )
                        }
                        
                        // 기존 일정 유지하면서 할일 추가
                        self.relatedSchedules = self.relatedSchedules + nearbyItems + candidateItems
                        self.isFavoriteRecommendation = resultData.isFavoriteRecommendation
                    }
                } catch {
                    print("관련 할일 조회 파싱 오류: \(error.localizedDescription)")
                }
                
            case .failure(let error):
                print("관련 할일 조회 네트워크 오류: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - duration 파싱
    func parseDuration() {
        guard !duration.isEmpty else { return }
        for component in duration.components(separatedBy: " ") {
            if component.contains("시간"),
               let hour = Int(component.replacingOccurrences(of: "시간", with: "")) {
                selectedHour = hour
            } else if component.contains("분"),
                      let minute = Int(component.replacingOccurrences(of: "분", with: "")) {
                selectedMinute = minute
            }
        }
    }
    
    // MARK: - 저장
    func saveChanges(to item: inout TodoItem) {
        item.title = title
        item.date = selectedDate
        item.placeName = placeName
        item.address = address
        item.latitude = latitude
        item.longitude = longitude
        item.category = category
        item.estimatedMinutes = parsedTotalMinutes
        item.relatedSchedules = relatedSchedules.filter { $0.isSelected }
        
        // 선택된 일정 중 첫 번째를 linkedScheduleId로 설정
        item.linkedScheduleId = relatedSchedules.first(where: { $0.isSelected })?.scheduleId
        
        // 루틴 저장
        item.isRoutineEnabled = isRoutineEnabled
        item.routineType = selectedRoutine
        item.routineEndDate = hasEndDate ? routineEndDate : nil
    }
    
    // MARK: - 헬퍼
    private var parsedTotalMinutes: Int {
        return selectedHour * 60 + selectedMinute
    }
    
    static func formatDuration(minutes: Int?) -> String {
        guard let minutes = minutes, minutes > 0 else {
            return "1시간 10분"  // AI 기본값
        }
        let h = minutes / 60
        let m = minutes % 60
        if h > 0 && m > 0 { return "\(h)시간 \(m)분" }
        if h > 0 { return "\(h)시간" }
        return "\(m)분"
    }
}
