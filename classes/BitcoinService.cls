/**
 * Created by AbhyashTimsina on 8/11/2021.
 */

public class BitcoinService {


    public class BitpayList
    {
        public String code;
        public String name;
        public Decimal rate;
    }

    //input details that comes to apex from flow
//    public class FlowInputs{
//
//        @InvocableVariable(Label='Amount' Description='Amount' Required=true)
//        public Integer amount;
//
//        @InvocableVariable(Label='CurrencyCode' Description='CurrencyCode' Required=true)
//        public String currencyCode;
//
//        @InvocableVariable(Label='Type' Description='Type' Required=true)
//        public String type;
//
//    }

//    @InvocableMethod(Label='Bitcoin Currency Conversion')
//    public static List<FlowOutputs> getRateForCurrencyCodeFlow(List<FlowInputs> requests) {
//        List<FlowOutputs> results = new List<FlowOutputs>();
//        Decimal rateValue;
//        for ( FlowInputs request : requests ) {
//
//            List<BitpayList> response = new List<BitpayList>();
//
//            try {
//                HttpRequest req = new HttpRequest();
//                HttpResponse res = new HttpResponse();
//                Http http = new Http();
//                req.setHeader('Content-Type', 'application/json');
//                req.setHeader('X-Accept-Version', '2.0.0');
//                req.setEndpoint('https://bitpay.com/api/rates/');
//                req.setMethod('GET');
//
//                res = http.send(req);
//
//
//                response = (List<BitpayList>)JSON.deserialize(res.getBody(), List<BitpayList>.class);
//
//                System.debug(response);
//                System.debug('Str:' + res.getBody());
//
//
//                for (BitpayList bpl : response) {
//                    if (bpl.code == request.currencyCode) {
//                        rateValue = bpl.rate;
//                    }
//
//                }
//
//            }  catch (Exception e) {
//                System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber() );
//            }
//
//            FlowOutputs fos = new FlowOutputs();
//
//            switch on request.type {
//                when 'Currency To Bitcoin' {
//                    fos.outputValueBitcoin = request.amount / rateValue;
//                    results.add(fos);
//                }
//                when 'Bitcoin To Currency' {
//                    fos.outputValueCurrency = rateValue * request.amount;
//                    results.add(fos);
//                }
//            }
//
//        }
//        return results;
//    }

    @AuraEnabled(Cacheable=true)
    public static List<String> getCountryCodes() {

        List<String> countryCodesList = new List<String>();
        List<BitpayList> response = new List<BitpayList>();

        try {
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('X-Accept-Version', '2.0.0');
            req.setEndpoint('https://bitpay.com/api/rates/');
            req.setMethod('GET');


            res = http.send(req);


            response = (List<BitpayList>) JSON.deserialize(res.getBody(), List<BitpayList>.class);

            System.debug(response);
            System.debug('Str:' + res.getBody());


            for (BitpayList bpl : response) {
                countryCodesList.add(bpl.code);

            }


        } catch (Exception e) {
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber());
        }

        return countryCodesList;

    }


    @AuraEnabled(Cacheable=true)
    public static Decimal getRateForCurrencyCode( String comparisonCurrencyCodeValue ) {

        Decimal rateValue;

        List<BitpayList> response = new List<BitpayList>();

        try {
            HttpRequest req = new HttpRequest();
            HttpResponse res = new HttpResponse();
            Http http = new Http();
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('X-Accept-Version', '2.0.0');
            req.setEndpoint('https://bitpay.com/api/rates/');
            req.setMethod('GET');


            res = http.send(req);


            response = (List<BitpayList>) JSON.deserialize(res.getBody(), List<BitpayList>.class);

            System.debug(response);
            System.debug('Str:' + res.getBody());


            for (BitpayList bpl : response) {
                if (bpl.code == comparisonCurrencyCodeValue) {
                    rateValue = bpl.rate;
                }

            }


        } catch (Exception e) {
            System.debug('Error:' + e.getMessage() + 'LN:' + e.getLineNumber());
        }

        return rateValue;

    }


    //output details which goes from apex to flow
//    public class FlowOutputs{
//
//        @InvocableVariable
//        public Decimal outputValueBitcoin;
//        @InvocableVariable
//        public Decimal outputValueCurrency;
//
//    }

}
