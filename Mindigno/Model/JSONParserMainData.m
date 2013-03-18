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


+ (NSMutableArray*) startDownloadFeedAtUrl:(NSString *)urlString thereIsUserField:(BOOL)yesOrNot {
    
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
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    //NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //int statusCode = [httpResponse statusCode];
    //
    
    //For debug
    //NSString *textJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@\n\n", textJson);
    
    NSMutableArray *microPosts = nil;
    
    //NSLog(@"data length: %d\n", [data length]);
    //Non 0 perchè comunque ritorna uno spazio bianco
    BOOL dataIsEmpty = ([data length] <= 1);
    if (data != nil && !dataIsEmpty) {
        
        NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //
        
        //It must be done before of all
        [[Mindigno sharedMindigno] setBaseURL: [root_dictionary objectForKey: BASE_URL_KEY]];
        
        NSArray *users_array = [root_dictionary objectForKey: USERS_KEY];
        [[Mindigno sharedMindigno] addUsersFromJsonRoot: users_array];
        
        NSString *current_user_id = [root_dictionary objectForKey: CURRENT_USER_KEY];
        User *user = [[Mindigno sharedMindigno] userWithId: current_user_id];
        [[Mindigno sharedMindigno] setCurrentUser: user];
        
        if (yesOrNot) {
            
            NSDictionary *dict_user = [root_dictionary objectForKey: USER_KEY];
            NSString *currentUserID = [dict_user objectForKey: USER_ID_KEY];
            
            //Se l'utente ricevuto è l'utente correntemente loggato, allora aggiorno le sue informazioni
            if ([user.userID isEqualToString: currentUserID]) {
                [user addMoreUserInfoWithJsonRoot: dict_user];
            
            } else {
                //Altrimenti si è fatta richiesta di un altro utente
                User *requestedUser = [[Mindigno sharedMindigno] userWithId: currentUserID];
                [requestedUser addMoreUserInfoWithJsonRoot: dict_user];
            }
        }
        
        //
        NSArray *feeds_array = [root_dictionary objectForKey: MICROPOSTS_KEY];
        microPosts = [NSMutableArray array];
        
        for (NSDictionary *feed_dictionary in feeds_array) {
            
            MicroPost *microPost = [[MicroPost alloc] initWithJsonRoot: feed_dictionary];
            
            //Add to list
            [microPosts addObject:microPost];
        }
        
    } else if (data != nil && dataIsEmpty) {
        NSLog(@"dataIsEmpty");
        
    } else {
        NSLog(@"No connection: data is nil");
    }
    
    return microPosts;
}

///

+ (BOOL) startLoginWithUser:(NSString*)user andPassword:(NSString*)password {

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
    
    //For debug
    NSString *textJson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", textJson);

    BOOL returnValue = NO;
    
    //Non utile perchè non parsiamo il json per sapere se l'utente è loggato ma ciò viene fatto in base alla presenza del cookie (con stringa != vuota) remember_token
    if (returnData != nil) {
        
        NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];

        //
        
        NSDictionary *dict_user = [root_dictionary objectForKey: USER_KEY];
        
        if (dict_user != nil) {
            User *user = [[User alloc] initWithJsonRoot: dict_user];
            
            //Setto l'utente corrente
            [[Mindigno sharedMindigno] setCurrentUser: user];
            //Aggiungo l'utente nel dizionario
            [[[Mindigno sharedMindigno] idToUser_dictionary] setObject:user forKey:[user userID]];
            
            returnValue = YES;
        }
    
    } else {
        NSLog(@"returnData is nil");
    }
    
    return returnValue;
}

