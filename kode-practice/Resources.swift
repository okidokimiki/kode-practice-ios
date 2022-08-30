import UIKit

typealias R = Resources

enum Resources {
    
    enum Images {
        static let stopper = UIImage(named: "goose-and-knife")
        static let backArrow = UIImage(named: "back-arrow")?.withRenderingMode(.alwaysTemplate)
        enum Details {
            static let start = UIImage(named: "star")
            static let phone = UIImage(named: "phone")
        }
        enum SearchBar {
            static let xClear = UIImage(named: "x-clear")
            static let leftImageNormal = UIImage(named: "magnifying-glass-normal")
            static let leftImageSelected = UIImage(named: "magnifying-glass-selected")
            static let rightImageNormal = UIImage(named: "filter-list-normal")
            static let rightImageSelected = UIImage(named: "filter-list-selected")
        }
    }
    
    enum Fonts {
        static func interMedium(with size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Medium", size: size) ?? UIFont()
        }
        
        static func interRegular(with size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Regular", size: size) ?? UIFont()
        }
        
        static func interSemiBold(with size: CGFloat) -> UIFont {
            UIFont(name: "Inter-SemiBold", size: size) ?? UIFont()
        }
        
        static func interBold(with size: CGFloat) -> UIFont {
            UIFont(name: "Inter-Bold", size: size) ?? UIFont()
        }
    }
    
    enum Strings {
        enum Department: String {
            case all = "allTab.title"
            case android = "androidTab.title"
            case ios = "iosTab.title"
            case design = "designTab.title"
            case management = "managementTab.title"
            case qa = "qaTab.title"
            case backOffice = "backOfficeTab.title"
            case frontend = "frontendTab.title"
            case hr = "hrTab.title"
            case pr = "prTab.title"
            case backend = "backendTab.title"
            case support = "supportTab.title"
            case analytics = "analyticsTab.title"
            
            var localizedString: String {
                NSLocalizedString(self.rawValue, comment: "")
            }
        }
        
        enum SearchBar: String {
            case placeholder = "placeholderSearchBar.title"
            case cancel = "cancelSearchBar.title"
            
            var localizedString: String {
                NSLocalizedString(self.rawValue, comment: "")
            }
        }
        
        enum Filter: String {
            case title = "filter.title"
            case filterByAlphabet = "filterByAlphabet.text"
            case filterByBirthday = "filterByBirthday.text"
            
            var localizedString: String {
                NSLocalizedString(self.rawValue, comment: "")
            }
        }
        
        enum NoInternet: String {
            case connectionError = "networkConnectionError.text"
            
            var localizedString: String {
                NSLocalizedString(self.rawValue, comment: "")
            }
        }
        
        enum NoResult: String {
            case title = "noResult.title"
            case message = "noResult.text"
            
            var localizedString: String {
                NSLocalizedString(self.rawValue, comment: "")
            }
        }
        
        enum Alert: String {
            case tryAgain = "tryAgainAlert.title"
            case title = "alert.title"
            case message = "messageAlert.text"
            
            var localizedString: String {
                NSLocalizedString(self.rawValue, comment: "")
            }
        }
    }
    
    enum USymlos: String {
        case ufo = "\u{1F6F8}"
        case magnifyingGlass = "\u{1F50D}"
    }
}
