Pod::Spec.new do |s|
  s.name             = 'InjectableLoggers'
  s.version          = '1.0.2'
  s.summary          = 'A nice set of protocols that will help your logger(s) at being loosely coupled and injectable'

  s.description      = <<-DESC
A nice set of protocols that will help logger(s) at being loosely coupled and injectable.

Bonus! This lib comes with two concrete loggers 🎉
Another bonus! This lib comes with a pretty handy mock logger called MockLogger 🎉
                       DESC

  s.homepage         = 'https://github.com/mennolovink/InjectableLoggers'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mclovink@me.com' => 'mclovink@me.com' }
  s.source           = { :git => 'https://github.com/mennolovink/InjectableLoggers.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'
  s.source_files = 'InjectableLoggers/Classes/**/*'
end
