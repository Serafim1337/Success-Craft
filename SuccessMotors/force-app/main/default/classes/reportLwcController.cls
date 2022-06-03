public with sharing class reportLwcController {
    public reportLwcController() {

    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        
        return [SELECT Name, (SELECT Id, Name, Amount FROM Opportunities WHERE IsClosed=TRUE AND IsWon=TRUE)      
        FROM Account
        WITH SECURITY_ENFORCED];


        // return [SELECT Name, (SELECT SUM(Amount) FROM Opportunities WHERE IsClosed=TRUE AND IsWon=TRUE)
        // FROM Account
        // WITH SECURITY_ENFORCED
        // ];
    }
}
