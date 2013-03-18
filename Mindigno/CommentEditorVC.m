//
//  EditorVC.m
//  Mindigno
//
//  Created by Enrico on 18/12/12.
//  Copyright (c) 2012 Enrico. All rights reserved.
//

#import "CommentEditorVC.h"

@interface CommentEditorVC ()
 
-(void)exit;

@end

@implementation CommentEditorVC

@synthesize delegate;

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

    if ([delegate respondsToSelector:@selector(textEditor:hasDoneWithText:)]) {
        [delegate textEditor:self hasDoneWithText:[textViewContent text]];
    }
    
    [self exit];
}

- (IBAction)goBack:(id)sender {
    NSLog(@"test back");
    [self exit];
}

-(void)exit {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
