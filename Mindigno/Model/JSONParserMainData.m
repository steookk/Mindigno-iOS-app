//
//  JsonParserMicroPost.m
//  Mindigno
//
//  Created by Enrico on 29/11/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "JSONParserMainData.h"
#import "JsonKeys.h"
#import "Mindigno.h"
#import "NSData+Additions.h"

@interface JSONParserMainData ()

@end

@implementation JSONParserMainData

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (NSMutableArray*) startDownloadFeedAtUrl:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    //Necessary for request to server
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //
    
    ////http basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", API_U, API_P];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    //NSLog(@"'%@'", authValue);
    
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];

    //
    
    //For debug
    //NSString *textJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", textJson);
    
    NSMutableArray *microPosts = nil;
    
    if (data != nil) {
        
        NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //
        
        //It must be done before of all
        [[Mindigno sharedMindigno] setBaseURL: [root_dictionary objectForKey: BASE_URL_KEY]];
        
        NSArray *users_array = [root_dictionary objectForKey: USERS_KEY];
        [[Mindigno sharedMindigno] addUsersFromJsonRoot: users_array];
        //
        
        NSString *current_user_id = [root_dictionary objectForKey: CURRENT_USER_KEY];
        User *current_user = [[Mindigno sharedMindigno] userWithId: current_user_id];
        [[Mindigno sharedMindigno] setCurrentUser: current_user];
        
        //
        NSArray *feeds_array = [root_dictionary objectForKey: MICROPOSTS_KEY];
        microPosts = [NSMutableArray array];
        
        for (NSDictionary *feed_dictionary in feeds_array) {
            
            MicroPost *microPost = [[MicroPost alloc] initWithJsonRoot: feed_dictionary];
            
            //Add to list
            [microPosts addObject:microPost];
        }
    
    } else {
        NSLog(@"No connection: data is nil");
    }
    
    return microPosts;
}

- (NSMutableArray*) startDownloadFeedForUser:(User *)user {
    
    NSURL *url = [NSURL URLWithString: [user userUrl]];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    //Necessary for request to server
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //
    
    ////http basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", API_U, API_P];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    //NSLog(@"'%@'", authValue);
    
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //
    
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:nil error:nil];
    
    //
    
    //For debug
    //NSString *textJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", textJson);
    
    NSMutableArray *microPosts = nil;
    
    if (data != nil) {
        
        NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //
        
        //It must be done before of all
        [[Mindigno sharedMindigno] setBaseURL: [root_dictionary objectForKey: BASE_URL_KEY]];
        
        NSArray *users_array = [root_dictionary objectForKey: USERS_KEY];
        NSMutableArray *arrayUsersAndUser = [NSMutableArray arrayWithArray: users_array];
        //Sarebbe l'utente per la quale si è fatta richiesta
        [arrayUsersAndUser addObject: [root_dictionary objectForKey: USER_KEY]];
        
        [[Mindigno sharedMindigno] addUsersFromJsonRoot: arrayUsersAndUser];
        
        NSString *current_user_id = [root_dictionary objectForKey: CURRENT_USER_KEY];
        User *current_user = [[Mindigno sharedMindigno] userWithId: current_user_id];
        [[Mindigno sharedMindigno] setCurrentUser: current_user];
        
        //
        NSArray *feeds_array = [root_dictionary objectForKey: MICROPOSTS_KEY];
        microPosts = [NSMutableArray array];
        
        for (NSDictionary *feed_dictionary in feeds_array) {
            
            MicroPost *microPost = [[MicroPost alloc] initWithJsonRoot: feed_dictionary];
            
            //Add to list
            [microPosts addObject:microPost];
        }
        
    } else {
        NSLog(@"No connection: data is nil");
    }
    
    return microPosts;
}

