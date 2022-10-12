# YPUIKit-ObjC

[![Build Status](https://img.shields.io/badge/Github-QMKKXProduct-brightgreen.svg)](https://github.com/HansenCCC/YPUIKit-ObjC)
[![Build Status](https://img.shields.io/badge/platform-ios-orange.svg)](https://github.com/HansenCCC/YPUIKit-ObjC)
[![Build Status](https://img.shields.io/badge/HansenCCC-Github-blue.svg)](https://github.com/HansenCCC)
[![Build Status](https://img.shields.io/badge/HansenCCC-知乎-lightgrey.svg)](https://www.zhihu.com/people/EngCCC)
[![Build Status](https://img.shields.io/badge/已上架AppStore-Apple-success.svg)](https://apps.apple.com/cn/app/ios%E5%AE%9E%E9%AA%8C%E5%AE%A4/id1568656582)

## What's YPUIKit-ObjC? 

YPUIKit-ObjC 设计目的是为了快速搭建一个 iOS 项目，提高项目 UI 开发效率。

## Installation

需要使用 Cocoapods 将 YPUIKit-ObjC 集成到 Xcode 项目中去。在podfile文件中

```ruby
pod 'YPUIKit-ObjC', '~> 1.0.9'
```

## Quickstart

- ### YPKitDefines
  > 为了适配各iPhone屏幕尺寸，使用此类中定义宏，处理布局相关问题
  ```objectivec
  // 是否是 ipad
  #define YP_IS_IPAD                         ([YPKitDefines instance].isIpad)
  // 导航栏宽高
  #define YP_HEIGHT_NAV_STATUS               ([YPKitDefines instance].statusBarSizeHeight)
  #define YP_HEIGHT_NAV_CONTENTVIEW          ([YPKitDefines instance].navigationViewHeight)
  #define YP_HEIGHT_NAV_BAR                  (YP_HEIGHT_NAV_STATUS + YP_HEIGHT_NAV_CONTENTVIEW)
  // 屏幕宽高
  #define YP_UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width)
  #define YP_UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height)
  // tab高度
  #define YP_HEIGHT_IPHONEX_BOTTOM_MARGIN    ([YPKitDefines instance].safeAreaInsets.bottom)
  #define YP_HEIGHT_TAB_BAR                  (YP_HEIGHT_IPHONEX_BOTTOM_MARGIN + 49)
  // 搜索search 高度
  #define YP_HEIGHT_SEARCH_BAR               44
  ```
  
<img src="https://pica.zhimg.com/80/v2-d5c28a9585d100bda51ea6a30816f162_720w.png" width="600">

- ### YPButton
  > 如果你觉得UIButton用起来麻烦，那就试试YPButton。`（左图片，右文字；左文字，右图片；上图片，下文字；上文字，下图片）`

```objectivec
typedef enum : NSUInteger {
    YPButtonContentStyleHorizontal = 0, //左图标，右文本
    YPButtonContentStyleVertical, //上图标，下文本
} YPButtonContentStyle;

@interface YPButton : UIButton

@property (nonatomic, assign) YPButtonContentStyle contentStyle;
@property (nonatomic, assign) NSInteger interitemSpacing;//图标与文字之间的间距，默认是0px
@property (nonatomic, assign) BOOL reverseContent;//是否逆转图标与文字的顺序，默认是NO:图标在左/上,文本在右/下
@property (nonatomic, assign) CGSize imageSize;//图片尺寸值，image.size，默认为(0,0)，代表自动根据图片大小计算

@end
```

<img src="https://pic2.zhimg.com/80/v2-81a730fa8b82f348af8816d109aa5e78_720w.png" width="600">

- ### YPAlertView
  > 例子：弹出一个提示，"这是一个提示"
  ```objectivec
  [YPAlertView alertText:@"这是一个提示"];
  ```
  
<img src="https://pic2.zhimg.com/80/v2-5596aaec2b6700760591cdbc0448a54a_720w.png" width="600">

- ### YPPopupController
  > 项目中存在很多popup出来的试图。例如提示更新弹框、闪屏、选择器、交互弹框...等
可以继承 YPPopupController 来快速实现炫酷的弹框
  ```objectivec
  typedef NS_ENUM(NSInteger, YPPopupControllerStyle){
      YPPopupControllerStyleMiddle = 0,
      YPPopupControllerStyleBottom
  };
  
  @interface YPPopupController : YPViewController
  
  @property (nonatomic, assign) BOOL isEnableTouchMove;//是否允许点击时退出
  
  @property (nonatomic, readonly) YPPopupControllerStyle style;
  @property (nonatomic, readonly) UIView *contentView;
  
  + (instancetype)popupControllerWithStyle:(YPPopupControllerStyle)style;
  
  @end
  ```
  
<img src="https://pic2.zhimg.com/80/v2-5596aaec2b6700760591cdbc0448a54a_720w.png" width="600">

- ### YPCategory
  ```objectivec
  #ifndef YPCategoryHeader_h
  #define YPCategoryHeader_h
  
  // 
  #import "NSData+YPExtension.h"
  // 用于 NSDate 对象与 NSString 对象之间相互转换；NSDate 与 NSDate之间的对比；
  #import "NSDate+YPExtension.h"
  // 用于 字符拼接；手机号、URL有效性正则判断；通过字符和字体获取宽度；md5生成；
  #import "NSString+YPExtension.h"
  // 
  #import "NSTimer+YPExtension.h"
  // 用于快速初始化；
  #import "UIButton+YPExtension.h"
  // 用于 UIColor与16进制相互转化；常见颜色；
  #import "UIColor+YPExtension.h"
  // 用于获取图片通道；仿射矩阵变换图片；二维码识别和生成；图片裁剪；UIColor <==> UIImage; 图片大小限制及压缩；Bundle 资源获取；图片尺寸相关；图片矫正；图片内存大小；
  #import "UIImage+YPExtension.h"
  // 用于快速初始化；
  #import "UILabel+YPExtension.h"
  // 用于头部顶部滚动处理；滚动到指定试图；
  #import "UIScrollView+YPExtension.h"
  // 用于刷新当前视图；
  #import "UITableViewCell+YPExtension.h"
  // 用于光标获取和设置；限制输入框最大长度；
  #import "UITextField+YPExtension.h"
  // 用于获取垂直或水平的最底部subview；获取当前subviews中class（UIView）类；生成试图截图；快速绘制圆角；
  #import "UIView+YPExtension.h"
  // 用于获取当前显示的控制器；
  #import "UIViewController+YPExtension.h"
  
  #endif /* YPCategoryHeader_h */
  ```
  
  <br/>

## Author

chenghengsheng, 2534550460@qq.com

## Log

```
2021.11.01  1.0.9版本，针对 YPPopupController 优化；feature: 针对popup优化，暴露contentView; 修改podspec s.module_name = 'YPUIKit'；
2021.10.20  1.0.8版本，增加 YPPopupController 用于实现底部或中间弹出的弹框；
2021.10.20  1.0.7版本，处理头文件引用问题；
2021.08.19  1.0.6版本，添加一些常用分类（NSData、NSDate、NSTimer）；
2021.08.12  1.0.5版本，移除一些无用依赖库；
2021.08.12  1.0.4版本，增加 YPAlertView 实现弹框提醒【不建议使用此版本】；
2021.08.12  1.0.3版本，新增 YPButton 处理图文布局【不建议使用此版本】；
2021.08.07  1.0.2版本，添加一些常用分类（UIViewController、UIView、UITextField、UITableViewCell、UIScrollView、UILabel、UIImage、UIColor、UIButton、NSString）【不建议使用此版本】；
2021.08.07  1.0.1版本，podspec 编写【不建议使用此版本】；
2021.08.07  1.0.0版本，新的版本从这里开始【不建议使用此版本】；

```
