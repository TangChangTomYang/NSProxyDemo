//
//  WeakProxy.h
//  Tiemr
//
//  Created by edz on 2020/9/29.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

 

@interface WeakProxy : NSProxy <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) id target;

+(instancetype)proxyWithTarget:(id)target;
@end

 


 
