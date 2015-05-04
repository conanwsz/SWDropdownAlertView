Pod::Spec.new do |s|

  s.name         = "SWDropdownAlertView"
  s.version      = "0.0.1"
  s.summary      = "A short description of openssl."

  s.description  = <<-DESC
                   A longer description of openssl in Markdown format.

                   * Think: Why did you write this? What is the focus? What does it do?
                   * CocoaPods will be using this to generate tags, and improve search results.
                   * Try to keep it short, snappy and to the point.
                   * Finally, don't worry about the indent, CocoaPods strips it!
                   DESC

  s.homepage     = "http://EXAMPLE/SWDropdownAlertView"
  s.license      = "MIT"

  s.author             = { "conanwsz" => "conanwsz@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :svn  => "http://10.0.13.110/repos/ios/Mall/trunk/src/SWDropdownAlertView" }
  s.source_files  = ["SWDropdownAlertView/SWDropdownAlertView/*.{m,h}"]
  s.resources  = ["SWDropdownAlertView/SWDropdownAlertView/*.xib","SWDropdownAlertView/Images.xcassets"]

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }


end
