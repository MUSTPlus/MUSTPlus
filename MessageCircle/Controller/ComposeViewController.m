//
//  ComposeViewController.m
//  MUST_Plus
//
//  Created by Cirno on 13/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import "ComposeViewController.h"
#import "CTextView.h"
#import <Photos/Photos.h>
@interface ComposeViewController ()
@property (nonatomic,strong) CTextView * textview;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *superImgView;
@property (nonatomic, strong) NSMutableArray *imgArr;
@end

@implementation ComposeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
