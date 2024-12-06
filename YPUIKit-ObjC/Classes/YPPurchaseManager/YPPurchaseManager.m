//
//  YPPurchaseManager.m
//  WTPlatformSDK
//
//  Created by Hansen on 2022/12/19.
//

#import "YPPurchaseManager.h"
#import "YPLoadingView.h"
#import "NSString+YPExtension.h"

/// 购买内购商品回调
typedef void(^YPPurchasePaymentProductCallback)(SKPaymentTransaction *transaction,
                                                NSError *error);
/// 恢复订阅的内购回调
typedef void(^YPPurchaseRestorePaymentCallback)(NSArray<SKPaymentTransaction *> *transactions, NSError *error);

NSString *const kYPPurchaseNeedCheckInternalPurchasePayment = @"kYPPurchaseNeedCheckInternalPurchasePayment";//需要检查一下丢单情况
NSString *const kYPPurchaseCurrentOrderKey = @"kYPPurchaseCurrentOrderKey";//当前支付缓存信息

@interface YPPurchaseManager () <SKPaymentTransactionObserver, SKProductsRequestDelegate>

@property (nonatomic, strong) SKProductsRequest *requestProducts;/// 请求商品列表
@property (nonatomic, copy) YPPurchaseGetProductsCallback productsListCallback;/// 获取商品列表回调
@property (nonatomic, copy) YPPurchasePaymentProductCallback buyProductCallback;/// 购买商品回调
@property (nonatomic, copy) YPPurchaseRestorePaymentCallback restoreCallback;/// 订阅恢复的回调
@property (nonatomic, strong) NSArray <SKProduct *>*products;/// 商品列表

@property (nonatomic, strong) NSDictionary *order;// 缓存订单信息

@end

@implementation YPPurchaseManager

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static YPPurchaseManager *sdk = nil;
    dispatch_once(&onceToken, ^{
        sdk = [[YPPurchaseManager alloc] init];
    });
    return sdk;
}

- (instancetype)init{
    if (self = [super init]) {
        if ([SKPaymentQueue defaultQueue]) {
            [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        }
    }
    return self;
}

- (void)paymentProductWithProductId:(NSString *)productId
                             extend:(NSDictionary *)extend
                         completion:(void(^)(SKPaymentTransaction *transaction, NSError *error))completion; {
    NSArray* transactions = [SKPaymentQueue defaultQueue].transactions;
    if (transactions.count >= 1) {
        for (SKPaymentTransaction* transaction in transactions) {
            if (transaction.transactionState == SKPaymentTransactionStatePurchased ||
                transaction.transactionState == SKPaymentTransactionStateRestored) {
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            }
        }
        NSLog(@"-----------存在历史未消耗订单-----------");
    } else {
        NSLog(@"-----------没有历史未消耗订单-----------");
    }
    self.order = [extend copy];
    __weak typeof(self) weakSelf = self;
    /// 获取商品
    [[YPPurchaseManager sharedInstance] requestProducts:@[productId?:@""] callback:^(SKProductsRequest * _Nullable request, SKProductsResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            SKProduct *product = self.products.firstObject;
            if (product) {
                NSMutableDictionary *order = [[NSMutableDictionary alloc] initWithDictionary:[self.order copy]];
                NSString *price = [NSString stringWithFormat:@"%@",product.price];
                NSString *productName = [NSString stringWithFormat:@"%@",product.localizedTitle];
                [order addEntriesFromDictionary:@{
                    @"price":price,
                    @"productName":productName,
                }];
                self.order = [order copy];
                /// 开始支付
                [YPLoadingView hideLoading];
                [YPLoadingView showLoading:@"交易进行中，请稍等".yp_localizedString];
                [weakSelf buyProduct:product onCompletion:^(SKPaymentTransaction * _Nullable transaction, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (!error) {
                            if (completion) {
                                completion(transaction, error);
                            }
                        } else {
                            if (completion) {
                                NSString *errorMsg = [weakSelf.class descriptionFailWithError:error];
                                NSError *errorTemp = [NSError errorWithDomain:errorMsg code:error.code userInfo:error.userInfo];
                                completion(nil, errorTemp);
                            }
                        }
                    });
                }];
            } else {
                NSError *errorTemp = error ? error : [NSError errorWithDomain:[NSString stringWithFormat:@"查不到商品 %@".yp_localizedString,productId] code:10010 userInfo:nil];
                if (completion) {
                    completion(nil, errorTemp);
                }
            }
        });
    }];
}
/// 恢复用户先前的订阅信息
- (void)restoreCompletedTransactions:(void(^)(NSArray<SKPaymentTransaction *> *transactions, NSError *error))completion {
    self.restoreCallback = completion;
    SKPaymentQueue *paymentQueue = [SKPaymentQueue defaultQueue];
    [paymentQueue restoreCompletedTransactions];
}

