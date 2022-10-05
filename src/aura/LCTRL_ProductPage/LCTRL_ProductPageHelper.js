({

    getProducts: function(cmp, string){
        let getProducts = cmp.get('c.getProductsFromString');
        getProducts.setParam('searchString', string);

        getProducts.setCallback(this, (response)=>{
            let state = response.getState();
            if(state == 'SUCCESS'){
                let data = JSON.parse(response.getReturnValue());
                data.forEach(item =>{
                    item['URL'] = '/lightning/r/Product2/'+ item['id'] +'/view';
                    item['categoryName'] = item.category.Name;
                })
                cmp.set('v.data', data);
            }else{
                console.log('response else', response);
            }
        })
        $A.enqueueAction(getProducts);
    }

});