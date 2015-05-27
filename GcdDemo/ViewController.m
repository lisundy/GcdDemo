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
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        [self loadData];
        NSLog(@"kkk");
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self updateUI];
        });
        
    });
    
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
    self.data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//        self.data = data;
//    }];
}

- (void)updateUI
{
//    self.imageView.image = [UIImage imageWithData:_data];
    
    i = -1;
    
    NSString *paths = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingString:@"apache-tomcat-8.0.23.zip"];
    
    [self.data writeToFile:paths atomically:YES];
    
    NSLog(@"%@",paths);
    NSLog(@"ok");
    
}


@end