- (void) startLoginWithUser:(NSString*)user andPassword:(NSString*)password {

    NSString *urlString = [[Mindigno sharedMindigno] getStringUrlFromStringPath:@"sessions"];
    
    NSDictionary *session = [[NSDictionary alloc] initWithObjectsAndKeys:user, @"email", password, @"password", nil];
    NSDictionary *payload = [[NSDictionary alloc] initWithObjectsAndKeys:session, @"session", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    //For debug
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"XXX: %@", jsonString);

    NSData *postData = jsonData;
    NSString *postDataLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    ////http basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", API_U, API_P];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    //NSLog(@"%@", authValue);
    
    //[urlRequest setValue:@"Basic realm=\"www.mindigno.com\"" forHTTPHeaderField:@"WWW-Authenticate"];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    ////
    
    [urlRequest setHTTPBody: postData];
    [urlRequest setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    
    //
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    /*
    //Modalità funzionante ma bisogna poi parsare la stringona
    NSHTTPURLResponse *HTTPResponse = (NSHTTPURLResponse *)response;
    NSDictionary *fields = [HTTPResponse allHeaderFields];
    
    NSString *cookie = [fields valueForKey:@"Set-Cookie"];
    NSLog(@"cookie: %@", cookies);
     */
    
    /*
     //Non necessario perchè viene gestito tutto dal framework, sia nell'invio della richiesta che nel salvataggio dalla risposta.
     
    NSMutableString *cookie_remember_token = [NSMutableString stringWithString:@""];
    NSMutableString *cookie_session = [NSMutableString stringWithString:@""];
    
    for (NSHTTPCookie *cookie in [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies]) {
        
     
        //Per debug
        //NSLog(@"name: %@",   [cookie name]);
        //NSLog(@"value: %@",  [cookie value]);
        
        if ([[cookie name] isEqualToString: @"remember_token"]) {
            [cookie_remember_token setString: [[cookie value] copy]];
            
        } else if ([[cookie name] isEqualToString: @"_mindigno_session"]) {
            [cookie_session setString: [[cookie value] copy]];
        }
        
    }
    
    NSLog(@"cookie_remember_token: %@", cookie_remember_token);
    NSLog(@"cookie_session: %@", cookie_session);
    */
    
    //Controlla e aggiorna lo stato di login dell'utente
    [[Mindigno sharedMindigno] checkAndUpdateIfUserIsLogged];
    
    ///

    /*
     //Non utile perchè non parsiamo il json per sapere se l'utente è loggato ma ciò viene fatto in base alla presenza del cookie (con stringa != vuota) remember_token
    if (returnData != nil) {
        
        //NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
        
        //For debug
        NSString *textJson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
        NSLog(@"%@", textJson);
    
    } else {
        NSLog(@"returnData is nil");
    }
     */
}

- (void) startLogout {
    
    NSString *urlString = [[Mindigno sharedMindigno] getStringUrlFromStringPath:@"signout"];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    [urlRequest setValue:@"delete" forHTTPHeaderField:@"_method"];
    
    ////http basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", API_U, API_P];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    //NSLog(@"%@", authValue);
    
    //[urlRequest setValue:@"Basic realm=\"www.mindigno.com\"" forHTTPHeaderField:@"WWW-Authenticate"];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    //Controlla e aggiorna lo stato di login dell'utente
    [[Mindigno sharedMindigno] checkAndUpdateIfUserIsLogged];
}

- (SignupResponse*) startSignupWithName:(NSString*)name mail:(NSString*)mail password:(NSString*)password passwordConfirmation:(NSString*)passwordConfirmation {
    
    NSString *urlString = [[Mindigno sharedMindigno] getStringUrlFromStringPath:@"users"];
    
    NSDictionary *session = [[NSDictionary alloc] initWithObjectsAndKeys: name, @"name", mail, @"email", password, @"password", passwordConfirmation, @"password_confirmation", [NSNumber numberWithBool:YES], @"contratto_accettato", nil];
    NSDictionary *payload = [[NSDictionary alloc] initWithObjectsAndKeys:session, @"user", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    NSData *postData = jsonData;
    NSString *postDataLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    [urlRequest setHTTPMethod:@"POST"];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    ///http basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", API_U, API_P];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    //NSLog(@"%@", authValue);
    
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    ///
    
    [urlRequest setHTTPBody: postData];
    [urlRequest setValue:postDataLength forHTTPHeaderField:@"Content-Length"];
    
    //
    
    NSURLResponse *response;
    NSData *returnData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    //Controlla e aggiorna lo stato di login dell'utente. Quando l'utente si registra è anche loggato.
    [[Mindigno sharedMindigno] checkAndUpdateIfUserIsLogged];
    
    ///
    
     //Non utile perchè non parsiamo il json per sapere se l'utente è loggato ma ciò viene fatto in base alla presenza del cookie (con stringa != vuota) remember_token
    SignupResponse *signupResponse = [[SignupResponse alloc] init];
     if (returnData != nil) {
     
         //For debug
         NSString *textJson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
         NSLog(@"%@", textJson);
         
         ///
         
         NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
         [signupResponse setValuesWithJsonRoot:root_dictionary];
         
         NSLog(@"isUserCreated: %d, message: %@", [signupResponse isUserCreated], [signupResponse messageError]);
     
     } else {
         NSLog(@"returnData is nil");
     }
    
    return signupResponse;
}

@end
