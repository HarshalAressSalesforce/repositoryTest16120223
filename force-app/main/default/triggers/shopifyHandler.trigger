trigger shopifyHandler on Product2 (after insert,after update) {
     shopifyParser.sendProducttoShopify(Trigger.new);
}