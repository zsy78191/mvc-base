# Uncomment the next line to define a global platform for your project
 platform :ios, '10.0'
inhibit_all_warnings!

target 'mvc-base' do
  # Uncomment the next line if you're using Swift or would like to use dynamic frameworks
  use_frameworks!
  pod 'oc-string', :podspec => '../../base/oc-string/oc-string.podspec'
  pod 'ui-base', :podspec => '../../ui/ui-base/ui-base.podspec'
  pod 'ReactiveObjC'
  pod 'MagicalRecord'
  pod 'MGJRouter'
  pod 'IGListKit'
  pod 'DZNEmptyDataSet'
  # Pods for mvc-base

  target 'mvc-baseTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'mvc-baseUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
