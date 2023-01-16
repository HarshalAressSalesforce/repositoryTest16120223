public class datatablerecords {
	@AuraEnabled public List<SObject> records ;
    @AuraEnabled public List<datatablefilters> filters ;
    @AuraEnabled public String customFilter ;
    @AuraEnabled public integer totalPages ;     
    //@AuraEnabled public integer nextPage =0;
    //@AuraEnabled public integer prevPage =0;
    @AuraEnabled public integer recordsPerPage =10 ;
    @AuraEnabled public integer totalRecords ;
    @AuraEnabled public integer offset =0;
    @AuraEnabled public List<integer> pages;
    
    public static String sql;
    public void prepareData(String ObjectName,String columns,List<datatablefilters> filters,String customFilter,integer currentPage) {
        sql = 'select Id,'+columns;
        String countSql = 'select count() ';
        String fromPart = ' from '+ObjectName;
        List<String> whereParts =  new List<String>();
        whereParts.add('Id !=null'); 
        if(customFilter != '') {
            whereParts.add(customFilter); 
        }
        
        
        if(filters.size()>0) {
            for(datatablefilters  fil : filters) {
                
            }
        }
           
        sql += fromPart;
        String wherePart = '';
        if(whereParts.size()>0) {
            wherePart = ' where '+wherePart;
            
        }
        //offset = (this.currentPage-1) * recordsPerPage;
              
        countSql += fromPart + wherePart;
        sql += wherePart;
        this.totalRecords = Database.countQuery(countSql);        
        
        this.totalPages = this.totalRecords / this.recordsPerPage;
        
        if(Math.Mod(this.totalRecords,this.recordsPerPage) >0) {
            this.totalPages++;
        }
        
         
        
        system.debug('50--->'+currentPage);
        offset = (currentPage-1) * this.recordsPerPage;
        
        sql += ' limit '+this.recordsPerPage+' offset '+offset;  
        this.records = Database.query(sql);
        
        /*this.nextPage = this.currentPage +1;
        this.prevPage = this.currentPage -1;
        
        if(this.prevPage <0) {
            this.prevPage = 0;
        }
        
        if(this.nextPage > this.totalPages) {
            this.nextPage =this.totalPages;
        }
        */
        
        
        
        
        
        this.pages = new List<Integer>();
        for(integer i=1;i<=this.totalPages;i++) {
            this.pages.add(i);
        }
    }
}