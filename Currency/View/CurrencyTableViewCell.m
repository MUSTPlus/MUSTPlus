//
//  CurrencyTableViewCell.m
//  Currency
//
//  Created by Cirno on 30/12/2016.
//  Copyright © 2016 Umi. All rights reserved.
//

#import "CurrencyTableViewCell.h"
#import "BasicHead.h"

@implementation CurrencyTableViewCell
- (void)awakeFromNib {
    [super awakeFromNib];
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                       price:(float)price
                        name:(NSString*)name
                        desc:(NSString*)desc
                        icon:(NSString*)icon
{
    self  = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _name = [[UILabel alloc]initWithFrame:CGRectMake(80, 25, Width, 40)];
        _name.textAlignment=NSTextAlignmentLeft;
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(Width/1.8, 25, Width/2.6, 40)];
        _icon = [[UIImageView alloc]initWithFrame:CGRectMake(25, 25, 40, 40)];
        _desc = [[UILabel alloc]initWithFrame:CGRectMake(Width/1.8, 45, Width/2.6, 40)];
        _icon.layer.cornerRadius = 4;
        _icon.layer.masksToBounds = YES;
        _textField.textAlignment=NSTextAlignmentRight;
        _textField.keyboardType=UIKeyboardTypeNumberPad;
        _textField.delegate=self;
        _desc.textAlignment = NSTextAlignmentRight;
        _icon.backgroundColor = [UIColor grayColor];
        _textField.font = [UIFont fontWithName:@"DIN-Light" size:24];
        _name.font = [UIFont fontWithName:@"DIN-Light" size:21];
        if (iPhone5_5s)
            _desc.font = [UIFont fontWithName:@"DIN-Light" size:11];
        else
            _desc.font = [UIFont fontWithName:@"DIN-Light" size:14];
        _desc.textColor = kColor(170, 172, 174);
        _name.text=name;
        _desc.text=desc;
        _price=price;
        _icon.image=[UIImage imageNamed:icon];
        _textField.placeholder =[NSString stringWithFormat:@"%.4f",price];
        [self addToolSender];
        [self addSubview:_icon];
        [self addSubview:_textField];
        [self addSubview:_desc];
        [self addSubview:_name];
    }
    return self;
}

-(void)addToolSender{
    UIToolbar * topView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, Width, 40)];
    [topView setBarStyle:UIBarStyleDefault];
    UIBarButtonItem * btnSpace = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:
                                  UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(2, 5, 50, 25);
    [btn addTarget:self action:@selector(end) forControlEvents:UIControlEventTouchUpInside];
    [btn setTitle:NSLocalizedString(@"完成", "") forState:UIControlStateNormal];
    [btn setTitleColor:navigationTabColor forState:UIControlStateNormal];
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithCustomView:btn];
    NSArray * buttonsArray = [NSArray arrayWithObjects:btnSpace,doneBtn,nil];
    [topView setItems:buttonsArray];
    _textField.inputAccessoryView = topView;
}
-(void)end{
    [self endEditing:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.backgroundColor =kColor(248, 248, 248);
    return YES;
}
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    self.backgroundColor  =kColor(255,255,255);
    return YES;
}
-(void)update:(NSNumber*)num{
    _textField.text = [NSString stringWithFormat:@"%.0f", _price *[num floatValue]];
    if ([_textField.text isEqual:@"0"])
        _textField.text = @"";
}

@end
