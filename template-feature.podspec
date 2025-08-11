Pod::Spec.new do |spec|
  spec.name         = "template-feature"
  spec.version      = "1.0.0"
  spec.summary      = "A daily quote feature module with clean architecture"
  spec.description  = <<-DESC
                      A modular iOS feature that provides daily quote functionality.
                      Built with Clean Architecture principles, includes:
                      - SwiftUI-based presentation layer
                      - Protocol-driven domain layer
                      - Repository pattern for data management
                      - Comprehensive unit test coverage
                      - Resource bundle support
                      DESC
  
  spec.homepage     = "https://github.com/example/template-feature"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = { "Template Team" => "team@example.com" }
  
  # Platform and version requirements
  spec.platform     = :ios, "15.0"  # Updated to match actual requirements
  spec.swift_version = "5.0"
  
  # Source configuration - flexible for different integration methods
  spec.source_files = "template-feature/**/*.{swift,h,m}"
  
  # Resource bundles for assets
  spec.resource_bundles = {
    'template-feature-resources' => ['template-feature/Resources/**/*']
  }
  
  # Framework dependencies
  spec.frameworks   = "SwiftUI", "Foundation", "UIKit"
  
  # iOS deployment target
  spec.ios.deployment_target = "15.0"
  
  # Additional configuration
  spec.requires_arc = true
  spec.module_name  = "template_feature"  # Explicit module name to avoid confusion
  
  # Test specification
  spec.test_spec 'Tests' do |test_spec|
    test_spec.source_files = 'template-featureTests/**/*.{swift,h,m}'
  end
end