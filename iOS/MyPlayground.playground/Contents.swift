//: A Cocoa based Playground to present user interface

import AppKit
import PlaygroundSupport
import uiki

let nibFile = NSNib.Name(rawValue:"MyView")
var topLevelObjects : NSArray?

Bundle.main.loadNibNamed(nibFile, owner:nil, topLevelObjects: &topLevelObjects)
let views = (topLevelObjects as! Array<Any>).filter { $0 is NSView }

// Present the view in Playground
PlaygroundPage.current.liveView = views[0] as! NSView

public class CardsView: UIView {
    
    public convenience init() {
        self.init()
    }
}
