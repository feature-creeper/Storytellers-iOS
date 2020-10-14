
import Foundation


class PageTurnTimer : NSObject{
    
    var couplet : [(Int, Int)] = []
    
    private var page = 0
    private var timeStart : Double = 0
    private var secondsPassed = 0
    
    
    func initialise(page:Int) {
        self.page = page
        startTimer()
    }
    
    func turnPageTapped(newPage:Int) {
        endTimer()
        page = newPage
        startTimer()
    }
    
    private func startTimer() {
        let startInterval = Date().timeIntervalSince1970
        timeStart = startInterval * 1000
    }
    
    private func endTimer() {
        let endInterval = Date().timeIntervalSince1970
        let endMillis = endInterval * 1000
        let timeInMillis = Int(endMillis - timeStart)
        
        insertPageIntoArray(milliseconds: timeInMillis)
        
        print("timeInMillis \(timeInMillis)")
    }
    
    private func insertPageIntoArray(milliseconds:Int) {
        couplet.append((page, milliseconds))
    }
    
}
