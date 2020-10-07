Pod::Spec.new do |spec|
spec.name          = 'Urway'
spec.version       = '1.1.4'
spec.license       = { :type => 'MIT' }
spec.homepage      = 'www.concertosoft.com'
spec.authors       = { 'sagar' => 'sagar.pawar@concertosoft.com' }
spec.summary       = 'Urway Framework'
spec.source        = { :git => 'https://github.com/sagarpawar88/UrwaySDK.git'}

spec.ios.deployment_target  = '11.0'
spec.swift_version = '5'

spec.source_files   = 'Urway/native/Urway/**/*.{swift,h,m}'
spec.resources = 'Urway/native/Urway/**/*.{strings,xib,xcassets,strings,ttf,otf,css,js,html,storyboard,eot,svg,woff,xcdatamodeld,json,sh,rb}'

spec.framework      = 'UIKit'
end
