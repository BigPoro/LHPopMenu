Pod::Spec.new do |s|
    s.name                       = 'LHPopMenu'
    s.version                    = '1.0.0'
    s.summary                    = '类似微信和支付宝右上角下拉的菜单封装，使用简单。'
    s.homepage                   = 'https://github.com/BigPoro/LHPopMenu'
    s.license                    = { :type => 'MIT', :file => 'LICENSE' }
    s.author                     = { 'iDog' => 'idoghuan@163.com' }
    s.social_media_url           = ''
    s.platform                   = :ios
    s.ios.deployment_target      = '8.0'
    s.source                     = { :git => 'https://github.com/BigPoro/LHPopMenu.git', :tag => s.version }
    s.source_files               = 'LHPopMenuDemo/LHPopMenu/*.{h,m}'
end