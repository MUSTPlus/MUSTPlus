//
//  Alert.h
//  MUST_Plus
//
//  Created by Cirno on 28/11/2016.
//  Copyright © 2016 zbc. All rights reserved.
//

#import <UIKit/UIKit.h>
#define DEFAULT_LINE_SPACING        (int)0
#define DEFAULT_PARAGRAPH_SPACING   (int)3

typedef NS_ENUM(NSInteger, AlertStyle) {
    AlertStyleDefault = 0,
    AlertStyleSecureTextInput,
    AlertStylePlainTextInput,
    AlertStyleLoginAndPasswordInput
};
@class Alert;
@protocol AlertDelegate;

@interface Alert : UIView {
    UITextView *_messageLabel;
    UILabel *_titleLabel;
}
@property (nonatomic, retain) id object;
// delegate
@property (nonatomic, assign, readonly) id<AlertDelegate>delegate;

// alertView
@property (nonatomic, strong, readonly) UIToolbar *alertView;

// 内容文字大小
@property (nonatomic, strong) UIFont *font;

// 设置message的对齐方式
@property (nonatomic, assign) NSTextAlignment contentAlignment;

// Alert TextInput LoginInput
@property (nonatomic, strong) UITextField *textField;

// Alert PasswordInput
@property (nonatomic, strong) UITextField *passwordTextField;

@property (nonatomic, assign) CGFloat lineSpacing;        // DEFAULT_LINE_SPACING
@property (nonatomic, assign) CGFloat paragraphSpacing;   // DEFAULT_PARAGRAPH_SPACING
@property (nonatomic, assign) AlertStyle alertStyle;   // DEFAULT_PARAGRAPH_SPACING

#pragma mark - --block
typedef void (^CancelAlertBlock)(Alert *alertView) ;
typedef void (^ClicksAlertBlock)(Alert *alertView, NSInteger buttonIndex);
@property (nonatomic, copy, readonly) CancelAlertBlock cancelBlock;
@property (nonatomic, copy, readonly) ClicksAlertBlock clickBlock;
- (void)setCancelBlock:(CancelAlertBlock)cancelBlock;
- (void)setClickBlock:(ClicksAlertBlock)clickBlock;

#pragma mark - --init
/**
 *  创建alertView
 *
 *  @param title             提示标题
 *  @param message           提示详情
 *  @param delegate          协议对象
 *  @param cancelButtonTitle 取消按钮名称
 *  @param otherButtonTitles 其他按钮
 *
 *  @return Alert
 */
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...NS_REQUIRES_NIL_TERMINATION;

/**
 *  显示alertView
 */
- (void)show;
@end

#pragma mark - --delegate
@protocol AlertDelegate <NSObject>

@optional

- (void)alertView:(Alert *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;

- (void)alertViewCancel:(Alert *)alertView;

@end
