# CustomUIKit(自定义UI集)
=======
使用方式

1、使用私有库


    platform :ios ,'7.0'
    target "Example" do
    #    pod 'CustomUIKit', '~> 0.0.1'
        pod 'CustomUIKit', :git => "https://github.com/mingailei/CustomUIKit.git", :tag => "0.0.1"
    end


2、使用本地库


    （1）~/Documents中新建文件夹git_repository（地址可以任意，第3步中的配置地址为该地址）
    （2）下载代码到文件夹git_repository中
    （3）Podfile中添加
            pod 'CustomUIKit', :local => "~/Documents/git_repository/CustomUIKit"


3、使用svn库


    platform :ios ,'7.0'
    target "Example" do
        pod 'CustomUIKit', :svn => "https://192.168.1.103/svn/ecoalstore/trunk/ios/CustomUIKit"
    end
