/**
 * Created by AbhyashTimsina on 7/11/2021.
 Has around 95% coverage.
 */

@IsTest
private class BitcoinServiceTest {

    @IsTest static void getBitcoinRateTest() {
        Test.startTest();
        Map<String,String> headers = new Map<String, String>();
        headers.put('Content-Type','application/json');
        headers.put('X-Accept-Version','2.0.0');
        Test.setMock(HttpCalloutMock.class, new BitcoinServiceMock(200,'Success','[{"code":"AUD","name":"Australian Dollar","rate":83743.75},{"code":"CNY","name":"Chinese Yuan","rate":396272.55},{"code":"CHF","name":"Swiss Franc","rate":56491.49},{"code":"SEK","name":"Swedish Krona","rate":544288.77},{"code":"NZD","name":"New Zealand Dollar","rate":87039.69}]',headers));
        Decimal rate = BitcoinService.getRateForCurrencyCode('AUD');
        Test.stopTest();
        System.assertEquals(83743.75, rate);
    }
    @IsTest static void getCountryCodesTest() {
        Test.startTest();
        Map<String,String> headers = new Map<String, String>();
        headers.put('Content-Type','application/json');
        headers.put('X-Accept-Version','2.0.0');
        Test.setMock(HttpCalloutMock.class, new BitcoinServiceMock(200,'Success','[{"code":"AUD","name":"Australian Dollar","rate":83743.75},{"code":"CNY","name":"Chinese Yuan","rate":396272.55},{"code":"CHF","name":"Swiss Franc","rate":56491.49},{"code":"SEK","name":"Swedish Krona","rate":544288.77},{"code":"NZD","name":"New Zealand Dollar","rate":87039.69}]',headers));
        List <String> countryCodeList = BitcoinService.getCountryCodes();
        Test.stopTest();
        System.assert(countryCodeList.size()==5);
    }
}
