#
#  Be sure to run `pod spec lint Peanut.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#

Pod::Spec.new do |s|

  s.name         = "ZYLCustomAlertView"
  s.version      = "0.0.1"
  s.summary      = "CustomAlertView"

  s.description  = <<-DESC
                   CustomAlertView
                   DESC

  s.homepage     = "https://github.com/zylcold"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "zylcold" => "707889716@qq.com" }
  # Or just: s.author    = "zylcold"
  # s.authors            = { "zylcold" => "707889716@qq.com" }
  # s.social_media_url   = "http://twitter.com/zylcold"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # s.platform     = :ios
  s.platform     = :ios, "7.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "7.0"
  # s.osx.deployment_target = "10.7"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/zylcold/ZYLCustomAlertView.git", :tag => s.version }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "ZYLCustomAlertView.{h,m}"
  #  s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"



  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true

end
