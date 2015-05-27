# GcdDemo
This is a GCD test
//
//  ViewController.m
//  GcdDemo
//
//  Created by pactera on 15/5/27.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    int i;
}

@property (retain, nonatomic) UIImageView    *imageView;
@property (retain, nonatomic) NSData         *data;
@end

@implementation ViewController

- (void)dealloc
{
    [_imageView release];
    [super dealloc];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 100, 320, 180)];
    [self.view addSubview:self.imageView];
    
    //这里相当于开启了一个新的分线程。与主线程并发执行
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self loadData];
        NSLog(@"kkk");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
        
    });
    
    //这种方式没有单开一个线程，所以一直在主线程中，也就不是多线程了
//    [self loadData];
//    NSLog(@"kkk");
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self updateUI];
//    });
    
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(play:) userInfo:nil repeats:YES];
    
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
}

- (void)play:(NSTimer *)timer
{
    if (i==-1) {
        [timer invalidate];
    }
    
    NSLog(@"%i",i++);
}

- (void)loadData
{
    NSURL *url = [NSURL URLWithString:@"http://apache.fayea.com/tomcat/tomcat-8/v8.0.23/bin/apache-tomcat-8.0.23.zip"];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    NSURLResponse *response;
    NSError *error;
//    NSOperationQueue *queue = [NSOperationQueue mainQueue];
//这里是用同步请求，表示在这里没有完成的时候，是不能进行之后的操作的，也就是说图片没有下载完成是不能进行显示的。
    self.data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    //这里是异步请求，如果下载图片，则不能用这种请求方式，因为不能够在图片还没有下载完成就给imageview赋值。这样图片也不会显示
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        self.data = data;
//    }];
}

//请求完成后，根据数据进行的操作，如更新界面，图片显示，保存数据到指定文件夹...
- (void)updateUI
{
//    self.imageView.image = [UIImage imageWithData:_data];
    
    i = -1;
    
    NSString *paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"apache-tomcat-8.0.23.zip"];
    
    [self.data writeToFile:paths atomically:YES];
    
    NSLog(@"%@",paths);
    NSLog(@"ok");
    
}


//所以总结：如果下载图片，并且进行显示这一类必须等到数据请求完成之后才进行下一步的数据操作，以及数据请求量很大的时候：
1、开启一个新的线程，使之与主线程并发执行。
2、使用同步方式请求数据。










@end
