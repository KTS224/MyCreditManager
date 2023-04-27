//
//  main.swift
//  MyCreditManager
//
//  Created by 김태성 on 2023/04/26.
//

import Foundation


struct Student {
    var name: String
    var subjects: [String: String] = [:]    // ex) [Swift: A+]
    var score: Double = 0                   // 점수의 총합
}

var students: [Student] = []

while true {
    print("원하는 기능을 입력해주세요")
    print("1: 학생추가, 2: 학생삭제, 3: 성적추가(변경), 4: 성적삭제, 5: 평점보기, X: 종료")

    var input = readLine()!

    // MARK: - 학생 추가
    if input == "1" {
        print("추가할 학생의 이름을 입력해주세요")
        input = readLine()!
        
        if checkWhiteSpaces(input) {
            print("입력이 잘못되었습니다. 다시 확인해주세요.")
            continue
        }
        
        var isDuplicated: Bool = false

        students.forEach { student in
            if student.name == input {
                isDuplicated = true
            }
        }

        if isDuplicated {
            print("\(input)은 이미 존재하는 학생입니다. 추가하지 않습니다.")
        } else {
            students.append(Student(name: input))
            print("\(input) 학생을 추가했습니다.")
        }
        continue
    }

    // MARK: - 학생 삭제
    if input == "2" {
        print("삭제할 학생의 이름을 입력해주세요")
        input = readLine()!
        var isExist: Bool = false
        var studentLocation = 0

        for i in 0..<students.count {
            if students[i].name == input {
                print("\(input) 학생을 삭제하였습니다.")
                isExist = true
                studentLocation = i
                break
            }
        }

        if isExist {
            students.remove(at: studentLocation)
        } else {
            print("\(input) 학생을 찾지 못했습니다.")
        }
        continue
    }

    // MARK: - 성적 추가
    if input == "3" {
        print("성적을 추가할 학생의 이름, 과목 이름, 성적(A+, A, F 등)을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력예) Mickey Swift A+")
        print("만약에 학생의 성적 중 해당 과목이 존재하면 기존 점수가 갱신됩니다.")
        let inputt = readLine()!.split(separator: " ").map{ $0 }
        if inputt.count != 3 {
            print("입력이 잘못 되었습니다. 다시 확인해주세요.")
        } else {
            let name = String(inputt[0])
            let subject = String(inputt[1])
            let grade = String(inputt[2])
            
            guard checkCorrectName(input: name) && checkCorrectGrade(input: grade) else {
                print("입력이 잘못 되었습니다. 다시 확인해주세요.")
                continue
            }

            for i in 0..<students.count {
                if students[i].name == name {
                    if students[i].subjects[subject] != nil { // 기존 성적이 있을 경우
                        students[i].score -= changeGradeToScore(students[i].subjects[subject] ?? "") // 기존점수 제거
                    }
                    students[i].score += changeGradeToScore(grade)
                    students[i].subjects[subject] = grade
                    print("\(name) 학생의 \(subject) 과목이 \(grade)로 추가(변경)되었습니다.")
                    break
                }
            }
        }
        continue
    }

    // MARK: - 성적 삭제
    if input == "4" {
        print("성적을 삭제할 학생의 이름, 과목 이름을 띄어쓰기로 구분하여 차례로 작성해주세요.")
        print("입력예) Mickey Swift")
        let inputt = readLine()!.split(separator: " ").map{ $0 }
        if inputt.count != 2 {
            print("입력이 잘못 되었습니다. 다시 확인해주세요.")
        } else {
            let name = String(inputt[0])
            let subject = String(inputt[1])
            
            guard checkCorrectName(input: name) else {
                print("\(name) 학생을 찾지 못했습니다.")
                continue
            }
            
            guard checkCorrectName(input: name) && checkCorrentSubject(input: subject) else {
                print("입력이 잘못 되었습니다. 다시 확인해주세요.")
                continue
            }

            for i in 0..<students.count {
                if students[i].name == name {
                    students[i].score -= changeGradeToScore(students[i].subjects[subject] ?? "")
                    students[i].subjects[subject] = nil
                    print("\(name) 학생의 \(subject) 과목의 성적이 삭제되었습니다.")
                    break
                }
            }
        }
        continue
    }

    // MARK: - 평점 보기
    if input == "5" {
        print("평점을 알고싶은 학생의 이름을 입력해주세요")
        let name = readLine()!
        var isExist: Bool = false

        for i in 0..<students.count {
            if students[i].name == name {
                isExist = true

                for subject in students[i].subjects {
                    print("\(subject.key): \(subject.value)")
                }

                let score = round(students[i].score/Double(students[i].subjects.count) * 100) / 100
                // 소수점 지우기 4.0 -> 4 로 만들기 위해 처리
                if score.truncatingRemainder(dividingBy: 1) == 0 {
                    print("평점 : \(Int(score))")
                } else {
                    print("평점 : \(score)")
                }
                break
            }
        }
        
        if !isExist {
            print("\(name) 학생을 찾지 못했습니다.")
        }
        continue
    }

    if input == "X" {
        print("프로그램을 종료합니다...")
        break
    }
    
    print("뭔가 입력이 잘못되었습니다. 1~5 사이의 숫자 혹은 X를 입력해주세요.")
}

func changeGradeToScore(_ grade: String) -> Double {
    switch grade {
    case "A+":
        return 4.5
    case "A":
        return 4.0
    case "B+":
        return 3.5
    case "B":
        return 3.0
    case "C+":
        return 2.5
    case "C":
        return 2.0
    case "D+":
        return 1.5
    case "D":
        return 1.0
    default:
        return 0
    }
}

func checkWhiteSpaces(_ input: String) -> Bool {
    let afterTrim = input.trimmingCharacters(in: .whitespacesAndNewlines)
    
    if input == "" || input != afterTrim  { // 공백 입력 처리
        return true
    }
    
    return false
}

func checkCorrectName(input: String) -> Bool {
    for student in students {
        if student.name == input {
            return true
        }
    }
    
    return false
}

func checkCorrectGrade(input: String) -> Bool {
    let grades = ["A+", "A", "B+", "B", "C+", "C", "D+", "D", "F"]
    
    if grades.contains(input) {
        return true
    }
    
    return false
}

func checkCorrentSubject(input: String) -> Bool {
    for student in students {
        if student.subjects[input] != nil {
            return true
        }
    }
    
    return false
}
