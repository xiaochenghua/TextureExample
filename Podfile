# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'TextureExample' do
  # Comment the next line if you don't want to use dynamic frameworks
   use_frameworks!

  # Pods for TextureExample

  # AsyncDisplayKit https://github.com/facebookarchive/AsyncDisplayKit
  # Texture https://github.com/texturegroup/texture
  pod 'Texture'

  post_install do |installer|
      installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
              config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '11.0'
          end
      end
  end
  
end
