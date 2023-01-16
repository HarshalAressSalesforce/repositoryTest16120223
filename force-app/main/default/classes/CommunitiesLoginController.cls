/**************************************************************************************
 * Author   : KPMG
 * Date     :
 * Purpose  : An apex page controller that exposes the site login functionality
 * Last Modified : 20th feb 2018
 * By		: KPMG
***************************************************************************************/

global with sharing class CommunitiesLoginController {
    
    public String password { get; set; }
    public String username { get; set; }
    
    global CommunitiesLoginController () {
        username = '';
        password = '';
        //showMsg();
        //system.debug('*****In system debug show msg');
    }
    
    global PageReference forwardToAuthPage() {
        
        String startUrl = System.currentPageReference().getParameters().get('startURL');
        String displayType = System.currentPageReference().getParameters().get('display');
        return Network.forwardToAuthPage(startUrl, displayType);
        
    }
    
    /*global PageReference showMsg(){
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'Please enter value'));
        return null;
    }*/
    
    global PageReference RedirectToLogin() {
        return Site.login(username, password,'/NeedSupport');
        /* 'NeedSupport'  is the Page to which we will be redirected after Login */ 
        
    }
    
    public PageReference loginUser() {
        if(username == '' || username == null){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'Username cannot be blank' + username));
            return null;
        }
        else if(password == null || password == ''){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.error, 'Password cannot be blank'));
            return null;
        }
        else
            return Site.login(username, password,'/CommunitiesLanding');
          //  return Site.login(username, password,'/NeedSupport');
        /* 'NeedSupport'  is the Page to which we will be redirected after Login */
        
    }
    
    public PageReference forgotpswd() {
        //pageReference pg = new pageReference('/apex/forgotpassword');
        //Page.setRedirect(true);
        return new pageReference('/apex/ForgotPassword');
        boolean success = Site.ForgotPassword(username);
        PageReference pr = Page.ForgotPasswordConfirm;
        pr.setRedirect(true);
        
        if (success) {        
            return pr;
        }
        return null;    
    } 
}