

Pod::Spec.new do |spec|

  spec.name         = "TFY_PhotoBrowserKit"

  spec.version      = "2.0.0"

  spec.summary      = "图片视频浏览器"

  spec.description  = <<-DESC
  图片视频浏览器
                   DESC

  spec.homepage     = "https://github.com/13662049573/TFY_PhotoBrowser"
  
  spec.license      = "MIT (example)"
  
  spec.author       = { "田风有" => "420144542@qq.com" }
  
  spec.platform     = :ios, "12.0"

  spec.source       = { :git => "https://github.com/13662049573/TFY_PhotoBrowser.git", :tag => spec.version }

  spec.source_files  = "TFY_PhotoBrowser/TFY_PhotoBrowserKit/TFY_PhotoBrowserKit.h"

  spec.subspec 'ActionSheet' do |ss|
    ss.source_files  = "TFY_PhotoBrowser/TFY_PhotoBrowserKit/ActionSheet/**/*.{h,m}"
  end

  spec.subspec 'PhotoAVPlayer' do |ss|
    ss.source_files  = "TFY_PhotoBrowser/TFY_PhotoBrowserKit/PhotoAVPlayer/**/*.{h,m}"
    ss.dependency "TFY_PhotoBrowserKit/ActionSheet"
  end

  spec.subspec 'PhotoBrowserView' do |ss|
     ss.source_files  = "TFY_PhotoBrowser/TFY_PhotoBrowserKit/PhotoBrowserView/**/*.{h,m}"
     ss.dependency "TFY_PhotoBrowserKit/PhotoAVPlayer"
  end

  spec.requires_arc = true

  spec.resources  = "TFY_PhotoBrowser/TFY_PhotoBrowserKit/PhotoBrowser.bundle"

  spec.xcconfig = {"ENABLE_STRICT_OBJC_MSGSEND" => "NO", 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) COCOAPODS=1 NDEBUG=1 _DEBUG_TAG_'}
  
  spec.dependency "SDWebImage"

end
