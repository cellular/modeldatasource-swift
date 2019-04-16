#
# Be sure to run `pod lib lint cellularlocalstorage.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |spec|
 spec.name             = 'CellularModelDataSource'
 spec.swift_version    = '4.2'
 spec.module_name      = 'ModelDataSource'
 spec.version          = '5.0.1'
 spec.summary          = 'Easy TableView and CollectionView data handling.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

 spec.description      = 'Easily and safely manage your content for data compatible views. The module is capable of handling two dimensional sets of data and simplifies displaying content in section and row/item based views (e.g. UITableView, UICollectionView).'
 spec.homepage         = 'https://www.cellular.de'
 spec.license          = { :type => 'MIT', :file => 'LICENSE' }
 spec.author           = { 'Cellular GmbH' => 'office@cellular.de' }
 spec.source           = { :git => 'https://github.com/cellular/modeldatasource-swift.git', :tag =>spec.version.to_s }

  # Deployment Targets
 spec.ios.deployment_target = '9.3'
 spec.tvos.deployment_target = '9.2'

    # Core Subspec

    spec.subspec 'Core' do |sub|
        sub.source_files = 'Source/**/*.swift'
    end

    # Default Subspecs

    spec.default_subspecs = 'Core'
end