+ (BOOL) startLogout {
    
    NSString *urlString = [[Mindigno sharedMindigno] getStringUrlFromStringPath:@"signout"];
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    [urlRequest setHTTPMethod:@"DELETE"];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //[urlRequest setValue:@"delete" forHTTPHeaderField:@"_method"];
    
    ////http basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", API_U, API_P];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    //NSLog(@"%@", authValue);
    
    //[urlRequest setValue:@"Basic realm=\"www.mindigno.com\"" forHTTPHeaderField:@"WWW-Authenticate"];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //
    
    NSURLResponse *response;
    //Non ritorna nessun dato
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int statusCode = [httpResponse statusCode];
    
    //Controlla e aggiorna lo stato di login dell'utente
    [[Mindigno sharedMindigno] checkAndUpdateIfUserIsLogged];
    
    if (statusCode == 200) {
        return YES;
    
    } else {
        return NO;
    }
}

+ (SignupResponse*) startSignupWithName:(NSString*)name mail:(NSString*)mail password:(NSString*)password passwordConfirmation:(NSString*)passwordConfirmation {
    
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
    
    //For debug
    //NSString *textJson = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@\n\n", textJson);
    
     //Non utile perchè non parsiamo il json per sapere se l'utente è loggato ma ciò viene fatto in base alla presenza del cookie (con stringa != vuota) remember_token
    SignupResponse *signupResponse = [[SignupResponse alloc] init];
     if (returnData != nil) {
         NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:returnData options:kNilOptions error:nil];
         
         //
         NSDictionary *dict_user = [root_dictionary objectForKey: USER_KEY];
         
         if (dict_user != nil) {
             User *user = [[User alloc] initWithJsonRoot: dict_user];
             
             //Setto l'utente corrente
             [[Mindigno sharedMindigno] setCurrentUser: user];
             //Aggiungo l'utente nel dizionario
             [[[Mindigno sharedMindigno] idToUser_dictionary] setObject:user forKey:[user userID]];
             
             [signupResponse setIsUserCreatedAndLogged: YES];
         
         } else {
             [signupResponse setIsUserCreatedAndLogged: NO];
             [signupResponse setMessageError: [root_dictionary objectForKey: SIGNUP_MESSAGE_KEY]];
         }
     
     } else {
         NSLog(@"returnData is nil");
     }
    
    return signupResponse;
}

///

+ (BOOL) startIndignatiSulMicroPostConID:(NSString*)micropostID {
    
    NSString *urlString = [[Mindigno sharedMindigno] getStringUrlFromStringPath:@"indignazioni"];
        
    NSDictionary *micropost = [[NSDictionary alloc] initWithObjectsAndKeys: micropostID, @"id", nil];
    NSDictionary *payload = [[NSDictionary alloc] initWithObjectsAndKeys:micropost, @"micropost", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    //For debug
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", jsonString);
    
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
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int statusCode = [httpResponse statusCode];
    
    if (statusCode == 200) {
        return YES;
        
    } else {
        return NO;
    }
}

+ (BOOL) startRimuoviIndignazioneSulMicroPostConID:(NSString*)micropostID {
    
    NSString *urlString = [[[Mindigno sharedMindigno] getStringUrlFromStringPath:@"indignazioni"] stringByAppendingPathComponent: micropostID];
    //NSLog(@"url rimuovi indignazione: %@", urlString);
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    [urlRequest setHTTPMethod:@"DELETE"];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //[urlRequest setValue:@"delete" forHTTPHeaderField:@"_method"];
    
    ////http basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", API_U, API_P];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    //NSLog(@"%@", authValue);
    
    //[urlRequest setValue:@"Basic realm=\"www.mindigno.com\"" forHTTPHeaderField:@"WWW-Authenticate"];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //
    
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int statusCode = [httpResponse statusCode];
    
    if (statusCode == 200) {
        return YES;
        
    } else {
        return NO;
    }
}

//

+ (void) startDownloadAllIndignatiForMicropost:(MicroPost*)micropost {
    
    NSString *urlString = [[micropost micropostUrl] stringByAppendingPathComponent:@"indignati"];
    NSLog(@"startDownloadAllIndignatiForMicropost url: %@", urlString);
    
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
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    //NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //int statusCode = [httpResponse statusCode];
    //
    
    //For debug
    //NSString *textJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //NSLog(@"%@\n\n", textJson);
    
    //NSLog(@"data length: %d\n", [data length]);
    //Non 0 perchè comunque ritorna uno spazio bianco
    BOOL dataIsEmpty = ([data length] <= 1);
    if (data != nil && !dataIsEmpty) {
        
        NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //
        NSArray *users_array = [root_dictionary objectForKey: USERS_KEY];
        [[Mindigno sharedMindigno] addUsersFromJsonRoot: users_array];
        
        [micropost addAllIndignati: [root_dictionary objectForKey: USERS_KEY]];
        
    } else if (data != nil && dataIsEmpty) {
        NSLog(@"dataIsEmpty");
        
    } else {
        NSLog(@"No connection: data is nil");
    }
}

///

+ (BOOL) startFollowUserWithID:(NSString*)userID {
    
    NSString *urlString = [[Mindigno sharedMindigno] getStringUrlFromStringPath:@"relationships"];
    
    NSDictionary *micropost = [[NSDictionary alloc] initWithObjectsAndKeys: userID, @"id", nil];
    NSDictionary *payload = [[NSDictionary alloc] initWithObjectsAndKeys:micropost, @"user", nil];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:payload options:0 error:nil];
    
    //For debug
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    //NSLog(@"%@", jsonString);
    
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
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int statusCode = [httpResponse statusCode];
    
    if (statusCode == 200) {
        return YES;
        
    } else {
        return NO;
    }
}

