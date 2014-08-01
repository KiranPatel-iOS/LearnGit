//
//  Helper.m
//  WWS
//
//  Created by Jay Mehta on 14/10/12.
//  Copyright (c) 2012 Solution Analysts Pvt Ltd. All rights reserved.
//

#import "Helper.h"


#define NUMBERS_ONLY @"1234567890"

@implementation Helper
/*!
 @method viewFromNib
 @abstract Load view from Nib Files
 */
+ (UIView *)viewFromNib:(NSString *)sNibName{
	return (UIView *)[Helper viewFromNib:sNibName sViewName:@"UIView"];
}
/*!
 @method viewFromNib
 @abstract Load view from Nib Files for dynemic class
 */
+ (id)viewFromNib:(NSString *)sNibName sViewName:(NSString *)sViewName{

	Class className = NSClassFromString(sViewName);
	if (IS_IPAD) {
		sNibName = [sNibName stringByAppendingString:@"_iPad"];
	}
	NSArray *xib = [[NSBundle mainBundle] loadNibNamed:sNibName owner:self options:nil];
	for (id _view in xib) { // have to iterate; index varies
		if ([_view isKindOfClass:[className class]]) return _view;
	}
	return nil;
}
/*!
 @method performBlock
 @abstract Perform Block Operation after delay
 */
+(void)performBlock:(void (^)(void))block afterDelay:(NSTimeInterval)delay{
	int64_t delta = (int64_t)(1.0e9 * delay);
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, delta), dispatch_get_main_queue(), block);
}
/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (NSString *)getPREF:(NSString *)sKey {
    return (NSString *)[[NSUserDefaults standardUserDefaults] valueForKey:sKey];
}

/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (int)getPREFint:(NSString *)sKey {
    return [[NSUserDefaults standardUserDefaults] integerForKey:sKey];
}

/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREF:(NSString *)sValue :(NSString *)sKey {
	[[NSUserDefaults standardUserDefaults] setValue:sValue forKey:sKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREFint:(int)iValue :(NSString *)sKey {
	[[NSUserDefaults standardUserDefaults] setInteger:iValue forKey:sKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*!
 @method getPreferenceValueForKey
 @abstract To get the preference value for the key that has been passed
 */
+ (id)getPREFID:(NSString *)sKey {
    return [[NSUserDefaults standardUserDefaults] valueForKey:sKey];
}

/*!
 @method setPreferenceValueForKey
 @abstract To set the preference value for the key that has been passed
 */
+(void) setPREFID:(id)sValue :(NSString *)sKey {
	[[NSUserDefaults standardUserDefaults] setValue:sValue forKey:sKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*!
 @method delPREF
 @abstract To delete the preference value for the key that has been passed
 */
+(void) delPREF:(NSString *)sKey {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:sKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
/*!
 @method displayAlertView
 @abstract To Display Alert Msg
 */
+ (void) displayAlertView :(NSString *) title message :(NSString *) message
{
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [alert show];
    [alert release];
}


/*!
 @method randomRange
 @abstract get random index between two
 */
+(int) randomRange: (int) min max:(int) max {
    int range = max - min;
    if (range == 0) return min;
	
    return (arc4random() % range) + min;
}

/*!
 @method isValidEmailId
 @abstract To check whether the Email id is valid or not
 */
+ (BOOL)isValidEmailId:(NSString *)emailId {
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSString *laxString = @".+@.+\\.[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailId];
}

/**
 * @method isSet
 * @abstract  To check string is set or not
 */
+ (BOOL)isSet:(NSString *)text{
	if ([text length]==0 || [text isEqual:[NSNull null]]) {
		return FALSE;
	}
	return TRUE;
}

+(void)txtpadding:(UITextField *)txt
{
    UIView *viewPadding=[[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    txt.leftView=viewPadding;
    txt.leftViewMode=UITextFieldViewModeAlways;
    txt.rightView=viewPadding;
    txt.rightViewMode=UITextFieldViewModeAlways;
    [viewPadding release];
}

+(BOOL)isNumaricPrecision:(NSString *)stringText
{
    const char * _char = [stringText cStringUsingEncoding:NSUTF8StringEncoding];
    int isBackSpace = strcmp(_char, "\b");
    
    if (isBackSpace == -8) {
        // is backspace
        return YES;
    }
    else
    {
        NSCharacterSet *cs;
        cs = [[NSCharacterSet characterSetWithCharactersInString:NUMBERS_ONLY] invertedSet];
        
        NSString *filtered = [[stringText componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        return ([stringText isEqualToString:filtered]);
    }
}

+ (NSString *)getVersion{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

/*!
 @method registerForRemoteNotificationTypesWithNotificationSound
 @abstract To register For Remote Notifications With Notification Sound
 */
+(void)registerForRemoteNotificationTypesWithNotificationSound{
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge)];

}

/*!
 @method turnOffNotificationSound
 @abstract To turn Off Remote Notification Sound
 */
+(void)turnOffRemoteNotificationSound{
    
	[[UIApplication sharedApplication] unregisterForRemoteNotifications]; //First unregister
    
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge)]; // Register without sound
    

}
@end
