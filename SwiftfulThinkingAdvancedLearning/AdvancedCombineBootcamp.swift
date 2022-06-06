//
//  AdvancedCombineBootcamp.swift
//  SwiftfulThinkingAdvancedLearning
//
//  Created by 안민수 on 2022/06/06.
//

import SwiftUI
import Combine

// PipeLine: DataService -> ViewModel -> View

class AdvancedCombineDataService {
    // how to making Publisher
//    @Published var basicPublisher: [String] = []
    @Published var basicPublisher: Int = 0
    // Holding current value so it need initial value.
    let currentValuePublisher = CurrentValueSubject<Int, Error>(0)
    // not holding current value so don't need initial value - efficient memory
    let passThroughPublisher = PassthroughSubject<Int, Error>()
    let boolPublisher = PassthroughSubject<Bool, Error>()
    let intPublisher = PassthroughSubject<Int, Error>()


    
    init() {
        publishFakeData() //<- API call
    }
    
    
    private func publishFakeData() {
        
        let items : [Int] = [1,2,3,4,5,6,7,8,9,10]
        
        for x in items.indices {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(x+1)) {
                //Async니까 1초간격..!
                self.basicPublisher = items[x]
                self.currentValuePublisher.send(items[x])
                self.passThroughPublisher.send(items[x])
                
                if (x > 4 && x < 8) {
                    self.boolPublisher.send(true)
                    self.intPublisher.send(999)
                } else {
                    self.boolPublisher.send(false)
                }
                // for .last(), 마지막 인덱스엘리먼트 컴플레션을 finished에 쏴준다.
                // 이거 안해주면, 다운스트림의 publisher는 업스트림의 어느부분이 라스트인지 몰라서 업스트림에서 못뽑아내고 계속 alive 하고있다.
                if x == items.indices.last {
                    self.currentValuePublisher.send(completion: .finished)
                    self.passThroughPublisher.send(completion: .finished)
                }
            }
        }
//
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//            self.basicPublisher = ["one","two","three"]
//        }
        
        //Practice Debounce
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0) {
//            self.passThroughPublisher.send(1)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.passThroughPublisher.send(2)
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
//            self.passThroughPublisher.send(3)
//        }
        
    }
}


class AdvancedCombineBootcampViewModel: ObservableObject {
    
    @Published var data : [String] = []
    @Published var data2 : [String] = []
    @Published var data2Bools : [Bool] = []

    @Published var data3 : [String] = []
    @Published var error : String = ""

    let dataService = AdvancedCombineDataService()
    
    var cancellables = Set<AnyCancellable>()
    var cancellables2 = Set<AnyCancellable>()
    var cancellables3 = Set<AnyCancellable>()


    init() {
        addSubsribers()
    }
    
