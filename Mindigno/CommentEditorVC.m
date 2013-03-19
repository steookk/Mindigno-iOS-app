//
//  EditorVC.m
//  Mindigno
//
//  Created by Enrico on 18/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "CommentEditorVC.h"
#import "Mindigno.h"

@interface CommentEditorVC ()
 
-(void)exit;

@end

@implementation CommentEditorVC

@synthesize currentMicroPost;

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder: aDecoder];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [textViewContent setDelegate:self];
    [textViewContent becomeFirstResponder];
}

//start UITextViewDelegate
- (void)textViewDidEndEditing:(UITextView *)textView {

    //[textView resignFirstResponder];
}
//stop UITextViewDelegate

- (IBAction)done:(id)sender {

    NSString *textContent = [textViewContent text];
    
    if ([textContent isEqualToString:@""]) {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione!" message:@"Inserisci un commento" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    BOOL sendOK = [[Mindigno sharedMindigno] createNewCommentWithContent:textContent forMicropost: currentMicroPost];
    
    if (sendOK) {
        [self exit];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione!" message:@"Non è stato possibile inviare il commento. Riprova più tardi" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
    }
}

- (IBAction)goBack:(id)sender {
    //NSLog(@"test back");
    
    [self exit];
}

-(void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
