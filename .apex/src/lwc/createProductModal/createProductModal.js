import { LightningElement, track, api } from 'lwc';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import createProduct from '@salesforce/apex/productController.createProduct';

export default class CreateProductModal extends LightningElement {
    @track isOpen = false;
    @track productName = '';
    @track productDescription = '';
    @track productFamily = '';
    @track productType = '';

    familyOptions = [
        { label: 'Grocery Staples', value: 'Grocery Staples' },
        { label: 'Bakery Products', value: 'Bakery Products' },
        { label: 'Meat and Poultry', value: 'Meat and Poultry' },
        { label: 'Personal Care Products', value: 'Personal Care Products' },
        { label: 'Cleaning Supplies', value: 'Cleaning Supplies' }
    ];

    typeOptions = [
        { label: 'Fresh Produce', value: 'Fresh Produce' },
        { label: 'Dairy Products', value: 'Dairy Products' },
        { label: 'Packaged Foods', value: 'Packaged Foods' },
        { label: 'Frozen Foods', value: 'Frozen Foods' },
        { label: 'Beverages', value: 'Beverages' }
    ];

    handleInputChange(event) {
        const field = event.target.dataset.id;
        if (field === 'name') {
            this.productName = event.target.value;
        } else if (field === 'description') {
            this.productDescription = event.target.value;
        } else if (field === 'family') {
            this.productFamily = event.target.value;
        } else if (field === 'type') {
            this.productType = event.target.value;
        }
    }

    @api openModal() {
        this.isOpen = true;
    }

    closeModal() {
        this.isOpen = false;
    }

    saveProduct() {
        createProduct({
            name: this.productName,
            description: this.productDescription,
            family: this.productFamily,
            type: this.productType
        })
            .then(() => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Success',
                        message: 'Product created successfully',
                        variant: 'success'
                    })
                );
                this.closeModal();
            })
            .catch(error => {
                this.dispatchEvent(
                    new ShowToastEvent({
                        title: 'Error creating product',
                        message: error.body.message,
                        variant: 'error'
                    })
                );
            });
    }
}
