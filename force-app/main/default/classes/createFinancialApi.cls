public class createFinancialApi {
   
   public class LeadInfo {
       public createFinancialApi.Lead lead;
       public LeadInfo (createFinancialApi.Lead l) {
           lead = l;            
       }
   }
   
   public class Lead {
       public List<createFinancialApi.contacts_attributes> contacts_attributes;
       public createFinancialApi.accountAttributes account_attributes; 
       public createFinancialApi.loan_attributes loan_attributes;
       public createFinancialApi.application_attributes application_attributes;        
       public Lead(List<createFinancialApi.contacts_attributes> contactsAttributes ,createFinancialApi.accountAttributes aa ,createFinancialApi.loan_attributes la ,createFinancialApi.application_attributes apla) {
           contacts_attributes = contactsAttributes ;
           account_attributes= aa;
           loan_attributes= la;
           application_attributes= apla;
       }
   } 
   
   public class contacts_attributes {       
       public String first_name;        
       public String last_name; 
       public String email; 
       public String title; 
       public String born_on; 
       public String home_phone; 
       public String cell_phone;
       public String ssn; 
       public String ownership_date; 
       public createFinancialApi.current_address_attributes current_address_attributes;  
       public contacts_attributes (createFinancialApi.current_address_attributes currentAddressAttributes ) {
           current_address_attributes = currentAddressAttributes ;            
       }
   } 
   
   public class current_address_attributes {
        public String street1;
        public String street2;
        public String city;
        public String state;
        public String zip ;       
   } 
   
   public class loan_attributes{
        public String company_name;
        public Integer daily_payment_amount;
        public Decimal balance;              
   } 
   
   public class application_attributes{
        public Boolean has_current_loan;  
        public Boolean applicant_is_owner;  
        public string loan_use; 
        public string capital_needed;  
        public string owner_1_percent_ownership; 
        public string owner_2_percent_ownership;  
        public string reference_id; 
        public string notes;            
   } 
   
   
   public class accountAttributes {       
       public String entity_type;        
       public String name; 
       public String started_on; 
       public String legal_name; 
       public String phone; 
       public String email; 
       public String website;
       public String fein; 
       public String monthly_revenue; 
       public String industry_name; 
       public createFinancialApi.current_address_attributes current_address_attributes;  
       public accountAttributes (createFinancialApi.current_address_attributes currentAddressAttributes ) {
           current_address_attributes = currentAddressAttributes ;            
       }
   } 
   
   
   public createFinancialApi () {
       
       createFinancialApi.current_address_attributes cad = new createFinancialApi.current_address_attributes();
       cad.street1='36 Bromfield St';
       cad.street2='Second Floor';
       cad.city='Boston';
       cad.state='MA';
       cad.zip='00112';               
       
       createFinancialApi.contacts_attributes ca = new createFinancialApi.contacts_attributes(cad );
       ca.first_name='';
       ca.last_name='Bachman';
       ca.email='erlich@piedpiper.com';
       ca.title='COO and Spiritual Advisor';
       ca.born_on= '2018-05-01'; //'2015-01-01';
       ca.home_phone='6176781000';
       ca.cell_phone='6176781000';
       ca.ssn='234345566';
       ca.ownership_date='2015-01-01';       
       
       List<createFinancialApi.contacts_attributes> contactsAttribute = new List<createFinancialApi.contacts_attributes>();
       contactsAttribute.add(ca);       
       
       createFinancialApi.accountAttributes accountAttr = new createFinancialApi.accountAttributes(cad );
       accountAttr.entity_type='Limited Liability Company (LLC)';        
       accountAttr.name='Pied Piper'; 
       accountAttr.started_on='2015-01-01'; 
       accountAttr.legal_name='Pied Piper LLC'; 
       accountAttr.phone='6176781000'; 
       accountAttr.email='support@piedpiper.com'; 
       accountAttr.website='https://www.piedpiper.com/';
       accountAttr.fein='000000000'; 
       accountAttr.monthly_revenue='Less than $5,000'; 
       accountAttr.industry_name='Compression Algorithms'; 
       
       createFinancialApi.loan_attributes la = new createFinancialApi.loan_attributes();
       la.company_name='Wells';
       la.daily_payment_amount=25;
       la.balance=15000.23;
       
       createFinancialApi.application_attributes aa = new createFinancialApi.application_attributes();
       aa.has_current_loan=true;  
       aa.applicant_is_owner=true;  
       aa.loan_use='Debt Refinancing'; 
       aa.capital_needed='50000';  
       aa.owner_1_percent_ownership='56'; 
       aa.owner_2_percent_ownership='9';  
       aa.reference_id='1113.3'; 
       aa.notes='We think this is a great deal!';
       
       
       createFinancialApi.Lead l = new createFinancialApi.Lead(contactsAttribute,accountAttr,la,aa );       
       createFinancialApi.LeadInfo lf = new createFinancialApi.LeadInfo (l);
       
       HttpRequest req = new HttpRequest();
       //req.setEndpoint('https://api-staging.forwardfinancing.com/v1/lead'); 
       req.setEndpoint('https://private-anon-0f3f4fb583-forwardfinancingapi.apiary-proxy.com/v1/lead'); 
       req.setMethod('POST');       
       req.setHeader('api_key', 'imMpviY5DhxFQ4Oev8U1e58qfDaE-Ox5lznzdd3-'); 
       req.setHeader('Accept','application/json'); 
       req.setHeader('Content-Length','162100'); 
       req.setHeader('Content-Type','application/json');  
       req.setBody(JSON.serialize(lf)); 
       
       Http http = new Http(); 
       HTTPResponse res; 
       res = http.send(req); 
       system.debug('Staging Response'+ res.getBody());  
       
   }   
    
}