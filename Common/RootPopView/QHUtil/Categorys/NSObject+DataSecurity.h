//
//  NSObject+DataSecurity.h
//  yimashuo
//
//  Created by imqiuhang on 15/10/24.
//  Copyright © 2015年 imqiuhang. All rights reserved.
//

#import "QHHead.h"

@interface NSObject (DataSecurity)


/*!
 *  @author imqiuhang, 15-10-24
 *
 *  @brief  何时使用以下方法取出数组或者字典中的数据？
            1. 从服务器端拿到的数据，特别是从第三方获取的，比如 result[@"key"]可能会由于服务器特殊情况返回的result不是字典而导致程序崩溃
            2. 具有多层的取值，比如result[@"data"][@"info"][@"key1"]这种务必使用@see h_objForKeys
 */


/*!
*  @author imqiuhang, 15-10-24
*
*  @brief  安全的取出数组的数据
*
*  @param key1 无符号整数
*
*  @return id
*/

- (id)qh_objForKeys:(id)key1, ... NS_REQUIRES_NIL_TERMINATION;



- (id)qh_objForKey:(id)key;


/*!
 *  @author imqiuhang, 15-10-24
 *
 *  @brief  安全取出数组中的数据
 *
 *  @param index key列表  默认以nil结尾的参数列表
 *
 *  @return id
 */

- (id)qh_objAtIndex:(NSUInteger)index;

@end
