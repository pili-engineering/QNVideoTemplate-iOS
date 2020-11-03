#
#  Be sure to run `pod spec lint QNVideoTemplate.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
    s.name      = 'QNVideoTemplate'
    s.version   = '1.0.0'
    s.summary   = 'Qiniu Video Template SDK for iOS.'
    s.license   = 'Apache License, Version 2.0'
    s.homepage  = 'https://www.qiniu.com'
    s.author    = { "pili" => "pili-coresdk@qiniu.com" }
    s.source    = { :http => "https://sdk-release.qnsdk.com/QNVideoTemplate-#{s.version}.zip"}

   
    s.platform                = :ios
    s.ios.deployment_target   = '12.0'
    s.requires_arc            = true

    s.vendored_frameworks = ["Frameworks/*.framework"]
end

