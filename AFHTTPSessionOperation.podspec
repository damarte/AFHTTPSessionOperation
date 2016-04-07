Pod::Spec.new do |s|
  s.name     = 'AFHTTPSessionOperation'
  s.version  = '0.1.0'
  s.license  = 'BSD'
  s.summary  = 'A `NSOperation` subclass for requests added to `AFHTTPSessionManager`'
  s.homepage = 'https://github.com/damarte/AFHTTPSessionOperation'
  s.author   = { 'Rob Ryan' => '' }
  s.source   = {
    :git => 'https://github.com/damarte/AFHTTPSessionOperation',
    :tag => '0.1.0'
  }
  s.requires_arc = true
  s.platform = :ios, '7.0'

  s.preserve_paths = 'README.md'
  s.ios.deployment_target = '7.0'

  s.dependency 'AFNetworking', '> 2'

  s.public_header_files = 'AFHTTPSessionOperation/*.h'

  s.source_files = 'AFHTTPSessionOperation/*.{h,m}'
end
