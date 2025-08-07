Pod::Spec.new do |spec|
  spec.name         = "template-feature"
  spec.version      = "1.0.0"
  spec.summary      = "A daily quote feature module"
  spec.description  = "A feature module that provides daily quote functionality with clean architecture"
  spec.homepage     = "https://github.com/example/template-feature"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Author" => "author@example.com" }
  
  spec.platform     = :ios, "15.0"
  spec.swift_version = "5.0"
  
  spec.source       = { :path => "." }
  spec.source_files = "template-feature/**/*.{swift,h,m}"
  spec.resource_bundles = {
    'template-feature' => ['template-feature/Resources/**/*']
  }
  
  spec.frameworks   = "SwiftUI", "Foundation"
end