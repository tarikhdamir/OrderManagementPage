import {LightningElement, track} from 'lwc';
import getHelloWorld from '@salesforce/apex/helloWorldController.getHelloWorld'

export default class HelloWorld extends LightningElement {

    @track greeting;

    connectedCallback() {
        getHelloWorld({ name: 'Damir' })
            .then(result => {
                this.greeting = result;  // result should be a string, not a promise
            })
            .catch(error => {
                console.error('Error:', error);
                this.greeting = 'Error fetching greeting';  // Optional: Set a fallback message
            });
    }
}