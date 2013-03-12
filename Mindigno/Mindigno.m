//
//  Mindigno.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "Mindigno.h"
#import "JSONParserMainData.h"

@implementation Mindigno

@synthesize currentUser, idToUser_dictionary, baseURL, isLoggedUser;

+ (id)sharedMindigno {
    static Mindigno *sharedMindigno = nil;

    @synchronized(self) {
        if (sharedMindigno == nil) {
            sharedMindigno = [[self alloc] init];
        }
    }
    return sharedMindigno;
}

- (BOOL) checkAndUpdateIfUserIsLogged {

    BOOL isLogged = NO;
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
        if ([[cookie name] isEqualToString: @"remember_token"]) {
            
            if (![[cookie value] isEqualToString:@""]) {
                isLogged = YES;
            }
        }
    }
    
    isLoggedUser = isLogged;
    
    return isLogged;
}

- (id) init {
    self = [super init];
    if (self) {
        
        currentUser = nil;
        microPosts = [NSMutableArray array];
        idToUser_dictionary = [NSMutableDictionary dictionary];
        
        [self checkAndUpdateIfUserIsLogged];
        //NSLog(@"USER LOGGED: %d", isLoggedUser);
    }
    
    return self;
}

///

- (NSArray *) microPosts {

    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    NSMutableArray *microposts_to_return = [jsonParser startDownloadFeedAtUrl: URL_JSON_MICROPOST_TEST];
    
    [microPosts removeAllObjects];
    [microPosts setArray: microposts_to_return];
    
    return microPosts;
}

- (NSArray *) microPostsOfUser:(User*)user {
    
    //NSString *urlForRequest = [user userUrl];
    //NSLog(@"urlForRequest user: %@", urlForRequest);
    
    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    NSMutableArray *microposts_to_return = [jsonParser startDownloadFeedForUser: user];
    
    return microposts_to_return;
}

- (void) addUsersFromJsonRoot:(NSArray*)users {
    
    for (NSDictionary *user_dictionary in users) {
        
        User *user = [[User alloc] initWithJsonRoot:user_dictionary];
        
        if ([idToUser_dictionary objectForKey: [user userID]] == nil) {
            [idToUser_dictionary setObject:user forKey: [user userID]];
        
        } else {
            [idToUser_dictionary setObject:user forKey: [user userID]];
        }
    }
}

- (User*) userWithId:(NSString*)userId {
    User *retUser = [idToUser_dictionary objectForKey: userId];
    
    return retUser;
}

- (void) shareInfo:(UIViewController*)controller {
    
    NSString *textToShare = @"I just shared this from my App";
    UIImage *imageToShare = [UIImage imageNamed:@"Default.png"];
    NSURL *urlToShare = [NSURL URLWithString:@"http://www.bronron.com"];
    
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities: nil];
    
    //This is an array of excluded activities to appear on the UIActivityViewController
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    [controller presentViewController:activityVC animated:YES completion:nil];
}

- (NSString*) getStringUrlFromStringPath:(NSString*)path {
    return [baseURL stringByAppendingPathComponent:path];
}

@end