// 根据商品 productId 获取 SKProducts
- (void)requestProducts:(NSArray <NSString *>*)productIdentifiers callback:(YPPurchaseGetProductsCallback)callback {
    /// 配置请求商品ids
    NSSet *set = [[NSSet alloc] initWithArray:productIdentifiers];
    self.requestProducts = [[SKProductsRequest alloc] initWithProductIdentifiers:set];
    self.requestProducts.delegate = self;
    self.productsListCallback = callback;
    /// 开始请求
    [self.requestProducts start];
}

// 使用 SKProduct 进行支付
- (void)buyProduct:(SKProduct *)productIdentifier onCompletion:(YPPurchasePaymentProductCallback)completion {
    self.buyProductCallback = completion;
    SKPayment *payment = [SKPayment paymentWithProduct:productIdentifier];
    if ([SKPaymentQueue defaultQueue] && productIdentifier) {
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    } else {
        if (self.buyProductCallback) {
            NSError *error = [NSError errorWithDomain:@"商品id为空".yp_localizedString code:10010 userInfo:nil];
            self.buyProductCallback(nil, error);
            self.buyProductCallback = nil;
        }
    }
}

// 获取内购常见错误码
+ (NSString *)descriptionFailWithError:(NSError *)error {
    NSString *description = error.userInfo[NSLocalizedDescriptionKey];
    if (description.length == 0) {
        description = @"支付失败！".yp_localizedString;
    }
    if (error.code == 2) {
        description = @"支付已取消！".yp_localizedString;
    }else if (error.code == 21000) {
        description = @"App Store不能读取你提供的JSON对象".yp_localizedString;
    }else if (error.code == 21002) {
        description = @"不支持该地区的apple ID".yp_localizedString;
    }else if (error.code == 21003) {
        description = @"不支持该地区的apple ID".yp_localizedString;
    }else if (error.code == 21004) {
        description = @"不支持该地区的apple ID".yp_localizedString;
    }else if (error.code == 21005) {
        description = @"不支持该地区的apple ID".yp_localizedString;
    }else if (error.code == 21006) {
        description = @"不支持该地区的apple ID".yp_localizedString;
    }else if (error.code == 21007) {
        description = @"不支持该地区的apple ID".yp_localizedString;
    }else if (error.code == 21008) {
        description = @"不支持该地区的apple ID".yp_localizedString;
    }
    return description;
}

#pragma mark - SKProductsRequestDelegate

- (void)productsRequest:(nonnull SKProductsRequest *)request didReceiveResponse:(nonnull SKProductsResponse *)response {
    /// 获取商品列表回调
    dispatch_async(dispatch_get_main_queue(), ^{
        /// 缓存请求成功的商品信息
        self.products = [response.products copy];
        /// 清除请求状态
        self.requestProducts.delegate = nil;
        self.requestProducts = nil;
        if(self.productsListCallback){
            self.productsListCallback(request, response, nil);
        }
    });
}

- (void)request:(SKRequest *)request didFailWithError:(NSError *)error {
    /// //获取商品列表失败回调
    dispatch_async(dispatch_get_main_queue(), ^{
        /// 缓存请求成功的商品信息
        self.products = @[];
        /// 清除请求状态
        self.requestProducts.delegate = nil;
        self.requestProducts = nil;
        /// 请求失败
        if(self.productsListCallback){
            self.productsListCallback((SKProductsRequest *)request, nil ,error);
        }
    });
}

