//
//  Smart.h
//  Currency
//
//  Created by Cirno on 03/02/2017.
//  Copyright © 2017 Umi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SmartPlaceSet.h"
@interface Smart : NSObject
@property (nonatomic,strong) NSMutableArray<SmartPlaceSet*>* object;//所有物件
//@property (nonatomic,strong) NSString* desc;
-(instancetype)initWithjson:(NSString*)json;
-(NSInteger)countOfObject;
@end
