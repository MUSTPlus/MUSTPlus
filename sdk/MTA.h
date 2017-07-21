//
//  MTA.h
//  MTA-SDK
//
//  Originally created by WQY on 12-11-5.
//  Updated and maintained by xiangchen and tyzualtang.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIImage.h>

/**
 MTA版本号
 */
#define MTA_SDK_VERSION @"1.6.9"

#pragma mark - 接口监控相关数据结构
/**
 接口统计的枚举值
 */
typedef enum {
	/**
	 接口调用成功
	 */
	MTA_SUCCESS = 0,

	/**
	 接口调用失败
	 */
	MTA_FAILURE = 1,

	/**
	 接口调用出现逻辑错误
	 */
	MTA_LOGIC_FAILURE = 2
} MTAAppMonitorErrorType;


/**
 接口统计的数据结构
 */
@interface MTAAppMonitorStat : NSObject

/**
 监控业务接口名
 */
@property (nonatomic, retain) NSString *interface;

/**
 上传请求包量，单位字节
 */
@property uint32_t requestPackageSize;

/**
 接收应答包量，单位字节
 */
@property uint32_t responsePackageSize;

/**
 消耗的时间，单位毫秒
 */
@property uint64_t consumedMilliseconds;

/**
 业务返回的应答码
 */
@property int32_t returnCode;

/**
 业务返回类型
 */
@property MTAAppMonitorErrorType resultType;

/**
 上报采样率，默认0含义为无采样
 */
@property uint32_t sampling;
@end

#pragma mark - MTA统计功能相关接口
@interface MTA : NSObject

#pragma mark - 启动MTA

/**
 启动MTA

 @param appkey 从网页申请的appKey
 */
+ (void)startWithAppkey:(NSString *)appkey;

/**
 检测版本，并启动MTA。
 如果当前MTA的版本小于ver参数，则MTA不启动。否则启动MTA。

 @param appkey 从网页申请的appKey
 @param ver 最低允许启动的版本
 @return 如果MTA成功启动，返回YES，否则返回NO
 */
+ (BOOL)startWithAppkey:(NSString *)appkey checkedSdkVersion:(NSString *)ver;

#pragma mark - 统计页面时长

/**
 标记一次页面访问的开始
 此接口需要跟trackPageViewEnd配对使用
 多次开始以第一次开始的时间为准

 @param page 页面名
 */
+ (void)trackPageViewBegin:(NSString *)page;


/**
 标记一起页面访问的开始
 并且指定上报方式
 此接口需要跟trackPageViewEnd配对使用
 多次开始以第一次开始的时间为准

 @param page 页面名
 @param appkey 若此参数不为nil，则上报到此appkey。否则，上报到startWithAppkey中传入的appkey
 */
+ (void)trackPageViewBegin:(NSString *)page appkey:(NSString *)appkey;


/**
 标记一次页面访问的结束
 此接口需要跟trackPageViewBegin配对使用
 多次结束以第一次结束的时间为准

 @param page 页面名字
 */
+ (void)trackPageViewEnd:(NSString *)page;

/**
 标记一起页面访问的结束
 并且指定上报方式
 此接口需要跟trackPageViewBegin配对使用
 多次结束以第一次结束的时间为准

 @param page 页面名
 @param appkey 若此参数不为nil，则上报到此appkey。否则，上报到startWithAppkey中传入的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)trackPageViewEnd:(NSString *)page appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

#pragma mark - 错误统计

/**
 统计程序逻辑错误
 逻辑错误只有描述，没有堆栈信息

 @param error 错误描述
 */
+ (void)trackError:(NSString *)error;


/**
 统计程序逻辑错误
 并且指定上报方式
 逻辑错误只有描述，没有堆栈信息

 @param error 错误描述
 @param appkey 若此参数不为nil，则上报到此appkey。否则，上报到startWithAppkey中传入的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)trackError:(NSString *)error appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

/**
 统计异常
 异常信息包括了异常的原因和堆栈

 @param exception 异常信息
 */
+ (void)trackException:(NSException *)exception;

/**
 统计异常
 并且指定上报方式
 异常信息包括了异常的原因和堆栈

 @param exception 异常信息
 @param appkey 若此参数不为nil，则上报到此appkey。否则，上报到startWithAppkey中传入的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)trackException:(NSException *)exception appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

#pragma mark - 自定义事件

#pragma mark - 简单介绍
/**
 自定义事件分为两类
 1. 次数统计
 2. 时长统计
 两类自定义事件都可以带参数，参数的类型有两种
 1. NSDictionary 类型的参数
 2. NSArray 类型的参数
 因为NSDictionary类型的参数能表达的内容更丰富
 因此推荐优先使用NSDictionary的参数上报
 */

