UIKit+CUAddtion (UIKit extension)
=======
使用方式

1、使用私有库


    platform :ios ,'7.0'
    target "Example" do
    #    pod 'UIKit+CUAddtion', '~> 0.0.1'
        pod 'UIKit+CUAddtion', :git => "https://github.com/mingailei/UIKit+CUAddtion.git", :tag => "0.0.1"
    end


2、使用本地库


    （1）~/Documents中新建文件夹git_repository（地址可以任意，第3步中的配置地址为该地址）
    （2）下载代码到文件夹git_repository中
    （3）Podfile中添加 
            pod 'UIKit+CUAddtion', :local => "~/Documents/git_repository/UIKit+CUAddtion"


3、使用svn库


    platform :ios ,'7.0'
    target "Example" do
        pod 'UIKit+CUAddtion', :svn => "https://192.168.1.103/svn/trunk/ios/UIKit+CUAddtion"
    end

