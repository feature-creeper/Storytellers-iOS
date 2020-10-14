import Foundation
import DeepAR

class StoryText : NSObject{
    
    var delegate : StoryDelegate?
    
    var pageTurnTimer = PageTurnTimer()
    
    var story : [[String]] = []
//
//    private var deepAR: DeepAR!
//
    private var currChapter : Int = 0
    private var currentPage : Int = 0
    
    var recording = false
    
    var currentPageText : String{
        get{
            
            let totalChapters = story.count - 1
            
            if currChapter == 0 && currentPage == 0 {
                delegate?.onFirstPage()
            } else if currChapter == totalChapters && currentPage == (story[totalChapters].count - 1) {
                delegate?.onLastPage()
            } else {
                delegate?.onMiddlePage()
            }
            
            return story[currChapter][currentPage]
        }
    }
    
    init(rawString:String) {
        super.init()
        rawToStory(raw: rawString)
//        self.deepAR = deepAR
        
    }
    
    func getPageTimes() -> [(Int, Int)] {
        return pageTurnTimer.couplet
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
            pageTurnTimer.turnPageTapped(newPage: currentPage)
        }else{
            pageTurnTimer.initialise(page: currentPage)
        }
    }
    
    func setChapter(_ chapter:Int) {
        currChapter = chapter
    }
    
    func nextPage() -> String{
        if currentPage < (story[currChapter].count - 1)  {
            currentPage += 1
            
            if recording {
                pageTurnTimer.turnPageTapped(newPage: currentPage)
            }
            
        }
        return currentPageText
    }
    
    func prevPage() -> String{
        if currentPage > 0 {
            currentPage -= 1
            
            if recording {
                pageTurnTimer.turnPageTapped(newPage: currentPage)
            }
        }
        return currentPageText
    }
}



protocol StoryDelegate {
    func onFirstPage()
    func onLastPage()
    func onMiddlePage()
}

let dummyData = ["Spotty the Hyena is very sad, he has lost his laugh. ","""
Please help me find my laugh", said Spotty.
"I can't find a laugh up here" replied Giraffe.
"""]