#pragma mark - NSDictionary为参数的自定义事件
/**
 上报自定义事件

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param kvs 事件的参数，参数需要先在MTA前台配置好才能生效
 */
+ (void)trackCustomKeyValueEvent:(NSString *)event_id props:(NSDictionary *)kvs;

/**
 上报自定义事件
 并且指定上报方式

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param kvs 事件的参数，参数需要先在MTA前台配置好才能生效
 @param appkey 需要上报的appKey，若传入nil，则上报到启动函数中的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)trackCustomKeyValueEvent:(NSString *)event_id props:(NSDictionary *)kvs appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

/**
 开始统计自定义时长事件
 此接口需要跟trackCustomKeyValueEventEnd配对使用
 多次调用以第一次开始时间为准

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param kvs 事件的参数，参数需要先在MTA前台配置好才能生效
 */
+ (void)trackCustomKeyValueEventBegin:(NSString *)event_id props:(NSDictionary *)kvs;

/**
 开始统计自定义时长事件
 并指定上报方式
 此接口需要跟trackCustomKeyValueEventEnd配对使用
 多次调用以第一次开始时间为准

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param kvs 事件的参数，参数需要先在MTA前台配置好才能生效
 @param appkey 需要上报的appKey，若传入nil，则上报到启动函数中的appkey
 */
+ (void)trackCustomKeyValueEventBegin:(NSString *)event_id props:(NSDictionary *)kvs appkey:(NSString *)appkey;

/**
 结束统计自定义时长事件
 此接口需要跟trackCustomKeyValueEventBegin配对使用
 多次调用以第一次结束时间为准

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param kvs 事件的参数，参数需要先在MTA前台配置好才能生效
 			参数中的key和value必须跟开始统计时传入的参数一样才能正常配对
 */
+ (void)trackCustomKeyValueEventEnd:(NSString *)event_id props:(NSDictionary *)kvs;

/**
 结束上报自定义时长事件
 并指定上报方式
 此接口需要跟trackCustomKeyValueEventBegin配对使用
 多次调用以第一次结束时间为准

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param kvs 事件的参数，参数需要先在MTA前台配置好才能生效
 			参数中的key和value必须跟开始统计时传入的参数一样才能正常配对
 @param appkey 需要上报的appKey，若传入nil，则上报到启动函数中的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)trackCustomKeyValueEventEnd:(NSString *)event_id props:(NSDictionary *)kvs appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;


/**
 直接统计自定义时长事件
 这个方法用于上报统计好的时长事件

 @param seconds 自定义事件的时长，单位秒
 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param kvs 事件的参数，参数需要先在MTA前台配置好才能生效
 */
+ (void)trackCustomKeyValueEventDuration:(uint32_t)seconds withEventid:(NSString *)event_id props:(NSDictionary *)kvs;

/**
 直接上报自定义时长事件
 并指定上报方式
 这个方法用于上报统计好的时长事件

 @param seconds 自定义事件的时长，单位秒
 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param kvs 事件的参数，参数需要先在MTA前台配置好才能生效
 @param appkey 需要上报的appKey，若传入nil，则上报到启动函数中的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)trackCustomKeyValueEventDuration:(uint32_t)seconds withEventid:(NSString *)event_id props:(NSDictionary *)kvs appKey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

#pragma mark - NSArray为参数的自定义事件
/**
 上报自定义事件

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param array 事件的参数，参数需要先在MTA前台配置好才能生效
 */
+ (void)trackCustomEvent:(NSString *)event_id args:(NSArray *)array;


/**
 上报自定义事件
 并指定上报方式

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param array 事件的参数，参数需要先在MTA前台配置好才能生效
 @param appkey 需要上报的appKey，若传入nil，则上报到启动函数中的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)trackCustomEvent:(NSString *)event_id args:(NSArray *)array appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

/**
 开始统计自定义时长事件
 此接口需要跟trackCustomEventEnd配对使用
 多次调用以第一次开始时间为准

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param array 事件的参数，参数需要先在MTA前台配置好才能生效
 */
+ (void)trackCustomEventBegin:(NSString *)event_id args:(NSArray *)array;

