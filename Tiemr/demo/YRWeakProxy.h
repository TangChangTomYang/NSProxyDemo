//
//  YRWeakProxy.h
//  Tiemr
//
//  Created by edz on 2020/9/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface YRWeakProxy : NSObject
@property (nonatomic, weak) id target;

+(instancetype)proxyWithTarget:(id)target;
@end

NS_ASSUME_NONNULL_END
