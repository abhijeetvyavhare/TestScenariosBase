public with sharing class ContactAddressHelper {

    public static String formatAddress(dmpl__ContactAddress__c address){
        List<String> lines = new List<String>();
        // if(!String.isBlank(address.getStreet())){
        //     lines.add(address.getStreet());
        // }

        // List<String> components = new List<String>();
        // if(!String.isBlank(address.getCity())){
        //     components.add(address.getCity());
        // }
        // if(!String.isBlank(address.getState())){
        //     components.add(address.getState());
        // }
        // if(!String.isBlank(address.getCountry())){
        //     components.add(address.getCountry());
        // }
        // if(!String.isBlank(address.getPostalCode())){
        //     components.add(address.getPostalCode());
        // }
        // if(components.size()>0){
        //     lines.add(String.join(components, ','));
        // }
        if(lines.size()>0){
            return (String.join(lines, '\n'));
        }
        return null;
    }
}