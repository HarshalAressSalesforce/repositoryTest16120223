@isTest
public class PicklistFieldControllerTest {    
    static testMethod void getDependentOptionsImplTest(){
        PicklistFieldController controller = new PicklistFieldController();
        Map<String,List<String>> valueMap = controller.getDependentOptionsImpl('Account','ShippingCountryCode','ShippingStateCode');
        for(String contr : valueMap.keySet()){
            System.debug('CONTROLLING FIELD : ' + contr);
            System.debug('DEPENDENT VALUES ...  : ' + valueMap.get(contr));
        }
    }

}