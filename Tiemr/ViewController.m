//
//  ViewController.m
//  Tiemr
//
//  Created by edz on 2020/9/28.
//  Copyright © 2020 EDZ. All rights reserved.
//

#import "ViewController.h"
#import "WeakProxy.h"
#import "YRWeakProxy.h"
#import "YRTableView.h"

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) CADisplayLink *link;
@property (nonatomic, strong) WeakProxy *proxy;
@property (nonatomic, strong) YRTableView *tableView;
@end

@implementation ViewController


-(WeakProxy *)proxy{
    if (!_proxy) {
         _proxy = [WeakProxy proxyWithTarget:self];
    }
    return _proxy;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
   // proxy 钩子, 勾住tableView
    [self test_proxyHookTableView];
    
    // 测试 proxy 解决 定时器强引用
//    [self test_proxyWeakTargetCADisaplayLink];
    
}


-(void)test_proxyHookTableView{
    self.tableView = [[YRTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self.proxy;
    self.tableView.dataSource = self.proxy;
    [self.view addSubview:self.tableView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"abc"];
    if(!cell){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"abc"];
    }
    
    cell.textLabel.text = @(indexPath.row).stringValue;
    return cell;
    
}
 
// 使用 NSProxy 钩子, 钩住 系统调用 tableView: didSelectRowAtIndexPath: 方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSLog(@"控制器  didSelectRowAtIndexPath 点击了");
}


/** NSProxy 解决循环引用
 
 一般来说CADisplayLink 会保证调用频率和屏幕刷帧频率一致 (一般是60fps), 这也是为什么CADisplayLink 没有设置时间的参数
 但是如果你的主线程耗时操作做的比较多, 并不能保证每秒60次

 我们在使用CADisplayLink 是会传入一个 target (self), 在CADisplayLink 内部会对这个target (self) 有一个强引用
 在self 内一般我们也会使用一个成员属性强引用的指针引用着CADisplayLink, 这样 就产生了一个 你强引用者我, 我强引用者你的循环
 引用, 最后内存都无法释放, 一般我们会增加一个 第三者 proxy 来解决这种 强强引用的问题

 引入proxy 解决定时器这种强引用的内存问题的步骤是这样的
 1. 控制内内 定义一个 self.displayLink 属性, 用来强引用CADisplayLink
 2. 使用控制器(self) 作为proxy的 weak 引用的target,
 3. 在创建控制器的定时器(self.displaylink) 时, target 不再直接使用控制器, 而是使用 proxy
 当self.displayLink 在执行是会到proxy中去找对应的回调方法, 这时proxy内部将方法的调用消息转发给内部weak引用的target即可
 这时定时器内部就会回调到控制器的方法v
 */
-(void)test_proxyWeakTargetCADisaplayLink{
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget: self.proxy   selector:@selector(linkAction:)];
    self.link = link;
    [self.link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSDefaultRunLoopMode];
     
}
 
-(void)linkAction:(CADisplayLink *)link{
    NSLog(@"%s", __func__);
}

-(void)dealloc{
   NSLog(@"%s", __func__);
}

@end
