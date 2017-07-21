//
//  CirnoTextView.m
//  MUST_Plus
//
//  Created by Cirno on 07/12/2016.
//  Copyright © 2016 zbc. All rights reserved.
//
//  多行输入
//
//


#import "CirnoTextView.h"
#import "BasicHead.h"
#import "Account.h"
@implementation CirnoTextView
-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self!=nil){
        self.delegate = self;
        self.placeHolderLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,7.5,70,20)];
        self.placeHolderLabel.numberOfLines = 0;
        self.font = [UIFont systemFontOfSize:16.0];
        //self.placeHolderLabel.text = NSLocalizedString(@"个性签名", "");
        self.placeHolderLabel.backgroundColor =[UIColor clearColor];
        self.placeHolderLabel.textColor = kColor(233, 233, 233);
        self.text =  [[Account shared]getWhatsup];
        //self.residuLabel.backgroundColor = [UIColor redColor];

        self.residuLabel = [[UILabel alloc]initWithFrame:CGRectMake(158,48,80,40)];
        if (iPhone5_5s)  self.residuLabel = [[UILabel alloc]initWithFrame:CGRectMake(106,48,80,40)];
     //   self.residuLabel.backgroundColor = [UIColor clearColor];
        self.residuLabel.font = [UIFont systemFontOfSize:14.0];
        self.residuLabel.text =[NSString stringWithFormat:@"30/30"];
        self.residuLabel.textColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
        [self addSubview:self.placeHolderLabel];
        [self addSubview:self.residuLabel];
    }
    return self;
}
-(void)viewDidLoad
{
    [self textViewDidChange:self];

}
//接下来通过textView的代理方法实现textfield的点击置空默认自负效果

-(void)textViewDidChange:(UITextView*)textView

{
    int limit = self.placeholder == NSLocalizedString(@"个性签名", "")? 30 : 8;
    _rerest = (int)textView.text.length;
    //该判断用于联想输入
    if (textView.text.length > limit)
    {
        textView.text = [textView.text substringToIndex:limit];
    }
    if([textView.text length] == 0){
        self.placeHolderLabel.text = [NSString stringWithFormat:@"  %@",self.placeholder];
    }else{
        self.placeHolderLabel.text = @"";//这里给空
    }
    //计算剩余字数
    NSString *nsTextCotent = textView.text;
    NSUInteger existTextNum = [nsTextCotent length];
    NSUInteger remainTextNum = limit - existTextNum;
    if (remainTextNum >limit) remainTextNum = 0;
    self.residuLabel.text = [NSString stringWithFormat:@"%lu/30",(unsigned long)remainTextNum];
}

//设置超出最大字数即不可输入 也是textview的代理方法

-(BOOL)textView:(UITextView*)textView shouldChangeTextInRange:(NSRange)range
                            replacementText:(NSString*)text

{
    int limit = self.placeholder == NSLocalizedString(@"个性签名", "")? 30 : 8;
    if ([text isEqualToString:@"\n"]) {     //这里"\n"对应的是键盘的 return 回收键盘之用
            [textView resignFirstResponder];
            return YES;
    }
    if (range.location >= limit)  return NO;
                               else return YES;

}
@end
