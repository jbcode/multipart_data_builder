import Foundation

public extension NSMutableURLRequest {

  /// Convenience method to configure a multipart form on a request
  ///
  /// - parameter data: the multipart for as NSData
  /// - parameter boundary: the boundary used to build the form
  public func setMultipartBody(data: NSData, boundary: String) {
    self.HTTPBody = data
    self.setValue("multipart/form-data; boundary=\(boundary)",
      forHTTPHeaderField: "Content-Type")
  }

  /// Convenience method to configure a multipart form on a request
  ///
  /// - parameter stream: the multipart form as NSInputStream
  /// - parameter boundary: the boundary used to build the form
  public func setMultipartStream(stream: NSInputStream, boundary: String) {
    self.HTTPBodyStream = stream
    self.setValue("multipart/form-data; boundary=\(boundary)",
      forHTTPHeaderField: "Content-Type")
  }

}
