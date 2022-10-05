public with sharing class LCTRL_ProductService {

    @AuraEnabled
    public static String getProductsFromString(String searchString) {
        String wildCardString = '%' + searchString + '%';
        try {
            List<Product2> products = [SELECT Id, Name, Quantity__c FROM Product2 WHERE Name LIKE :wildCardString];
            Set<Id> productsIds = (new Map<Id, SObject>(products)).keySet();
            Map<Id, ProductCategory> categoriesMap = LCTRL_CategoryHandler.getMapOfCategoryByProductIds(productsIds);
            Map<Id, PricebookEntry> priceMap = LCTRL_PriceBookHandler.getMapOfPriceBooksByProductsIds(productsIds);
            List<LCTRL_Product> productsToReturn = new List<LCTRL_Product>();

            for(Product2 product : products){
                LCTRL_Product product2 = new LCTRL_ProductBuilder()
                                            .setId(product.Id)
                                            .setName(product.Name)
                                            .setCategory(categoriesMap.get(product.Id))
                                            .setQuantity((Integer) product.Quantity__c)
                                            .setPrice(priceMap.get(product.Id).UnitPrice)
                                            .getProduct();
                productsToReturn.add(product2);
            }
            return JSON.serialize(productsToReturn);

        } catch (Exception e) {
            return JSON.serialize(e.getMessage());
        }
    }

    @AuraEnabled
    public static String createNewProduct(String productJSON){
        try{
            LCTRL_ProductWrapper product = (LCTRL_ProductWrapper) JSON.deserialize(productJSON, LCTRL_ProductWrapper.class);
            return JSON.serialize(LCTRL_ProductHandler.create(product));
        } catch (Exception e) {

            return JSON.serialize(e.getMessage());
        }
    }

}