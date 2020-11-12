import Foundation
import DeepAR

class DeepARVM : NSObject{
    
    var delegate : StoryDelegate?
    
    var pageTurnTimer = PageTurnTimer()
    
    var story : [[String]] = []
    
    var effects : [[String:Any]] = []
    
    var timer = Timer()
    var start = Date()

    private var currChapter : Int = 0
    private var currentPage : Int = 0
    
    var recording = false
    
    var currentMask : String?
    
    var currentPageText : String{
        get{
            
            return story[currChapter][currentPage]
        }
    }
    
    init(rawString:String) {
        super.init()
        rawToStory(raw: rawString)
    }
    
    func getPageTimes() -> [(Int, TimeInterval,Bool)] {
        return pageTurnTimer.pageAndTime
    }
    
    func rawToStory(raw:String) {
        let data: Data? = raw.data(using: .utf8)
        
        let json = (try? JSONSerialization.jsonObject(with: data!, options: [])) as? [String:AnyObject]
        
        if let content = json {
            story = content["content"] as! [[String]]
        }
    }
    
    func tappedRecord() {
        if recording {
            pageTurnTimer.turnNextPageTapped(newPage: currentPage)
        }else{
            pageTurnTimer.initialise(page: currentPage)
            turnedPage()
        }
    }
    
    func setChapter(_ chapter:Int) {
        currChapter = chapter
    }
    
    func nextPage() -> String{
        if currentPage < (story[currChapter].count - 1)  {
            currentPage += 1
            
            if recording {
                pageTurnTimer.turnNextPageTapped(newPage: currentPage)
            }
        }
        
        turnedPage()
        
        return currentPageText
    }
    
    func prevPage() -> String{
        if currentPage > 0 {
            currentPage -= 1
            
            if recording {
                pageTurnTimer.turnPrevPageTapped(newPage: currentPage)
            }
        }
        
        turnedPage()
        
        return currentPageText
    }
    
    func setCurrentMask(){
        
        for item in effects {
            
            guard let pageNumbers = item["page"] as? [Int] else {return}
            
            pageNumbers.forEach { (pageNumber) in
                if currentPage == pageNumber {
                    currentMask = item["effect"] as! String
                }
            }
        }
    }
    
    func turnedPage() {
        setCurrentMask()
        delegate?.changedPage(index: currentPage, totalPages: story[0].count)
    }
    
    func invalidateTimer() {
        timer.invalidate()
    }
    
    func startTimer() {
        start = Date()
        //Timer is for visual timer at top of screen
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(fire), userInfo: nil, repeats: true)

        
    }
    
 
    @objc private func fire()
    {
        let currentTime = Date()
        let interval = currentTime.timeIntervalSince(start)
        let formatted = stringFromTimeInterval(interval: interval)
        delegate?.timerAddedSecond(formatted: formatted)
    }
    
    func stringFromTimeInterval(interval: TimeInterval) -> String {
        let interval = Int(interval)
        let seconds = interval % 60
        let minutes = (interval / 60) % 60
        let hours = (interval / 3600)
        return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
    }
}



protocol StoryDelegate {
    func changedPage(index:Int, totalPages: Int)
    func timerAddedSecond(formatted:String)
}

let dummyData = ["Spotty the Hyena is very sad, he has lost his laugh. ","""
Please help me find my laugh", said Spotty.
"I can't find a laugh up here" replied Giraffe.
"""]