#pragma mark - SKPaymentTransactionObserver

- (void)paymentQueue:(nonnull SKPaymentQueue *)queue updatedTransactions:(nonnull NSArray<SKPaymentTransaction *> *)transactions {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (SKPaymentTransaction *transaction in transactions) {
            switch (transaction.transactionState) {
                case SKPaymentTransactionStatePurchasing: {
                    /// 正在将事务添加到服务器队列。（正在购买）
                    [self purchasingTransaction:transaction];
                    break;
                }
                case SKPaymentTransactionStatePurchased: {
                    /// 事务在队列中，用户已被收费。客户应完成交易。（客户端完成交易）
                    [self purchasedTransaction:transaction];
                    break;
                }
                case SKPaymentTransactionStateFailed: {
                    /// 事务在添加到服务器队列之前已取消或失败。（用户取消支付或者失败）
                    [self failedTransaction:transaction];
                    break;
                }
                case SKPaymentTransactionStateRestored: {
                    /// 交易已从用户的购买历史记录中还原。客户应完成交易
                    [self restoreTransaction:transaction];
                    break;
                }
                default:
                    break;
            }
        }
    });
}

- (void)purchasingTransaction:(SKPaymentTransaction *)transaction {
    /// 正在将事务添加到服务器队列。（正在购买）
    
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.restoreCallback) {
            self.restoreCallback(queue.transactions, nil);
        }
    });
}

- (void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.restoreCallback) {
            self.restoreCallback(nil, error);
        }
    });
}

