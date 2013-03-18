//
//  MicroPostEditorVC.m
//  Mindigno
//
//  Created by Enrico on 08/03/13.
//  Copyright (c) 2013 Enrico. All rights reserved.
//

#import "MicroPostEditorVC.h"
#import "Mindigno.h"

@interface MicroPostEditorVC ()

@end

@implementation MicroPostEditorVC

- (void)viewDidLoad {
    [super viewDidLoad];
	
    [textViewTitolo setDelegate: self];
    [textViewDescrizione setDelegate: self];
    
    [textViewTitolo setText: DEFAULT_TITOLO];
    [textViewDescrizione setText: DEFAULT_DESCRIZIONE];
}

//Start UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    NSString *currentText = [textView text];
    
    if (textView == textViewTitolo) {
        
        if ([currentText isEqualToString: DEFAULT_TITOLO]) {
            [textView setText:@""];
            [labelCounterCharTitolo setText: [NSString stringWithFormat:@"0/%d", MAX_CHAR_TITOLO]];
        }
        
    } else if (textView == textViewDescrizione) {
        
        if ([currentText isEqualToString: DEFAULT_DESCRIZIONE]) {
            [textView setText:@""];
            [labelCounterCharDescrizione setText: [NSString stringWithFormat:@"0/%d", MAX_CHAR_DESCRIZIONE]];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    
    NSString *currentText = [textView text];
    int textLen = [currentText length];
    
    if (textView == textViewTitolo) {
        
        if (textLen <= MAX_CHAR_TITOLO) {
            [labelCounterCharTitolo setText: [NSString stringWithFormat:@"%d/%d", textLen, MAX_CHAR_TITOLO]];
        } else {
            [textView setText: [currentText substringWithRange:NSMakeRange(0, MAX_CHAR_TITOLO)]];
        }
    
    } else if (textView == textViewDescrizione) {
        
        if (textLen <= MAX_CHAR_DESCRIZIONE) {
            [labelCounterCharDescrizione setText: [NSString stringWithFormat:@"%d/%d", textLen, MAX_CHAR_DESCRIZIONE]];
        } else {
            [textView setText: [currentText substringWithRange:NSMakeRange(0, MAX_CHAR_DESCRIZIONE)]];
        }
    }
}
//Stop UITextViewDelegate

- (IBAction)done:(id)sender {
    
    NSString *textTitolo = [textViewTitolo text];
    NSString *textDescrizione = [textViewDescrizione text];
    
    if ([textTitolo isEqualToString: @""] || [textTitolo isEqualToString: DEFAULT_TITOLO]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Attenzione!" message:DEFAULT_TITOLO delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [alert show];
        
        return;
    }
    
    //Può essere opzionale.
    if ([textDescrizione isEqualToString: DEFAULT_DESCRIZIONE]) {
        textDescrizione = @"";
    }
    
    //TODO: richiesta e se ok, esce.
    MicroPost *micropostCreated = [[Mindigno sharedMindigno] createNewMicropostWithTitle: textTitolo andDescription:textDescrizione];
    BOOL sendOK = (micropostCreated != nil);
    
    if (sendOK) {
        
        User *currentUser = [[Mindigno sharedMindigno] currentUser];
        
        
        [currentUser addMicropost: micropostCreated];
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)goBack:(id)sender {
    
    //[[self navigationController] popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