+ (BOOL) startRemoveFollowedUserWithID:(NSString*)userID {
    
    NSString *urlString = [[[Mindigno sharedMindigno] getStringUrlFromStringPath:@"relationships"] stringByAppendingPathComponent: userID];
    //NSLog(@"url rimuovi indignazione: %@", urlString);
    
    NSURL *url = [NSURL URLWithString: urlString];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    //NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:10.0];
    
    [urlRequest setHTTPMethod:@"DELETE"];
    
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //[urlRequest setValue:@"delete" forHTTPHeaderField:@"_method"];
    
    ////http basic authentication
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", API_U, API_P];
    NSData *authData = [authStr dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64Encoding]];
    //NSLog(@"%@", authValue);
    
    //[urlRequest setValue:@"Basic realm=\"www.mindigno.com\"" forHTTPHeaderField:@"WWW-Authenticate"];
    [urlRequest setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    //
    
    NSURLResponse *response;
    [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    int statusCode = [httpResponse statusCode];
    
    if (statusCode == 200) {
        return YES;
        
    } else {
        return NO;
    }
}

///

+ (NSArray*) startDownloadUsersWithUrl:(NSString*)urlString {
    
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
    NSURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&response error:nil];
    
    //NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
    //int statusCode = [httpResponse statusCode];
    //
    
    //For debug
    NSString *textJson = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSLog(@"%@\n\n", textJson);
    
    NSMutableArray* arrayUsers = [NSMutableArray array];
    
    BOOL dataIsEmpty = ([data length] <= 1);
    if (data != nil && !dataIsEmpty) {
        
        NSDictionary *root_dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
        
        //
        NSArray *users_array = [root_dictionary objectForKey: USERS_KEY];
        [[Mindigno sharedMindigno] addUsersFromJsonRoot: users_array];
        
        for (NSDictionary *user_dictionary in users_array) {
            User *user = [[Mindigno sharedMindigno] userWithId: [user_dictionary objectForKey: USER_ID_KEY]];
            [arrayUsers addObject: user];
        }
        
    } else if (data != nil && dataIsEmpty) {
        NSLog(@"dataIsEmpty");
        
    } else {
        NSLog(@"No connection: data is nil");
    }
    
    return arrayUsers;
}

@end
