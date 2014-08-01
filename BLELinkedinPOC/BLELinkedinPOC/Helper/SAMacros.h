//
//  SAMacros.h
//  BookApp
//
//  Created by Jay Mehta on 15/06/12.
//  Copyright (c) 2012 Solution Analysts Pvt. Ltd. All rights reserved.
//

#ifndef SA_Macros_h
#define SA_Macros_h

#define IS_IPHONE		([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define IS_IPAD			([[UIDevice currentDevice] userInterfaceIdiom] != UIUserInterfaceIdiomPhone)

#define IS_RATINA  ([[UIScreen mainScreen] respondsToSelector:@selector(displayLinkWithTarget:selector:)] && ([UIScreen mainScreen].scale == 2.0))

#define IS_I5  (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON)

#define IS_I4  (fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )480 ) < DBL_EPSILON)

#define IS_IOS7		([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define SALog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);


#define TLog	SALog(@"%@",[NSString stringWithFormat:@"%f",[[NSDate date] timeIntervalSince1970]]);

#define APP_DELEGATE		((AppDelegate *)[[UIApplication sharedApplication] delegate])
#define SHARED_APP			[UIApplication sharedApplication]
#define AI					[APP_DELEGATE showActivityIndicator:@"Loading..."];
#define AI_M(s)				[APP_DELEGATE showActivityIndicator:s];
#define AI_H				[APP_DELEGATE hideActivityIndicator];
#define AI_M_H(s)			[APP_DELEGATE hideActivityIndicator:s];


#define BLACK_COLOR [UIColor blackColor]
/**
 Create a UIColor with r,g,b values between 0.0 and 1.0.
 */
#define RGBCOLOR(r,g,b) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:1.f]

/**
 Create a UIColor with r,g,b,a values between 0.0 and 1.0.
 */
#define RGBACOLOR(r,g,b,a) \
[UIColor colorWithRed:r/255.f green:g/255.f blue:b/255.f alpha:a]

/**
 Create a UIColor from a hex value.
 
 For example, `UIColorFromRGB(0xFF0000)` creates a `UIColor` object representing
 the color red.
 */
#define UIColorFromRGB(rgbValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:1.0]

/**
 Create a UIColor with an alpha value from a hex value.
 
 For example, `UIColorFromRGBA(0xFF0000, .5)` creates a `UIColor` object 
 representing a half-transparent red. 
 */
#define UIColorFromRGBA(rgbValue, alphaValue) \
[UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0x0000FF))/255.0 \
alpha:alphaValue]


#define degreesToRadians(x) (M_PI * (x) / 180.0)


#define IS_PUSH_ENABLE	([[UIApplication sharedApplication] enabledRemoteNotificationTypes] != UIRemoteNotificationTypeNone)
#endif


#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)
