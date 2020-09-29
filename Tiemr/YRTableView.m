
//
//  YRTableView.m
//  Tiemr
//
//  Created by edz on 2020/9/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "YRTableView.h"

static NSInteger __count = 0;
@implementation YRTableView


+(NSInteger)count{
    return __count;
}
+(void)countPlus{
    __count += 1;
}

@end
