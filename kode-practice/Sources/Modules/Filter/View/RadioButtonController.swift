// Source: https://stackoverflow.com/a/61614634

import UIKit

class RadioButtonController: NSObject {
    var buttonsArray: [RadioButton]?
    var selectedButton: RadioButton?
    
    var defaultButton: RadioButton? {
        didSet { buttonArrayUpdated(buttonSelected: self.defaultButton) }
    }
    
    func buttonArrayUpdated(buttonSelected: RadioButton?) {
        guard let buttonsArray = buttonsArray else { return }
        
        buttonsArray.forEach { button in
            if button == buttonSelected {
                selectedButton = button
                button.isSelected = true
            } else {
                button.isSelected = false
            }
        }
    }
}
