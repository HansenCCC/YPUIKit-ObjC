//
//  YPPurchaseManager.h
//  YPUIKit-ObjC
//
//  Created by Hansen on 2022/12/19.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

NS_ASSUME_NONNULL_BEGIN

/*
 
 客户端内购流程
 
    1、获取可购买商品列表（Apple服务端）
 -> 2、选择商品到服务端创建订单（后端服务）
 -> 3、根据商品信息SKProduct调起苹果API进行支付
 -> 4、支付成功之后缓存苹果支付凭证（防止APP直接退出造成丢单）
 -> 5、根据支付凭证校验是否支付成功（后端服务）
 -> 6、校验成功之后删除缓存的支付凭证（否者：下次APP进入的时候重新请求校验支付是否成功）
 
 服务端检验处理
 
    文章
    苹果文章：https://developer.apple.com/documentation/appstorereceipts/verifyreceipt
    相关文章：https://blog.csdn.net/lbd_123/article/details/87276204
    错误状态： https://developer.apple.com/documentation/appstorereceipts/status
 
    用户在客户端完成支付之后，订单状态为充值中（完成上5），把receiptData等信息给到后端校验订单是否支付。
    后端调用下面订单验证接口，校验苹果支付凭证，校验成功，处理商品发放等逻辑。
 
    验证接口
    生产验证：https://buy.itunes.apple.com/verifyReceipt
    沙盒验证：https://sandbox.itunes.apple.com/verifyReceipt
            入参 {"receiptData": "xxxxx"}
 */

/// 需要校验内购支付通知
extern NSString *const kYPPurchaseNeedCheckInternalPurchasePayment;

/// 获取商品列表回调
typedef void(^YPPurchaseGetProductsCallback)(SKProductsRequest *request, SKProductsResponse *response, NSError *error);

/// 校验缓存的内购支付
typedef void(^YPPurchaseCheckPaymentCallback)(NSString *checkPath, NSDictionary *payDic, NSError *error);


@interface YPPurchaseManager : NSObject

/// 当前支付凭证
@property (nonatomic, readonly) NSString *appStoreReceiptbase64EncodedString;


+ (instancetype)sharedInstance;

/// 开始支付 （拉取商品 -> 根据商品调起支付）
/// - Parameters:
///   - productId: 苹果后台配置的商品id
///   - extend: 扩展字段，会同步保存到缓存凭证里面
///   - completion: 回调
- (void)paymentProductWithProductId:(NSString *)productId
                             extend:(NSDictionary *)extend
                         completion:(void(^)(SKPaymentTransaction *transaction, NSError *error))completion;

// 根据 SKPaymentTransaction 查找本地缓存的订单信息
- (NSDictionary *)scanLocalPaymentsBySKPaymentTransaction:(SKPaymentTransaction *)transaction;

#pragma mark - 缓存凭证相关

// 缓存支付凭证 return 成功|失败
- (BOOL)savePaymentVoucher:(NSDictionary *)payDic;

// 移除支付凭证（根据payDic匹配相同的，并移除） return 成功|失败
- (BOOL)deleteByPaymentVoucher:(NSDictionary *)deletePayDic;

#pragma mark - 放丢包校验

/// 校验缓存的内购支付，防止丢包。（可以app每次启动 didFinishLaunchingWithOptions 的时候调用）
/// - Parameter completed: 回调
- (void)checkInternalPurchasePayment:(YPPurchaseCheckPaymentCallback)completed;

@end


NS_ASSUME_NONNULL_END
