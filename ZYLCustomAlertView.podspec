#
#  Be sure to run `pod spec lint Peanut.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#

Pod::Spec.new do |s|

  s.name         = "ZYLCustomAlertView"
  s.version      = "0.0.3"
  s.summary      = "CustomAlertView"

  s.description  = <<-DESC
                   This is a CustomAlertView, That can Show a Custom View with animation.
                   Supported Bottom, Center to Show.
                   DESC

  s.homepage     = "https://github.com/zylcold"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = { :type => "MIT", :file => "LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "zylcold" => "zylcold@163.com" }
  s.social_media_url   = "https://zylcold.github.io"

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "7.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/zylcold/ZYLCustomAlertView.git", :tag => s.version }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.source_files  = "ZYLCustomAlertView.{h,m}"
  s.ios.framework  = 'UIKit'


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true

end
