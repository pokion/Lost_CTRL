/**
 * Created by cezary.bubieniec on 03.10.2022.
 */

public with sharing class LCTRL_CategoryHandler {

    public static Map<Id, ProductCategory> getMapOfCategoryByProductIds(Set<Id> productsIds){
        List<ProductCategoryProduct> categories = [SELECT ProductId, ProductCategory.Name, ProductCategory.Id FROM ProductCategoryProduct WHERE Product.Id = :productsIds];
        Map<Id, ProductCategory> categoriesMap = new Map<Id, ProductCategory>();

        for(ProductCategoryProduct category : categories){
            ProductCategory productCategory = new ProductCategory();
            productCategory.Id = category.ProductCategory.Id;
            productCategory.Name = category.ProductCategory.Name;

            categoriesMap.put(category.ProductId, productCategory);
        }

        return categoriesMap;
    }
}