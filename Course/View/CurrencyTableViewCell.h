//
//  CurrencyTableViewCell.h
//  Currency
//
//  Created by Cirno on 30/12/2016.
//  Copyright © 2016 Umi. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol selector
-(void)select;
@end

@interface CurrencyTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (nonatomic,strong) UILabel* name;
@property (nonatomic,strong) UILabel* desc;
@property (nonatomic,strong) UITextField* textField;
@property (nonatomic,strong) UIImageView* icon;
@property (nonatomic) float price;
@property (nonatomic, assign, readonly) id<selector>delegate;
-(instancetype)initWithStyle:(UITableViewCellStyle)style
             reuseIdentifier:(NSString *)reuseIdentifier
                       price:(float)price
                        name:(NSString*)name
                        desc:(NSString*)desc
                        icon:(NSString*)icon;
-(void)update:(NSNumber*)num;
@end
