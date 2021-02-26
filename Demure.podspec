Pod::Spec.new do |specification|
  specification.name                      = 'Demure'
  specification.version                   = '0.0.6'
  specification.summary                   = 'Mocking server for UI tests'
  specification.homepage                  = 'https://github.com/Incetro/demure'
  specification.license                   = 'MIT'
  specification.author                    = { 'incetro' => 'andrew@incetro.ru' }
  specification.source_files              = '*/Sources/DemureAPI/**/*.swift', '*/*.sh', '*', '**/Sources/DemureAPI/**/*.swift', '*/**/Sources/DemureAPI/**/*.swift', '*/*/Sources/DemureAPI/**/*.swift'
  specification.source                    = { :http => "#{specification.homepage}/releases/download/#{specification.version}/demure.zip" }
  specification.swift_version             = '5'
  specification.preserve_paths            = '*'
  specification.ios.deployment_target     = '10.0'
  specification.osx.deployment_target     = '10.12'
  specification.tvos.deployment_target    = '10.0'
  specification.watchos.deployment_target = '3.0'
end