public class dataTableCon {

    List<Account> accounts;

    public List<Account> getAccounts() {
        if(accounts == null)
            accounts = [SELECT name, owner.name FROM account ];
        return accounts;
    }

}