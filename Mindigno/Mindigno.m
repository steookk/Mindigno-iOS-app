//
//  Mindigno.m
//  Mindigno
//
//  Created by Enrico on 13/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "Mindigno.h"
#import "JSONParserMainData.h"
#import "LoginSignupVC.h"

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

    NSString *url = URL_JSON_MICROPOST_TEST;
    
    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    NSMutableArray *microposts_to_return = [jsonParser startDownloadFeedAtUrl: url];
    
    [microPosts removeAllObjects];
    [microPosts setArray: microposts_to_return];
    
    return microPosts;
}

- (NSArray *) moreOldMicroPosts {

    NSString *url = [URL_JSON_MICROPOST_TEST stringByAppendingPathComponent: [NSString stringWithFormat:@"users/%@/profile_feed?from=%d", [[self currentUser] userID], [microPosts count]]];
    
    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    NSMutableArray *microposts_to_return = [jsonParser startDownloadFeedAtUrl: url];
    
    [microPosts addObjectsFromArray: microposts_to_return];
    
    return microPosts;
}

- (NSArray *) microPostsOfUser:(User*)user {
    
    //NSString *urlForRequest = [user userUrl];
    //NSLog(@"urlForRequest user: %@", urlForRequest);
    
    JSONParserMainData *jsonParser = [[JSONParserMainData alloc] init];
    NSMutableArray *microposts_to_return = [jsonParser startDownloadFeedForUser: user];
    
    return microposts_to_return;
}

- (NSArray *) moreOldMicroPostsOfUser:(User*)user {

}

- (void) addUsersFromJsonRoot:(NSArray*)users {
    
    for (NSDictionary *user_dictionary in users) {
        
        User *user = [[User alloc] initWithJsonRoot:user_dictionary];
        
        if ([idToUser_dictionary objectForKey: [user userID]] == nil) {
            [idToUser_dictionary setObject:user forKey: [user userID]];
        
        } else {
            
            User *existentUser = [idToUser_dictionary objectForKey: [user userID]];
            [existentUser setInfoWithJsonRoot: user_dictionary];
            
            //[idToUser_dictionary setObject:user forKey: [user userID]];
        }
    }
}

- (User*) userWithId:(NSString*)userId {
    User *retUser = [idToUser_dictionary objectForKey: userId];
    
    return retUser;
}

- (void) shareInfoOnViewController:(UIViewController*)controller {
    
    [self shareInfoOnViewController:controller withText:@"I just shared this from my App" imageName:@"Icon.png" url:@"http://www.bronron.com"];
}

- (void) shareInfoOnViewController:(UIViewController*)controller withText:(NSString*)text imageName:(NSString*)image url:(NSString*)url {

    NSString *textToShare = text;
    UIImage *imageToShare;
    if (image != nil) {
        imageToShare = [UIImage imageNamed: image];
    } else {
        imageToShare = [UIImage imageNamed: @"Icon.png"];
    }
    
    NSURL *urlToShare = [NSURL URLWithString: url];
    
    NSArray *activityItems = @[textToShare, imageToShare, urlToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities: nil];
    
    //This is an array of excluded activities to appear on the UIActivityViewController
    activityVC.excludedActivityTypes = @[UIActivityTypePostToWeibo, UIActivityTypePrint, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    [controller presentViewController:activityVC animated:YES completion:nil];
}

- (NSString*) getStringUrlFromStringPath:(NSString*)path {
    return [baseURL stringByAppendingPathComponent:path];
}

- (UIViewController *) apriModaleLogin {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginStoryboard" bundle:[NSBundle mainBundle]];
    
    UINavigationController *navController = (UINavigationController *)[storyboard instantiateInitialViewController];
    LoginSignupVC *loginSignupVC = (LoginSignupVC *)[navController topViewController];
    [loginSignupVC setDelegate: self];
    
    return navController;
}

@end
