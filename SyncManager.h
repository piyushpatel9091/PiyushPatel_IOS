//
//  SyncManager.h
//  Ebizident
//
//  Created by Pritesh Pethani on 10/12/15.
//  Copyright © 2015 Pritesh Pethani. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol SyncManagerDelegate <NSObject>
@required

-(void)syncSuccess:(id) responseObject withTag:(NSInteger)tag;
-(void)syncFailure:(NSError*) error withTag:(NSInteger)tag;

@end

@interface SyncManager : NSObject
{
    // Delegate to respond back
    id <SyncManagerDelegate> _delegate;
    
}
@property (nonatomic,strong) id delegate;

-(void) webServiceCall:(NSString*)url withParams:(NSDictionary*) params withTag:(NSInteger) tag;
-(void) webServiceCallWithOtherParameter:(NSString*)url withParams:(NSDictionary*) params  withTag:(NSInteger) tag withEmailID:(NSString*) emailid withToken:(NSString*) token;
-(void) webServiceCallWithOtherParameterForGetRequest:(NSString*)url withParams:(NSDictionary*) params  withTag:(NSInteger) tag withEmailID:(NSString*) emailid withToken:(NSString*) token;

@end
