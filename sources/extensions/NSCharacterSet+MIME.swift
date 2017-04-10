import Foundation

extension CharacterSet {

  class func MIMECharacterSet() -> CharacterSet {
    let characterSet = CharacterSet(charactersIn: "\"\n\r")
    return characterSet.inverted
  }
  
}
