// Source: https://stackoverflow.com/a/58235153

import UIKit

extension UIViewController {
    
    var navigationBarbarContentStart: CGFloat {
        navigationBarTopOffset + navigationBarHeight
    }
    var navigationBarTopOffset: CGFloat {
        navigationController?.navigationBar.frame.origin.y ?? .zero
    }
    
    var navigationBarHeight: CGFloat {
        navigationController?.navigationBar.frame.height ?? .zero
    }
}
