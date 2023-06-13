//
//  ResultTableViewController.swift
//  TableViewMaster
//
//  Created by jhchoi on 2023/06/08.
//

import UIKit

class ResultTableViewController: UITableViewController {
    
    var weatherInfo: [String:Any]?
    
    // 테이블뷰에 넣으려면 키와 값을 분리해야 한다.
    var weatherKeys: [String] = []
    var weatherValues: [Any] = []
    
    var mainDict: [String: Any] = [:]
    var windDict: [String: Any] = [:]
    var weatherDict: [String: Any] = [:]
    var coordDict: [String: Any] = [:]
    
    @IBOutlet var myTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getWeatherKeyValue()
        myTableView.dataSource = self
        print(weatherInfo)
        print(mainDict)
        print(windDict)
        print(weatherDict)
        print(coordDict)
    }
    
    func getWeatherKeyValue() {
        if let weatherInfo = weatherInfo {
            for (key, value) in weatherInfo {
                // key와 value를 분리하여 사용
                weatherKeys.append(key)
                weatherValues.append(value)
            }
        }
        //print(weatherKeys)
        //print(weatherValues)
        //print(weatherInfo?[weatherKeys])
        
        // main의 값들을 딕셔너리로 변환
        if let dictionary = weatherInfo,
           let mainDictionary = dictionary["main"] as? [String: Any] {
            mainDict = mainDictionary
        }
        
        //
        if let dictionary = weatherInfo,
           let windDictionary = dictionary["wind"] as? [String: Any] {
            windDict = windDictionary
        }
        
        if let dictionary = weatherInfo,
           let weatherArray = dictionary["weather"] as? [Any],
           let weatherDictionary = weatherArray.first as? [String: Any] {
            var weatherValues: [String: Any] = [:]
                for (key, value) in weatherDictionary {
                    weatherValues[key] = value
                }
            weatherDict = weatherValues
        }
        
        if let dictionary = weatherInfo,
           let coordDictionary = dictionary["coord"] as? [String: Any] {
            coordDict = coordDictionary
        }
        
        
//        let nameDictionary = dictionary["name"] as? [String: Any],
//        let windDictionary = dictionary["wind"] as? [String: Any],
//        let weatherDictionary = dictionary["weather"] as? [String: Any],
//        let coordDictionary = dictionary["coord"] as? [String: Any]
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return weatherKeys.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        let sectionKey = weatherKeys[section] // 섹션의 이름을 가져옴
        
        // 섹션에 해당하는 데이터를 가져옴
        if sectionKey == "name" {
            return 1
        } else if sectionKey == "coord" {
            return coordDict.keys.count
        } else if sectionKey == "wind" {
            return windDict.keys.count
        } else if sectionKey == "weather" {
            return weatherDict.keys.count
        } else {
            return mainDict.keys.count
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        
        //cell.textLabel?.text = "\(value)"
        
        //            for i in 0...4 {
        //                if let array = weatherValues[i] as? String,
        //                   let dictionary = array.first as? [String: Any],
        //                   let id = dictionary["id"] as? Int,
        //                   let description = dictionary["description"] as? String {
        //                    cell.textLabel?.text = "\(description)"
        //                }
        //            }
        
        //        if let dictionary = weatherValues[indexPath.row] as? [String: Any] {
        //            cell.textLabel?.text = "\(dictionary)"
        //           }
        
        let sectionKey = weatherKeys[indexPath.section] // 섹션의 이름을 가져옴
        
        // 섹션에 해당하는 데이터를 가져옴
        if sectionKey == "name" {
            if let sectionData = weatherInfo?[sectionKey] {
                cell.textLabel?.text = "\(sectionData)"
            }
        } else if sectionKey == "coord" {
            // indexPath.row : [section, row]에서 row만 꺼낸 것
            if indexPath.row == 0 {
                if let lat = coordDict["lat"] as? Double {
                    cell.textLabel?.text = "위도 : \(lat)"
                }
            } else if indexPath.row == 1 {
                if let lon = coordDict["lon"] as? Double {
                    cell.textLabel?.text = "경도 : \(lon)"
                }
            }
        } else if sectionKey == "wind" {
            if indexPath.row == 0 {
                if let speed = windDict["speed"] as? Double {
                    cell.textLabel?.text = "풍속 : \(speed)"
                }
            } else if indexPath.row == 1 {
                if let deg = windDict["deg"] as? Int {
                    cell.textLabel?.text = "바람의 방향 : \(deg)"
                }
            }
        } else if sectionKey == "weather" {
            if indexPath.row == 0 {
                if let id = weatherDict["id"] as? Int {
                    cell.textLabel?.text = "id : \(id)"
                }
            } else if indexPath.row == 1 {
                if let main = weatherDict["main"] as? String {
                    cell.textLabel?.text = "주요 날씨 : \(main)"
                }
            } else {
                if let description = weatherDict["description"] as? String {
                    cell.textLabel?.text = "날씨 요약 : \(description)"
                }
            }
        } else {
            if indexPath.row == 0 {
                if let temp = mainDict["temp"] as? Double {
                    cell.textLabel?.text = "현재 온도 : \(temp)"
                }
            } else if indexPath.row == 1 {
                if let feelsLike = mainDict["feels_like"] as? Double {
                    cell.textLabel?.text = "체감 온도 : \(feelsLike)"
                }
            } else if indexPath.row == 2 {
                if let minTemp = mainDict["temp_min"] as? Double {
                    cell.textLabel?.text = "최저 기온 : \(minTemp)"
                }
            } else if indexPath.row == 3 {
                if let maxTemp = mainDict["temp_max"] as? Double {
                    cell.textLabel?.text = "최고 기온 : \(maxTemp)"
                }
            } else {
                if let humidity = mainDict["humidity"] as? Int {
                    cell.textLabel?.text = "습도 : \(humidity)"
                }
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        let sectionKey = weatherKeys[section]
        
        if sectionKey == "name" {
            return "지명"
        } else if sectionKey == "coord" {
            return "위치 정보"
        } else if sectionKey == "wind" {
            return "바람"
        } else if sectionKey == "weather" {
            return "날씨 정보"
        } else {
            return "온도 및 습도"
        }
        
        return sectionKey
    }
}
