
import Foundation


class PageTurnTimer : NSObject{
    
    var pageAndTime : [(Int, TimeInterval, Bool)] = []
    
    private var page = 0
    private var dateStart : Date!
    private var nextPage = true
    
    func initialise(page:Int) {
        self.page = page
        startTimer()
    }
    
    func turnNextPageTapped(newPage:Int) {
        nextPage = true
        incrementTime()
        page = newPage
    }
    
    func turnPrevPageTapped(newPage:Int) {
        nextPage = false
        page = newPage
        incrementTime()
    }
    
    private func startTimer() {
        dateStart = Date()
    }
    
    private func incrementTime() {
        let interval = Date().timeIntervalSince(dateStart)
        
        insertPageIntoArray(milliseconds: interval)
        
    }
    
    private func insertPageIntoArray(milliseconds:TimeInterval) {
        pageAndTime.append((page, milliseconds, nextPage))
    }
    
}
