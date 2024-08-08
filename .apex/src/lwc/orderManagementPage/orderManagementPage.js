import { LightningElement, track } from 'lwc';

export default class ProductPage extends LightningElement {
    @track filters = {};
    @track searchTerm = '';

    handleFilterChange(event) {
        this.filters = { ...event.detail };
        console.log('New filter: ', this.filters);
        setTimeout(() => {
            const productList = this.template.querySelector('c-product-list');
            if (productList) {
                productList.refreshProducts();
            } else {
                console.error('Product List component not found in the DOM.');
            }
        }, 100);
    }

    handleSearchChange(event) {
        // this.searchTerm = event.target.value;
        this.searchTerm = event.detail.searchTerm;
        console.log('Updated Search Term:', this.searchTerm);
        setTimeout(() => {
            const productList = this.template.querySelector('c-product-list');
            if (productList) {
                productList.refreshProducts();
            } else {
                console.error('Product List component not found in the DOM.');
            }
        }, 100);
    }

    handleProductCreated() {
        setTimeout(() => {
            const productList = this.template.querySelector('c-product-list');
            if (productList) {
                productList.refreshProducts();
            } else {
                console.error('Product List component not found in the DOM.');
            }
        }, 100);  // Adjust the delay as necessary
    }

}
