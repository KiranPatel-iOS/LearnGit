//
//  HomeViewController.m
//  BLELinkedinPOC
//
//  Created by Kiran Patel on 06/05/14.
//  Copyright (c) 2014 Solution Analysts Pvt. Ltd. All rights reserved.
//

#import "HomeViewController.h"
#import "NearByUsersViewController.h"

#import "AFHTTPRequestOperation.h"
#import "LIALinkedInHttpClient.h"
#import "LIALinkedInApplication.h"


#define LINKEDIN_CLIENT_ID      @"75t8r3og8tcei0"
#define LINKEDIN_CLIENT_SECRET  @"giYo1UkUblCs7hZX"
#define LINKEDIN_REDIRECT_URI   @"https://www.solutionanalysts.com"

@interface HomeViewController ()    <CBPeripheralManagerDelegate>
{
    IBOutlet UIView         * IBviewButtonContainer;
    IBOutlet UIButton       * IBbtnConnectLinkdIn;
    IBOutlet UIButton       * IBbtnFindNearByUsers;
    IBOutlet UIScrollView   * IBscrollMain;
    IBOutlet UIView         * IBviewUserData;
    IBOutlet UILabel        * IBlblUserName;
    IBOutlet UILabel        * IBlblUserHeadLine;
    IBOutlet UIButton       * IBbtnCheckLinkdInProfile;

    LIALinkedInHttpClient *_client;
    
    NSString *sUrlUserProfile;
    NSDictionary *dicDataToSendOther;
}
    @property (strong, nonatomic) CBPeripheralManager       *peripheralManager;
    @property (strong, nonatomic) CBMutableCharacteristic   *transferCharacteristic;
    @property (strong, nonatomic) NSData                    *dataToSend;
    @property (nonatomic, readwrite) NSInteger              sendDataIndex;

@end
    
    
    
#define NOTIFY_MTU      20
    
BOOL handlingRedirectURL;

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    IBviewUserData.layer.cornerRadius = 5.0f;
    IBviewButtonContainer.layer.cornerRadius = 5.0f;
    
    _client = [self client];
    self.title=APP_TITLE;
   
    if ([Helper getPREF:PREF_IS_USER_LOGGED_IN]) {
        IBbtnConnectLinkdIn.enabled=FALSE;
    }else{
        IBviewUserData.hidden=TRUE;
    }

    // Start up the CBPeripheralManager
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    if (!self.peripheralManager.isAdvertising) {
        dicDataToSendOther = @{@"name": @"Default Username", @"headline" :@"Testing"};
        self.dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dicDataToSendOther];
        
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];
    }
    [super viewWillAppear:animated];
}


- (void)viewWillDisappear:(BOOL)animated
{
    // Don't keep it going while we're not showing.
    if (self.peripheralManager.isAdvertising) {
        [self.peripheralManager stopAdvertising];
    }
    [super viewWillDisappear:animated];
}


#pragma - Button Action Events
- (IBAction)IBcheckUserLinkedInProfile{
    [SHARED_APP openURL:[NSURL URLWithString:sUrlUserProfile]];
}

- (IBAction)IBfindNearByUsers{
    NearByUsersViewController * nearByUsersViewController = [NearByUsersViewController new];
    [self.navigationController pushViewController:nearByUsersViewController animated:TRUE];
}

- (IBAction)IBconnectWithLinkedIn{
    [self.client getAuthorizationCode:^(NSString *code) {
        NSLog(@"AUTH CODE :%@",code);
        [self.client getAccessToken:code success:^(NSDictionary *accessTokenData) {
        NSLog(@"Access Token Data :%@",accessTokenData);
            NSString *accessToken = [accessTokenData objectForKey:@"access_token"];
            [self requestMeWithToken:accessToken];
        }                   failure:^(NSError *error) {
            NSLog(@"Quering accessToken failed %@", error);
        }];
    }                      cancel:^{
        NSLog(@"Authorization was cancelled by user");
    }                     failure:^(NSError *error) {
        NSLog(@"Authorization failed %@", error);
    }];
}


