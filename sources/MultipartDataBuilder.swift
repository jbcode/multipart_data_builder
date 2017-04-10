import Foundation

private let MultipartFormCRLF = "\r\n"
private let MutlipartFormCRLFData = MultipartFormCRLF.data(using: String.Encoding.utf8)!

/// MultipartDataBuilder builds a multipart form (RFC2388) form both key value 
/// pairs and chunks of data as embedded files.

public struct MultipartDataBuilder {

  var fields: [Data] = []
  public let boundary: String

  public init() {
    self.boundary = "0xKhTmXbhgOuNdArY"
  }

  /// Builds the multipart form
  /// 
  /// - returns: the built form as NSData
  public func build() -> Data? {

    let data = NSMutableData()

    for field in self.fields {
      data.append(self.toData("--\(self.boundary)"))
      data.append(MutlipartFormCRLFData)
      data.append(field)
    }

    data.append(self.toData("--\(self.boundary)--"))
    data.append(MutlipartFormCRLFData)

    return (data.copy() as! Data)
  }

  /// Appends a value pair to the form
  ///
  /// - parameter key: the used form-data key
  /// - parameter value: the appended value to the form
  mutating public func appendFormData(_ key: String, value: String) {
    let content = "Content-Disposition: form-data; name=\"\(encode(key))\""
    let data = self.merge([
      self.toData(content),
      MutlipartFormCRLFData,
      MutlipartFormCRLFData,
      self.toData(value),
      MutlipartFormCRLFData
    ])
    self.fields.append(data)
  }

  /// Appends a chunk of data as a file
  ///
  /// - parameter name: the name of the field to post it as
  /// - parameter content: the data chunk to embed in the form
  /// - parameter fileName: file name of the file
  /// - parameter contentType: MIME content type of the embedded file
  mutating public func appendFormData(_ name: String, content: Data, fileName: String, contentType: String) {
    let contentDisposition = "Content-Disposition: form-data; name=\"\(self.encode(name))\"; filename=\"\(self.encode(fileName))\""
    let contentTypeHeader = "Content-Type: \(contentType)"
    let data = self.merge([
      self.toData(contentDisposition),
      MutlipartFormCRLFData,
      self.toData(contentTypeHeader),
      MutlipartFormCRLFData,
      MutlipartFormCRLFData,
      content,
      MutlipartFormCRLFData
    ])
    self.fields.append(data)
  }

  // MARK: Private

  fileprivate func encode(_ string: String) -> String {
    let characterSet = CharacterSet.MIMECharacterSet()
    return string.addingPercentEncoding(withAllowedCharacters: characterSet)!
  }

  fileprivate func toData(_ string: String) -> Data {
    return string.data(using: String.Encoding.utf8)!
  }

  fileprivate func merge(_ chunks: [Data]) -> Data {
    let data = NSMutableData()
    for chunk in chunks {
      data.append(chunk)
    }
    return data.copy() as! Data
  }
  
}
