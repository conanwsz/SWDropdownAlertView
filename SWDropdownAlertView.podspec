Pod::Spec.new do |s|

  s.name         = "SWDropdownAlertView"
  s.version      = "0.2.0"
  s.summary      = "SWDropdownAlertView"

  s.description  = <<-DESC
                   Dropdown an alertview, which has 3 types, from top of the screen.

                   DESC

  s.homepage     = "https://github.com/conanwsz/SWDropdownAlertView"
  s.license      = "MIT"

  s.author       = { "conanwsz" => "conanwsz@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git  => "https://github.com/conanwsz/SWDropdownAlertView.git", :tag => '0.3.0' }
  s.source_files  = ["SWDropdownAlertView/SWDropdownAlertView/*.{m,h}"]
  s.resources  = ["SWDropdownAlertView/SWDropdownAlertView/*.xib","SWDropdownAlertView/Images.xcassets"]

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }


end