- (void)purchasedTransaction:(SKPaymentTransaction *)transaction {
    //缓存支付凭证
    NSString *receipt = [YPPurchaseManager sharedInstance].appStoreReceiptbase64EncodedString?:@"";
    NSString *transactionIdentifier = transaction.transactionIdentifier?:@"";
    NSString *productIdentifier = transaction.payment.productIdentifier;
    NSDictionary *order = [self.order copy];
    NSMutableDictionary *payDic = [[NSMutableDictionary alloc] init];
    [payDic addEntriesFromDictionary:@{
        @"receiptData": receipt,
        @"transactionId": transactionIdentifier,
        @"productId": productIdentifier,
    }];
    [payDic addEntriesFromDictionary:order];
    //缓存支付凭证
    [[YPPurchaseManager sharedInstance] savePaymentVoucher:payDic];
    /// 事务在队列中，用户已被收费。客户应完成交易。（客户端完成交易）
    if ([SKPaymentQueue defaultQueue]) {
        /// 标记请求完成
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    if (self.buyProductCallback) {
        self.buyProductCallback(transaction,transaction.error);
        self.buyProductCallback = nil;
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kYPPurchaseNeedCheckInternalPurchasePayment object:nil];
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    /// 事务在添加到服务器队列之前已取消或失败。（用户取消支付或者失败）
    if ([SKPaymentQueue defaultQueue]) {
        /// 标记请求完成
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
    if (self.buyProductCallback) {
        self.buyProductCallback(transaction,transaction.error);
        self.buyProductCallback = nil;
    }
}

- (void)restoreTransaction:(SKPaymentTransaction *)transaction {
    /// 交易已从用户的购买历史记录中还原。客户应完成交易
    if ([SKPaymentQueue defaultQueue]) {
        /// 标记请求完成
        [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    }
}

- (void)dealloc {
    if ([SKPaymentQueue defaultQueue]) {
        [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
    }
}

- (NSString *)appStoreReceiptbase64EncodedString {
    /// 获取当前支付成功 存在本地的receipt
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receiptData = [NSData dataWithContentsOfURL:receiptURL];
    NSString *receipt = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return receipt;
}

- (NSString *)cacheInternalPurchasePaymentPath {
    /// 获取缓存凭证的地址
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    path = [NSString stringWithFormat:@"%@/InternalPurchasePayment",path];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    /// 判断文件是否存在，不存直接创建
    BOOL isDirExist = [fileManager fileExistsAtPath:path isDirectory:nil];
    if(!isDirExist){
        [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}

- (void)checkInternalPurchasePayment:(YPPurchaseCheckPaymentCallback)completed {
    /// 校验缓存的内购支付 checkPath(回调需要校验的校验地址)
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *path = [self cacheInternalPurchasePaymentPath];
    /// 搜索该目录下的所有文件和目录
    NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if (error == nil) {
        if (filesArray.count == 0) {
            if (completed) {
                completed(nil, @{}, nil);
            }
        } else {
            for (NSString *name in filesArray) {
                if ([name hasSuffix:@".plist"]) {
                    NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,name];
                    NSDictionary *payDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
                    if (completed) {
                        completed(filePath, [payDic copy], nil);
                    }
                }
            }
        }
    } else {
        if (completed) {
            completed(nil, @{}, error);
        }
    }
}

- (BOOL)savePaymentVoucher:(NSDictionary *)payDic {
    /// 缓存支付凭证
    NSString *path = [self cacheInternalPurchasePaymentPath];
    NSString *fileName = [NSString stringWithFormat:@"%ld",(long)[[NSDate date] timeIntervalSince1970] * 1000];
    NSString *savedPath = [NSString stringWithFormat:@"%@/%@.plist", path,fileName];
    BOOL success = [payDic writeToFile:savedPath atomically:YES];
    return success;
}

- (NSDictionary *)scanLocalPaymentsBySKPaymentTransaction:(SKPaymentTransaction *)transaction {
    NSString *transactionId = transaction.transactionIdentifier;
    /// 移除支付凭证（根据payDic匹配相同的，并移除）
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *path = [self cacheInternalPurchasePaymentPath];
    /// 搜索该目录下的所有文件和目录
    NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if (error == nil) {
        /// 遍历支付凭证是否存在凭证列表里面
        for (NSString *name in filesArray) {
            if ([name hasSuffix:@".plist"]) {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,name];
                NSDictionary *payDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
                /// 不为空处理
                if (payDic == nil) {
                    payDic = @{};
                }
                NSString *localTransactionId = payDic[@"transactionId"];
                /// 存在相同的支付凭证
                if ([localTransactionId isEqualToString:transactionId] && localTransactionId.length > 0) {
                    return payDic;
                }
            }
        }
        /// 遍历完成之后，文件已经不存在
        return @{};
    } else {
        return @{};
    }
}

- (BOOL)deleteByPaymentVoucher:(NSDictionary *)deletePayDic {
    /// 移除支付凭证（根据payDic匹配相同的，并移除）
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error = nil;
    NSString *path = [self cacheInternalPurchasePaymentPath];
    /// 搜索该目录下的所有文件和目录
    NSArray *filesArray = [fileManager contentsOfDirectoryAtPath:path error:&error];
    if (error == nil) {
        /// 遍历支付凭证是否存在凭证列表里面
        for (NSString *name in filesArray) {
            if ([name hasSuffix:@".plist"]) {
                NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,name];
                NSDictionary *payDic = [NSDictionary dictionaryWithContentsOfFile:filePath];
                /// 不为空处理
                if (payDic == nil) {
                    payDic = @{};
                }
                /// 存在相同的支付凭证
                if ([payDic isEqualToDictionary:deletePayDic]) {
                    NSError *deleteError = nil;
                    if ([fileManager fileExistsAtPath:filePath]) {
                        /// 移除支付凭证
                        [fileManager removeItemAtPath:filePath error:&deleteError];
                        if (!deleteError) {
                            /// 删除成功
                            return YES;
                        } else {
                            /// 删除失败
                            return NO;
                        }
                    } else {
                        /// 文件不存在，直接失败
                        return NO;
                    }
                }
            }
        }
        /// 遍历完成之后，文件已经不存在
        return NO;
    } else {
        return NO;
    }
}

#pragma mark - getters | setters

- (void)setOrder:(NSDictionary *)order {
    [[NSUserDefaults standardUserDefaults] setObject:order?:@{} forKey:kYPPurchaseCurrentOrderKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDictionary *)order {
    NSDictionary *order = [[NSUserDefaults standardUserDefaults] dictionaryForKey:kYPPurchaseCurrentOrderKey];
    return order;
}


#pragma clang diagnostic pop

@end
