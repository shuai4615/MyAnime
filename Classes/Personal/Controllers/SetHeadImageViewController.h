//
//  SetHeadImageViewController.h
//  MyAnime
//
//  Created by qianfeng on 15/6/15.
//  Copyright (c) 2015年 IsMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetHeadImageViewController : UIViewController

@property (nonatomic, copy) void (^block)(NSInteger number);

@property (nonatomic, copy) void (^photoLibraryBlock)(UIImage *image);

@end
