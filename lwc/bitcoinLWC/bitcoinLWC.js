/**
 * Created by AbhyashTimsina on 8/11/2021.
 */


import {LightningElement, track, wire} from 'lwc';
import getRateForCurrencyCode from'@salesforce/apex/BitcoinService.getRateForCurrencyCode';
import getCountryCodes from'@salesforce/apex/BitcoinService.getCountryCodes';
import { createRecord } from 'lightning/uiRecordApi';

let i=0;

export default class BitcoinLwc extends LightningElement {

    @track comparisonCurrencyCodeValue = 'AUD';
    @track bitcoinValue = 1.00;
    @track currencyValue;
    @track countryCodeList = [];

    @track rateValue;
    @track error;

    @track countryCodeOptions = [];


    connectedCallback() {
        getRateForCurrencyCode({comparisonCurrencyCodeValue: this.comparisonCurrencyCodeValue})
            .then(result => {
                this.rateValue = result;
                this.currencyValue = result;
            })
            .catch(error => {
                this.error = error;
            });
        getCountryCodes()
            .then(result => {
                this.countryCodeList = result;
                for(i=0; i<result.length; i++)  {
                    this.countryCodeOptions = [...this.countryCodeOptions ,{value: result[i] , label: result[i]} ];
                }
            })
            .catch(error => {
                this.error = error;
            });
    }

    createRecord(){
        // Creating mapping of fields of Account with values
        var fields = {'Bitcoin_Value__c' : this.bitcoinValue, 'Rate__c' : this.rateValue, 'Currency_Code__c' : this.comparisonCurrencyCodeValue, 'Currency_Value__c' : this.currencyValue};
        // Record details to pass to create method with api name of Object.
        var objRecordInput = {'apiName' : 'Bitcoin_Request__c', fields};
        // LDS method to create record.
        createRecord(objRecordInput).then(response => {
            alert('Bitcoin Request Record created with Id: ' +response.id);
        }).catch(error => {
            alert('Error: ' +JSON.stringify(error));
        });
    }

    handleComparisonCurrencyChange(event) {
        this.comparisonCurrencyCodeValue = event.detail.value;
        getRateForCurrencyCode({comparisonCurrencyCodeValue: event.detail.value})
            .then(result => {
                this.rateValue = result;
                this.bitcoinValue = (this.currencyValue / result);
                this.currencyValue = (result * this.bitcoinValue);
            })
            .catch(error => {
                this.error = error;
            });

    }

    handleBitcoinValueChange(event) {
        this.currencyValue = (this.rateValue * event.detail.value);
    }

    handleCurrencyValueChange(event) {
        this.bitcoinValue = (event.detail.value / this.rateValue);
    }
}