    private func addSubsribers() {
        
        DispatchQueue.main.async { [self] in
            
            dataService.currentValuePublisher
                .map({ String($0) })
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): print("ERROR: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] returnedValue in
    //                self?.data = returnedValue
                    self?.data.append(returnedValue)
                }
                .store(in: &cancellables)
            
                
//            dataService.passThroughPublisher
            
                // Sequence Operations
                /*
                // first(): get first element and publish it!
                //          handling condition by using closure in where
                /*
                .first(where: {$0 > 4})
                .tryFirst(where: { int in
                    if int == 3 {
                        // throw 발생하면 중단됨.
                        throw URLError(.badServerResponse)
                    }

                    // erorr 전에 구독이 되면 에러 throw 안함
                    return int > 1
                })
                */
            
                // last(): get last element and publish it!
                //         handling condition by using closure in where
                //         마지막 completion subscribe한 시점에 라스트값 판정해줌 : 10까지 보고 3
                /*
                .last(where: {$0 < 4})
                .tryLast(where: { int in
                    if int == 4 {
                        // last 되기전에 error throw하면 루프 깨짐
                        throw URLError(.badServerResponse)
                    }
                    // no error 시 10까지 보고 3
                    return int < 7
                })
                */
            
                // dropfirst() : 첫번째 값 버린다. (initial 값이든 아니든 무조건 첫번째 value)
                //              @Published나 Current의 "" 값 날릴때 좋음
                //               cnt 입력하면 처음부터 몇개 날릴수 있음.
                /*
                    .dropFirst(3)
                    // 클로저 판정이 true 되는 조건이면 계속 드랍함. false된 순서 이후는 드랍안함.
                    .drop(while: { $0 < 5 } )
                
                    // 마찬가지로 throw 먼저되면 루프 깨짐, 반대로 drop이 먼저 풀리면 throw 안던짐.
                    .tryDrop(while: { int in
                        if int == 5 {
                            throw URLError(.badServerResponse)
                        }

                        return int < 8
                    })
                */
            
                // prefix() : max length of republish elements
                /*
                .prefix(4)
                // false되면 루프 종료
                .prefix(while: { $0 < 5 })
                .tryPrefix(while: )
                 */
            
                // output() : at: index / in: range로 value값 추적
                /*
                    .output(at: 6)
                    .output(in: 2..<4)
                */
                */
            
                // Mathematic Operations
                /*
                    .max()
                    .max(by: { int1, int2 in
                        return int1 < int2
                    })
                    .tryMax(by: { int1, int2 in
                        return int1 < int2
                    })
                    .min()
                    .min(by: )
                    .tryMin(by: )
                */
            
                // Map / Filter / Reducing Operations
                /*
    //                .map({ String($0) })
    //                .tryMap({ int in
    //                    if int == 5 {
    //                        throw URLError(.badServerResponse)
    //                    }
    //                    return String(int)
    //                })
                    // compactMap은 뭔가 작동안할때 무시해버리고 루프 진행해서 쓰기편함.
    //                .compactMap({ int in
    //                    if int == 5 {
    //                        return nil
    //                    }
    //                    return String(int)
    //                })
    //                .tryCompactMap()
    //                .filter({($0 > 3) && ($0 < 7)})
    //                .tryFilter()
                    // 같은 value가 'back to back'으로 퍼블리싱되면 Duplicate로 인식하고 하나를 지운다.
    //                .removeDuplicates()
    //                .removeDuplicates(by: { int1, int2 in
    //                    return int1 == int2
    //                })
    //                .tryRemoveDuplicates(by: )
                    // nil이 퍼블리싱되면 입력값으로 바꿔준다.
    //                .replaceNil(with: 5)
                    // Eampty array 를 입력값으로 바꿔준다.
    //                .replaceEmpty(with: 5)
    //                .replaceError(with: "Default Value")
                    // 이전까지 계산된 값(이전에 퍼블리싱되어 return 까지 된 값) + 새로 퍼블리싱 된 값
    //                .scan(0, { existingValue, newValue in
    //                    return existingValue + newValue
    //                })
    //                .scan(0,{$0 + $1})
    //                .scan(0, +)
    //                .tryScan()
                    // 리듀스는 스캔과 비슷하나, 루프끝날때까지 리퍼블리싱 하지 않는다. 모든 퍼블리싱된값이 single value로 리퍼블리싱 된다.
    //                .reduce(0, { existingValue, newValue in
    //                    return existingValue + newValue
    //                })
    //                .reduce(0, +)
                    // collect all publishes and then publish them at once
                    // Publishs 들이 끝날때까지 기다렸다가, 한번에 [1~10] 어레이를 쏴준다.
                    // cnt: 매개변수로 기다려주는 단위도 설정 가능
    //                .collect()
    //                .collect(3)

                    // '모든' 퍼블리셔들이 만족하냐?(end loop까지 봄) true or false
    //                .allSatisfy({$0 < 50})
    //                .tryAllSatisfy()
                */
            
                // Timing Operations
                /*
                // debounce is super common for working with textfields
                // 디바운스는 업스트림의 퍼블리셔들을 보고있는다. 첫 퍼블리셔 구독 후부터 입력시간 사이에 퍼블리셔또 들어오면 나중값으로 리퍼블리싱 한다.
//                .debounce(for: 0.75, scheduler: DispatchQueue.main)
                // 2초씩 늦춰서 퍼블리셔들을 리퍼블리싱함(타임버퍼)
//                .delay(for: 2, scheduler: DispatchQueue.main)
                //퍼블리셔들 간의 시간간격, 아래 맵하고 세트.
//                .measureInterval(using: DispatchQueue.main)
//                .map({ stride in
//                    return "\(stride.timeInterval)"
//                })
            
                // open and close for a time, 10초마다 퍼블리셔를 받아 리퍼블리싱함.(리로드)
//                .throttle(for: 10, scheduler: DispatchQueue.main, latest: true)
                // 에러가나면 3번까지 리트라이 해봐라, 그리고 문제없으면 진행!
//                .retry(3)
                // 0.75초 안에 퍼블리싱 안되면 타임아웃이다. 끝낸다.
//                .timeout(2, scheduler: DispatchQueue.main)
                */
            
                // Multiple Publishers - Subscriber
                /*
                // 멀티플 퍼블리셔는 컴팩트맵을 써줘야함! 컴플레션이 2개!
                // 두개의 퍼블리싱이 '시작'되지 않으면 밑에 구문으로 진입안함.
                // 이때문에 currentsubject를 쓰는게 다루기 편함 (이니셜라이즈 하자마자 emit 함)
                // 다운로드등 딜레이 의도하고 싶으면 passthrougsubject 사용!
//                .combineLatest(dataService.boolPublisher, dataService.intPublisher)
//                .compactMap({ (int, bool) in
//                    if bool {
//                        return String(int)
//                    }
//                    return nil
//
//                })
                // 축약형: 1번째 퍼블리셔 $0 , 2번째 퍼블리셔 $1 로 친다.
//                .compactMap({ $1 ? String($0) : "n/a" })
//                .compactMap({ (int1, bool, int2) in
//                    if bool {
//                        return "\(int1) + \(int2)"
//                    }
//                    return "n/a"
//                })
                // 위에서 한x 루프에 int/bool 각각 send를 해주므로 같은숫자 2개나올수 있음
//                .removeDuplicates()
                // 머지: 퍼블리셔끼리 머지한다. 결과보면 같은 섭스크라이버에 넣어준다. 그래서 타입 맞아야함
//                .merge(with: dataService.intPublisher)
                //  zip은 마치 컴팩트맵처럼 하나로 퍼블리셔들을 모아주는데, 모든퍼블리셔들이 다 들어와야 한 튜블이 나간다. 컴팩트맵과 달리 집은 퍼블리셔가 다 들어와야 리퍼블리싱함.
//                .zip(dataService.boolPublisher, dataService.intPublisher)
//                .map({ tuple in
//                    return String(tuple.0) + tuple.1.description + String(tuple.2)
//                })
                
                // catch는 에러난이후부터 다른 퍼블리셔를 구독하게해서 아래 구문이 이어지게 한다.
//                .tryMap({ int in
//                    if int == 5 {
//                    throw URLError(.badServerResponse)
//                    }
//                    return   int
//                })
//                .catch({ error in
//                    return self.dataService.intPublisher
//                })
                */
            
            
//            dataService.passThroughPublisher
//                .map({ String($0) })
//                .sink { completion in
//                    switch completion {
//                    case .finished:
//                        break
//                    case .failure(let error):
//                        self.error = "ERROR: \(error.localizedDescription)"
//                        print("ERROR: \(error.localizedDescription)")
//                    }
//                } receiveValue: { [weak self] returnedValue in
////                    self?.data2 = returnedValue
////                    self?.data2.append(contentsOf: returnedValue)
//                    self?.data2.append(returnedValue)
//
//                }
//                .store(in: &cancellables2)
            
            
            // ReceiveValue를 share하는법 (다른 viewModel or view 등...)
            // share
            let sharedPublisher = dataService.passThroughPublisher
//                .dropFirst(3)
                .share()
                // 위에 share 필수! , 밑에 .connect() 확인
                .multicast {
                    PassthroughSubject<Int,Error>()
                }
            
            sharedPublisher
                .map({ String($0) })
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.error = "ERROR: \(error.localizedDescription)"
                        print("ERROR: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] returnedValue in
//                    self?.data2 = returnedValue
//                    self?.data2.append(contentsOf: returnedValue)
                    self?.data2.append(returnedValue)
                    
                }
                .store(in: &cancellables2)
            
            
            
            
            
            // 별도로 share 하는법은 그냥 따로 섭스크립 구문 적어주면 된다.
            sharedPublisher
                .map({ $0 > 5 ? true : false })
                .sink { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let error):
                        self.error = "ERROR: \(error.localizedDescription)"
                        print("ERROR: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] returnedValue in
                    self?.data2Bools.append(returnedValue)
                }
                .store(in: &cancellables2)
            
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                sharedPublisher
                    // 5초후부터 shared가 커넥팅된다. 멀티플 섭스크라이버즈 쓸때 활용 가능
                    .connect()
                    .store(in: &cancellables2)
            }
            
