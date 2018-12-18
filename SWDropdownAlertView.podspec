Pod::Spec.new do |s|

  s.name         = "SWDropdownAlertView"
  s.version      = "0.4.3"
  s.summary      = "SWDropdownAlertView"

  s.description  = <<-DESC
                   Dropdown an alertview, which has 3 types, from top of the screen.

                   DESC

  s.homepage     = "https://github.com/conanwsz/SWDropdownAlertView"
  s.license      = "MIT"

  s.author       = { "conanwsz" => "conanwsz@gmail.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git  => "https://github.com/conanwsz/SWDropdownAlertView.git", :tag => "#{s.version}" }

  if ENV['Source'] || ENV["#{s.name}Source"]
    s.source_files  = ["SWDropdownAlertView/*.{m,h}"]
    s.resources  = ["SWDropdownAlertView/*.xib","SWDropdownAlertView/Images.xcassets"]
  else
    # s.source_files  = ["SWDropdownAlertView/SWDropdownAlertView.h"]
    s.vendored_frameworks = ["Carthage/Build/iOS/SWDropdownAlertView.framework"]
  end
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency 'Masonry', '~> 0.6.4'
end