- (void)requestMeWithToken:(NSString *)accessToken {
    [self.client GET:[NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~?oauth2_access_token=%@&format=json", accessToken] parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary *result) {
        NSLog(@"current user %@", result);
        NSString *sUserName = [NSString stringWithFormat:@"%@ %@",[result valueForKey:@"firstName"],[result valueForKey: @"lastName"]];
        NSString *sUserHeadLine = [result valueForKey:@"headline"];
        sUrlUserProfile = [[result valueForKey:@"siteStandardProfileRequest"] valueForKey:@"url"];
        
        IBbtnConnectLinkdIn.enabled=FALSE;
        IBlblUserName.text = sUserName;
        IBlblUserHeadLine.text = sUserHeadLine;
        IBviewUserData.hidden = FALSE;

        dicDataToSendOther = @{@"name": sUserName, @"headline" :sUserHeadLine};
        self.dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dicDataToSendOther];
        
        [self.peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID]] }];

    }        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"failed to fetch current user %@", error);
    }];
}

- (LIALinkedInHttpClient *)client {
    LIALinkedInApplication *application = [LIALinkedInApplication applicationWithRedirectURL:LINKEDIN_REDIRECT_URI  clientId:LINKEDIN_CLIENT_ID
                                                                                clientSecret:LINKEDIN_CLIENT_SECRET
                                                                                       state:@"DCEEFWF45453sdffef424"
                                                                               grantedAccess:@[@"r_basicprofile%20r_fullprofile%20r_emailaddress%20r_contactinfo"]];
    return [LIALinkedInHttpClient clientForApplication:application presentingViewController:nil];
}



#pragma mark - Peripheral Methods



/** Required protocol method.  A full app should take care of all the possible states,
 *  but we're just waiting for  to know when the CBPeripheralManager is ready
 */
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    // Opt out from any other state
    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }
    
    // We're in CBPeripheralManagerStatePoweredOn state...
    NSLog(@"self.peripheralManager powered on.");
    
    // ... so build our service.
    
    // Start with the CBMutableCharacteristic
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_CHARACTERISTIC_UUID]
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
    
    // Then the service
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:TRANSFER_SERVICE_UUID] primary:YES];
    
    // Add the characteristic to the service
    transferService.characteristics = @[self.transferCharacteristic];
    
    // And add it to the peripheral manager
    [self.peripheralManager addService:transferService];
}


/** Catch when someone subscribes to our characteristic, then start sending them data
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central subscribed to characteristic");
    
    // Get the data
    self.dataToSend = [NSKeyedArchiver archivedDataWithRootObject:dicDataToSendOther];
    
    // Reset the index
    self.sendDataIndex = 0;
    
    // Start sending
    [self sendData];
}


/** Recognise when the central unsubscribes
 */
- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"Central unsubscribed from characteristic");
}


/** Sends the next amount of data to the connected central
 */
- (void)sendData
{
    // First up, check if we're meant to be sending an EOM
    static BOOL sendingEOM = NO;
    
    if (sendingEOM) {
        
        // send it
        BOOL didSend = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        // Did it send?
        if (didSend) {
            
            // It did, so mark it as sent
            sendingEOM = NO;
            
            NSLog(@"Sent: EOM");
        }
        
        // It didn't send, so we'll exit and wait for peripheralManagerIsReadyToUpdateSubscribers to call sendData again
        return;
    }
    
    // We're not sending an EOM, so we're sending data
    
    // Is there any left to send?
    
    if (self.sendDataIndex >= self.dataToSend.length) {
        
        // No data left.  Do nothing
        return;
    }
    
    // There's data left, so send until the callback fails, or we're done.
    
    BOOL didSend = YES;
    
    while (didSend) {
        
        // Make the next chunk
        
        // Work out how big it should be
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        
        // Can't be longer than 20 bytes
        if (amountToSend > NOTIFY_MTU) amountToSend = NOTIFY_MTU;
        
        // Copy out the data we want
        NSData *chunk = [NSData dataWithBytes:self.dataToSend.bytes+self.sendDataIndex length:amountToSend];
        
        // Send it
        didSend = [self.peripheralManager updateValue:chunk forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
        
        // If it didn't work, drop out and wait for the callback
        if (!didSend) {
            return;
        }
        
        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);
        
        // It did send, so update our index
        self.sendDataIndex += amountToSend;
        
        // Was it the last one?
        if (self.sendDataIndex >= self.dataToSend.length) {
            
            // It was - send an EOM
            
            // Set this so if the send fails, we'll send it next time
            sendingEOM = YES;
            
            // Send it
            BOOL eomSent = [self.peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
            
            if (eomSent) {
                // It sent, we're all done
                sendingEOM = NO;
                
                NSLog(@"Sent: EOM");
            }
            
            return;
        }
    }
}


/** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
 *  This is to ensure that packets will arrive in the order they are sent
 */
- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
    // Start sending again
    [self sendData];
}


#pragma mark - Other Methods
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