            dataService.$basicPublisher
                .map({ String($0) })
                .sink { completion in
                    switch completion {
                    case .finished: break
                    case .failure(let error): print("ERROR: \(error.localizedDescription)")
                    }
                } receiveValue: { [weak self] returnedValue in
                    self?.data3.append(returnedValue)
                }
                .store(in: &cancellables3)
        
        }
    }
    
}

struct AdvancedCombineBootcamp: View {
    
    @StateObject private var vm = AdvancedCombineBootcampViewModel()
    
    var body: some View {
        ScrollView {
            VStack {
                
                if !vm.error.isEmpty {
                    Text("ERROR:\(vm.error)")
                }
                
                HStack {
                    VStack{
                        ForEach(vm.data, id: \.self) {
                            Text($0)
                                .font(.largeTitle)
                                .fontWeight(.black)
                        }
                    }
                    Divider()
                    
                    
                    
                    HStack {
                        VStack {
                            ForEach(vm.data2, id: \.self) {
                                Text($0)
                                    .font(.largeTitle)
                                    .fontWeight(.black)
                            }
                        }
                        VStack {
                            ForEach(vm.data2Bools, id: \.self) {
                                Text($0.description)
                                    .font(.largeTitle)
                                    .fontWeight(.black)
                            }
                        }
                    }
                    
                    
                    
                    
                    Divider()
                    VStack{
                        ForEach(vm.data3, id: \.self) {
                            Text($0)
                                .font(.largeTitle)
                                .fontWeight(.black)
                        }
                    }
                }
            }
        }
    }
}

struct AdvancedCombineBootcamp_Previews: PreviewProvider {
    static var previews: some View {
        AdvancedCombineBootcamp()
    }
}
