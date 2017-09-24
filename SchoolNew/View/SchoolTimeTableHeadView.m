//
//  SchoolTimeTableHeadView.m
//  MUST_Plus
//
//  Created by zbc on 16/10/8.
//  Copyright © 2016年 zbc. All rights reserved.
//

#import "SchoolTimeTableHeadView.h"
#import <SDWebImage/UIButton+WebCache.h>
#import "BasicHead.h"
#import "Account.h"

@implementation SchoolTimeTableHeadView{
    UIButton *face;
}

-(id)initWithFrame:(CGRect)frame{
    self=[super initWithFrame:frame];
    if(self!=nil){
        
        
    }
    return self;
}

-(void)drawHeadViewWithTtile:(NSString *)titleString
                 buttonImage:(NSString *)buttonImgString
                    subTitle:(NSString *)subtitleString{
    
    //    self.backgroundColor = [UIColor colorWithRed:95.0/255.0 green:167.0/255.0 blue:241.0/255.0 alpha:1];
    
    self.backgroundColor = [UIColor whiteColor];
//    face = [[UIButton alloc] initWithFrame:CGRectMake(15, StatusBarHeight, 40, 40)];
//    face.layer.cornerRadius = face.frame.size.width/2;
//    face.clipsToBounds = YES;
//    face.layer.borderWidth = 2;
//    face.layer.borderColor = [UIColor clearColor].CGColor;
//    
//    NSURL *url = [NSURL URLWithString:[[Account shared] getAvatar]];
//    [face sd_setImageWithURL:url forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"defaultFace.png"]];
//    
//    face.adjustsImageWhenHighlighted = NO;
//    [face addTarget:self action:@selector(ClickFace:) forControlEvents:UIControlEventTouchDown];
//    [self addSubview:face];
//    face.layer.borderWidth = 0.5f;
//    face.layer.borderColor = kColor(230, 230, 230).CGColor;


    _title = [[UILabel alloc] initWithFrame:CGRectMake(0,StatusBarHeight-5,Width,NavigationBarHeight/4*3)];
    _title.text = titleString;
    _title.textColor = kColor(22,130,217);
    _title.font = [UIFont systemFontOfSize:18];
    _title.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_title];
    _subtitle = [[UILabel alloc]initWithFrame:CGRectMake(0, StatusBarHeight+NavigationBarHeight/7*5-5.5, Width, NavigationBarHeight/4)];
    _subtitle.text = subtitleString;
    _subtitle.textColor=kColor(22,130,217);
    _subtitle.font = [UIFont systemFontOfSize:12];
    _subtitle.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_subtitle];
    
    face = [[UIButton alloc] initWithFrame:CGRectMake(25, StatusBarHeight + 5, 70, 30)];
    [face setTitle:@"签到" forState:UIControlStateNormal];
    [face setImage:[UIImage imageNamed:@"toolbar-sign"] forState:UIControlStateNormal];
    [face setBackgroundColor:kColor(22,130,217)];
    face.titleEdgeInsets = UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f);
    [face setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [face setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    face.titleLabel.font = [UIFont systemFontOfSize:16];
    [face addTarget:self action:@selector(ClickFace:) forControlEvents:UIControlEventTouchDown];
    
    face.clipsToBounds = YES;
    face.layer.borderWidth = 0.5f;
    face.layer.cornerRadius = 2;
    [self addSubview:face];
    
    //加号
    UIButton *add = [[UIButton alloc] initWithFrame:CGRectMake(Width-40, StatusBarHeight+10, 30, 30)];
    [add setImage:[UIImage imageNamed:buttonImgString] forState:UIControlStateNormal];
    add.imageView.contentMode=UIViewContentModeScaleAspectFill;
    [self addSubview:add];
    [add addTarget:self action:@selector(Click:) forControlEvents:UIControlEventTouchDown];
    UIView   *frameView = [[UIView alloc] initWithFrame:CGRectMake(0, StatusBarAndNavigationBarHeight, Width, 1)] ;
    frameView.layer.borderWidth = 1;
    frameView.layer.borderColor = kColor(169, 170, 183).CGColor;
    [self addSubview:frameView];
}
-(void)drawMenuBar{
    self.containView = [[UIView alloc]initWithFrame:CGRectMake(0, -72, Width-60*2, 72)];
  //  self.containView.backgroundColor = [UIColor redColor];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(60, 0, Width-60*2, 150) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource=self;
    self.menuImage = [[UIImageView alloc]initWithFrame:CGRectMake(Width/2+50, 10+StatusBarHeight, 15, 15)];
    self.tableView.backgroundColor = navigationTabColor;
    self.menuImage.image = [UIImage imageNamed:@"triangle"];
    [self.containView addSubview:self.tableView];
    self.menuImage.userInteractionEnabled = YES;
    UITapGestureRecognizer* singleTap;
    singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(moreSelected:)];
    singleTap.numberOfTapsRequired = 1;
   // [self.menuImage addGestureRecognizer:singleTap];
    [self addSubview:self.containView];
    [self addSubview:self.menuImage];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    cell.textLabel.text = [NSString stringWithFormat:@"第%ld周",indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.detailTextLabel.text = @"03/20-06/20";
    cell.detailTextLabel.textAlignment = NSTextAlignmentCenter;
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 15;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell*cell =[tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", cell.textLabel.text);
}
- (void)moreSelected:(id)sender
{
    NSLog(@"tap");
    if (_menuShowing)
    {
        [UIView animateWithDuration:0.3 animations:^
         {
             CGRect frame = _containView.frame;
             frame.origin.y = -frame.size.height;
             [_containView setFrame:frame];

             _menuImage.transform = CGAffineTransformMakeRotation(M_PI*2);
         }completion:^(BOOL finished)
         {
             _containView.hidden = YES;
             _menuShowing = NO;
         }];
    }

    else
    {
        _containView.hidden = NO;

        [UIView animateWithDuration:0.3 animations:^
         {
             CGRect frame = _containView.frame;
             frame.origin.y = 64;
             [_containView setFrame:frame];

             _menuImage.transform = CGAffineTransformMakeRotation(-3.141593);
         } completion:^(BOOL finished)
         {
             _menuShowing = YES;
         }];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    if (_menuShowing)
        [self moreSelected:nil];
}

-(void) changeFace{
    NSURL *url = [NSURL URLWithString:[[Account shared]getAvatar]];
    [face sd_setImageWithURL:url forState:UIControlStateNormal];
}

-(void) ClickFace:(id)button{
    NSLog(@"点击头像");
    [_headButtonDelegate ClickFace:button];
}
-(void) Click:(id)button{
    NSLog(@"%s被调用了",__FUNCTION__);
    [_headButtonDelegate ClickAdd:button];
}


@end