/**
 开始统计自定义时长事件
 并指定上报方式
 此接口需要跟trackCustomEventEnd配对使用
 多次调用以第一次开始时间为准

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param array 事件的参数，参数需要先在MTA前台配置好才能生效
 @param appkey 需要上报的appKey，若传入nil，则上报到启动函数中的appkey
 */
+ (void)trackCustomEventBegin:(NSString *)event_id args:(NSArray *)array appkey:(NSString *)appkey;

/**
 结束统计自定义时长事件
 此接口需要跟trackCustomKeyValueEventBegin配对使用
 多次调用以第一次结束时间为准

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param array 事件的参数，参数需要先在MTA前台配置好才能生效
 				参数中的各项必须跟开始统计时传入的参数一样才能正常配对
 */
+ (void)trackCustomEventEnd:(NSString *)event_id args:(NSArray *)array;

/**
 结束统计自定义时长事件
 并指定上报方式
 此接口需要跟trackCustomKeyValueEventBegin配对使用
 多次调用以第一次结束时间为准

 @param event_id 事件的ID，ID需要先在MTA前台配置好才能生效
 @param array 事件的参数，参数需要先在MTA前台配置好才能生效
 				参数中的各项必须跟开始统计时传入的参数一样才能正常配对
 @param appkey 需要上报的appKey，若传入nil，则上报到启动函数中的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)trackCustomEventEnd:(NSString *)event_id args:(NSArray *)array appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

/**
 上报当前缓存的数据
 若当前有缓存的事件（比如上报策略不为实时上报，或者有事件上报失败）时
 调用此方法可以上报缓存的事件

 @param maxStatCount 最大上报事件的条数
 */
+ (void)commitCachedStats:(int32_t)maxStatCount;

#pragma mark - session相关

/**
 检测session是否过期，若过期，则生成一个新Session事件
 事件上报方式按照全局上报方式上报
 */
+ (void)startNewSession;

/**
 检测session是否过期，若过期，则生成一个新Session事件
 并指定session事件的上报方式

 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)startNewSession:(BOOL)isRealTime;

/**
 停止当前session
 */
+ (void)stopSession;

#pragma mark - 使用时长

/**
 开始统计使用时长
 建议在App进入前台时调用
 */
+ (void)trackActiveBegin;

/**
 结束统计使用时长
 建议在App离开前台时调用
 */
+ (void)trackActiveEnd;

#pragma mark - 接口统计

/**
 对网络接口的调用情况进行统计
 参数的详细信息请看接口统计数据结构中的相关说明

 @param stat 接口统计的数据，详情请看接口统计数据结构的相关说明
 */
+ (void)reportAppMonitorStat:(MTAAppMonitorStat *)stat;

/**
 对网络接口的调用情况进行统计
 并指定上报方式
 参数的详细信息请看接口统计数据结构中的相关说明

 @param stat 接口统计的数据，详情请看接口统计数据结构的相关说明
 @param appkey 需要上报的appKey，若传入nil，则上报到启动函数中的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)reportAppMonitorStat:(MTAAppMonitorStat *)stat appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

#pragma mark - 上报账号
/**
 上报QQ号
 上报QQ号以后可以使用MTA提供的用户画像功能

 @param qq QQ号
 */
+ (void)reportQQ:(NSString *)qq;

/**
 上报QQ号
 并指定上报方式
 上报QQ号以后可以使用MTA提供的用户画像功能

 @param qq QQ号
 @param appkey 需要上报的appKey，若传入nil，则上报到启动函数中的appkey
 @param isRealTime 是否实时上报，若传入YES，则忽略全局上报策略实时上报。否则按照全局策略上报。
 */
+ (void)reportQQ:(NSString *)qq appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

#pragma mark - MTA标识

/**
 获取MTA内部的设备标识

 @return MTA内部设备标识
 */
+ (NSString *)getMtaUDID;

#pragma mark - MTA高级功能，具体使用方法请咨询客服
+ (void)reportAccount:(NSString *)account type:(uint32_t)type ext:(NSString *)ext;
+ (void)reportAccount:(NSString *)account type:(uint32_t)type ext:(NSString *)ext appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

+ (void)trackGameUser:(NSString *)uid world:(NSString *)wd level:(NSString *)lev;
+ (void)trackGameUser:(NSString *)uid world:(NSString *)wd level:(NSString *)lev appkey:(NSString *)appkey isRealTime:(BOOL)isRealTime;

@end
