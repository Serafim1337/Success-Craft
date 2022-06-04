public with sharing class reportLwcController {

    public static List<Account> CACHED_ACCOUNTS = null;

    public static List<Account> mapAccountToOpportunities() {

        if(CACHED_ACCOUNTS == null) {

        List<Account> accounts = [SELECT Name, Closed_Opportunities_Sum__c, (SELECT Id, Name, Amount, CreatedDate, CloseDate FROM Opportunities WHERE IsClosed=TRUE AND IsWon=TRUE)      
        FROM Account
        WITH SECURITY_ENFORCED];
        
        List<AggregateResult> sums = [SELECT AccountId,SUM(Amount)
        FROM Opportunity
        WHERE AccountId IN : accounts AND IsClosed=TRUE AND IsWon=TRUE
        WITH SECURITY_ENFORCED                             
        GROUP BY AccountId
        ];

        List<Account> accsToUpdate = new List<Account>();

        for(Account a : accounts) {
            
                for(AggregateResult s : sums) {
                    if(s.get('AccountId') == a.Id) {
                        a.Closed_Opportunities_Sum__c =(Decimal) s.get('expr0');
                        accsToUpdate.add(a);
                    }
                }
            
        }

        CACHED_ACCOUNTS = accounts;

        return accounts;

        } else {
            return CACHED_ACCOUNTS;
        }
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {

       return mapAccountToOpportunities();
    }

    @AuraEnabled(cacheable=true)
    public static List<Account> searchAccounts(String searchTerm) {

        searchTerm = searchTerm.trim();

        if (searchTerm == '') {
            return getAccounts();
        }

        Decimal decimalTerm = null;

        try{
            decimalTerm = Decimal.valueOf(searchTerm);
        } catch(TypeException e) {

        }

        // searchTerm = '%' + searchTerm + '%';

        // return [SELECT Name, (SELECT Id, Name, Amount, CreatedDate, CloseDate FROM Opportunities WHERE IsClosed=TRUE AND IsWon=TRUE)      
        // FROM Account
        // WHERE Name Like :searchTerm
        // WITH SECURITY_ENFORCED];

        List<Account> accountsToSearch = mapAccountToOpportunities();
        List<Account> accountsToReturn = new List<Account>();

        if(decimalTerm == null) {
            for(Account a : accountsToSearch) {
                if(a.Name.toLowerCase().contains(searchTerm.toLowerCase())) {
                    accountsToReturn.add(a);
                }
            } 
        } else {
            for(Account a : accountsToSearch) {
                if((Decimal)a.Closed_Opportunities_Sum__c >= decimalTerm) {
                    accountsToReturn.add(a);
                }
            } 
        }

        return accountsToReturn;
    }
}
