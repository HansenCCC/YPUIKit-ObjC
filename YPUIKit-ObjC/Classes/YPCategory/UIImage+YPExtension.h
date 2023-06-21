//
//  UIImage+YPExtension.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/7/13.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (YPExtension)

/// 是否是png,判断依据是否含有alpha通道
- (BOOL)yp_isPngImage;

/// 黑白化图片
- (UIImage *)yp_convertImageToGrey;

/// 将颜色转化为图片  1x1
/// @param color 颜色
+ (UIImage*)yp_imageWithColor:(UIColor *)color;

/// 使用blend来渲染图片的颜色
/// @param tintColor 需要渲染的颜色
- (UIImage *)yp_imageWithTintColor:(UIColor *)tintColor;

/// 裁剪出指定rect的图片(限定在自己的size之内) 内部已考虑到retina图片,rect不必为retina图片进行x2处理
/// @param rect 指定的矩形区域,坐标系为图片坐标系,原点在图片的左上角
- (UIImage *)yp_cropImageWithRect:(CGRect)rect;

/// 获取图片压缩后的二进制数据,如果图片大小超过bytes时,会对图片进行等比例缩小尺寸处理    会自动进行png检测,从而保持alpha通道
/// @param bytes  二进制数据的大小上限,0代表不限制
/// @param compressionQuality  压缩后图片质量,取值为0...1,值越小,图片质量越差,压缩比越高,二进制大小越小
- (NSData *)yp_imageDataThatFitBytes:(NSUInteger)bytes compressionQuality:(CGFloat)compressionQuality;

- (NSData *)yp_imageDataThatFitBytes:(NSUInteger)bytes;

- (NSData *)yp_imageDataWithCompressionQuality:(CGFloat)compressionQuality;

- (NSData *)yp_imageData;

@end

@interface UIImage (YPBundle)

/// 获取bundle里面图片
/// @param name 资源名称
/// @param bundle bundle对象
+ (UIImage *)yp_imageWithName:(NSString *)name forBundle:(NSBundle *)bundle;

@end

@interface UIImage (YPImageSize)

/// 返回最大相对尺寸。x/y 为0时，尺寸不受约束
/// @param size 尺寸
- (CGSize)yp_sizeWithMaxRelativeSize:(CGSize)size;

/// 返回最小相对尺寸。x/y 为0时，尺寸不受约束
/// @param size 尺寸
- (CGSize)yp_sizeWithMinRelativeSize:(CGSize)size;

/// 将图片缩放到指定的CGSize大小
/// @param size 要缩放到的尺寸
/// @param scale 比例
- (UIImage *)yp_imageWithCanvasSize:(CGSize)size scale:(CGFloat)scale;

- (UIImage *)yp_imageWithCanvasSize:(CGSize)size;

/// 矫正图片 （相机拍照之后的图片可能需要矫正一下再使用）
- (UIImage *)yp_fixOrientation;

/// 返回图片在内存里的像素点所占的内存大小,单位为字节(Byte) 1kb = 1024btye
- (NSUInteger)yp_lengthOfRawData;

@end

@interface UIImage (YPTransform)

/// 水平翻转图片
- (UIImage *)yp_horizontalInvertImage;

/// 垂直翻转图片
- (UIImage *)yp_verticalInvertImage;

/// 以图片中心为圆点,旋转图片
/// @param radians 旋转的弧度值,正值时逆时针旋转,负值顺时针旋转
- (UIImage *)yp_rotateImageWithRadians:(CGFloat)radians;

/// 仿射矩阵变换处理图片
/// @param transform CGAffineTransform
/// @param newSize 新的尺寸
/// @param orientation 变换后图片的朝向
- (UIImage *)yp_transformImageWithAffineTransform:(CGAffineTransform)transform newSize:(CGSize)newSize newOrientation:(UIImageOrientation)orientation;

- (UIImage *)yp_transformImageWithAffineTransform:(CGAffineTransform)transform newSize:(CGSize)newSize;

- (UIImage *)yp_transformImageWithAffineTransform:(CGAffineTransform)transform;

/// 将图片朝向调整到指定的朝向 （如果朝向不变,返回self,否则返回调整后新的图片）
/// @param orientation 图片朝向
- (UIImage *)yp_transformImageWithOrientation:(UIImageOrientation)orientation;

@end

@interface UIImage (YPQRCode)

/// 识别二维码
- (NSString *)yp_qrcodeString;

/// 生成二维码
/// @param qrcode 二维码数据
/// @param size 尺寸
+ (UIImage *)yp_imageWithQRCodeString:(NSString *)qrcode size:(CGSize)size;

@end

@interface UIImage (YPImageLocalStorage)

/// 获取本地 image 存储的路径
- (NSString *)yp_imagesDirectory;

/// 存储 image
/// - Parameter image: UIImage 对象
- (BOOL)yp_saveImageToDocument:(UIImage *)image;

/// 根据文件名获取 UIImage 对象
/// - Parameter imageName: 文件名
- (UIImage *)yp_getDocumentImageWithImageName:(NSString *)imageName;

@end

NS_ASSUME_NONNULL_END
