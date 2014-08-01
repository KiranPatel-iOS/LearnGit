//
//  Helper.h
//  WWS
//
//  Created by Jay Mehta on 14/10/12.
//  Copyright (c) 2012 Solution Analysts Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject
/*!
 @method viewFromNib
 @abstract Load view from Nib Files
 */
+ (UIView *)viewFromNib:(NSString *)sNibName;
/*!
 @method viewFromNib
 @abstract Load view from Nib Files for dynemic class
 */
+ (id)viewFromNib:(NSString *)sNibName sViewName:(NSString *)sViewName;
/*!
 @method performBlock
 @abstract Perform Block Operation after delay
 */
+(void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay;
/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (NSString *)getPREF:(NSString *)sKey;
/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (int)getPREFint:(NSString *)sKey;
/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREF:(NSString *)sValue :(NSString *)sKey;
/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREFint:(int)iValue :(NSString *)sKey;
/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (id)getPREFID:(NSString *)sKey;
/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREFID:(id)sValue :(NSString *)sKey;
/*!
 @method delPREF
 @abstract To delete the preference value for the key that has been passed
 */
+(void) delPREF:(NSString *)sKey;
/*!
 @method displayAlertView
 @abstract To Display Alert Msg
 */
+(void) displayAlertView :(NSString *) title message :(NSString *) message;

/*!
 @method randomRange
 @abstract get random index between two
 */
+(int) randomRange: (int) min max:(int) max;

/*!
 @method isValidEmailId
 @abstract To check whether the Email id is valid or not
 */
+ (BOOL)isValidEmailId:(NSString *)emailId;

/**
 * @method isSet
 * @abstract  To check string is set or not
 */
+ (BOOL)isSet:(NSString *)text;

+(void)txtpadding:(UITextField *)txt;
+(BOOL)isNumaricPrecision:(NSString *)stringText;
+ (NSString *)getVersion;

/*!
 @method registerForRemoteNotificationTypesWithNotificationSound
 @abstract To register For Remote Notifications With Notification Sound
 */
+(void)registerForRemoteNotificationTypesWithNotificationSound;

/*!
 @method turnOffNotificationSound
 @abstract To turn Off Remote Notification Sound
 */
+(void)turnOffRemoteNotificationSound;

@end
