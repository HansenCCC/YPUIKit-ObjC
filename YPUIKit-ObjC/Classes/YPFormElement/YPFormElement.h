//
//  YPFormElement.h
//  YPLaboratory
//
//  Created by Hansen on 2023/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YPFormElement : NSObject

@property (nonatomic, assign) BOOL enable;// default YES
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *placeholder;
@property (nonatomic, strong) id extend;

@end

NS_ASSUME_NONNULL_END
