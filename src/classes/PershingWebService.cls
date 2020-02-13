/*
 * Class Name: classes
 * 
 * @author David
 * 
 * @date 10/18/2019
 * 
 * @description:
 */
@RestResource(urlMapping = '/PershingWebService')global without sharing class PershingWebService {

	public static String defaultPrefix = 'urn';
	public static String defaultNS = 'urn:pershing.crm.messages';
	//Local Public Key
	//static String publicKeyString = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAhtYSd4jJgOlaATD0ySTr308Egvboh/Wrqfvou6u42+GMBHfMQg96ZpYbbfEZAVYi+8SOJfrHBl1mB7w0tGaKCIkwOab58GU9XR5lRk76MhL8dEr1z3kE1mqFXQ6E4Xz2pvgzKFUWlVOvwiOMRl/M0ITbUIkxLiBnISB1B817Wlhuvfd2H6SieAXdjbmvKLLChIJSo+ckR315XntbkwWMVViZ/UzgYjEpbc5q5EA9Mfr9LPtIEJQA9VEbVT8PblQqaHsFIgeln8DEa0KlHATj0gHvY10mjDZqT8l8OsWsjhnqqSfAU0jp2KStQ42vCq0c451Kyhge/gXyF2McFOtiiwIDAQAB';
	static String publicKeyString = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAwRknBkB6ABpevkYk09Pguu+M6LnMSJV0l2ZqnwYC4EWYgkJorBkR5WEvW9knEk0St8DpbUGcM5vYfs4gXYJA6f2SZkQXLBGl0lSJa6Bl5gFzH5AcX85bFugPvG/1JiOg3uEqxKceps1bWCIkkesIszRG3pMakqzFKvTVqNhpv/Bm3EEIgmW9ZFwBPho1oDvoTnOxpKa43k/OZ5MAA9KN9R7iGNgFGV4tf3/SnhJH+ozp0MIf3Muwg1k4sR2DqoZpo0xC18pIc9BS9KOZzEyqk7gl88MyAjfzryEy3WrbEKurNtRskQb6RPWw785AZU37pNxty1Jfxg3XZ96cI8dP3QIDAQAB';

	public String xmlString {
		get;set;
	}
	public String XMLHeadingInformation {
		get; set;
	}

	public PershingWebService() {

	}

	private static map<String, String> stateCodes = new map<String, String> {
	'Alabama' => 'AL', 'Alaska' => 'AK', 'American Samoa' => 'AS', 'Arizona' => 'AZ', 'Arkansas' => 'AR', 'California' => 'CA', 'Colorado' => 'CO', 'Connecticut' => 'CT', 'Delaware' => 'DE', 'Dist. of Columbia' => 'DC', 'Florida' => 'FL', 'Georgia' => 'GA', 'Guam' => 'GU', 'Hawaii' => 'HI', 'Idaho' => 'ID', 'Illinois' => 'IL', 'Indiana' => 'IN', 'Iowa' => 'IA', 'Kansas' => 'KS', 'Kentucky' => 'KY', 'Louisiana' => 'LA', 'Maine' => 'ME', 'Maryland' => 'MD', 'Marshall Islands' => 'MH', 'Massachusetts' => 'MA', 'Michigan' => 'MI', 'Micronesia' => 'FM', 'Minnesota' => 'MN', 'Mississippi' => 'MS', 'Missouri' => 'MO', 'Montana' => 'MT', 'Nebraska' => 'NE', 'Nevada' => 'NV', 'New Hampshire' => 'NH', 'New Jersey' => 'NJ', 'New Mexico' => 'NM', 'New York' => 'NY', 'North Carolina' => 'NC', 'North Dakota' => 'ND', 'Northern Marianas' => 'MP', 'Ohio' => 'OH', 'Oklahoma' => 'OK', 'Oregon' => 'OR', 'Palau' => 'PW', 'Pennsylvania' => 'PA', 'Puerto Rico' => 'PR', 'Rhode Island' => 'RI', 'South Carolina' => 'SC', 'South Dakota' => 'SD', 'Tennessee' => 'TN', 'Texas' => 'TX', 'Utah' => 'UT', 'Vermont' => 'VT', 'Virginia' => 'VA', 'Virgin Islands' => 'VI', 'Washington' => 'WA', 'West Virginia' => 'WV', 'Wisconsin' => 'WI', 'Wyoming' => 'WY'

	};
	private static map<String, String> countryCodes = new map<String, String> {
	'Afghanistan' => 'AF', 'Albania' => 'AL', 'Algeria' => 'DZ', 'American Samoa' => 'AS', 'Andorra' => 'AD', 'Angola' => 'AO', 'Anguilla' => 'AI', 'Antarctica' => 'AQ', 'Antigua and Barbuda' => 'AG', 'Argentina' => 'AR', 'Armenia' => 'AM', 'Aruba' => 'AW', 'Australia' => 'AU', 'Austria' => 'AT', 'Azerbaijan' => 'AZ', 'Bahamas' => 'BS', 'Bahrain' => 'BH', 'Bangladesh' => 'BD', 'Barbados' => 'BB', 'Belarus' => 'BY', 'Belgium' => 'BE', 'Belize' => 'BZ', 'Benin' => 'BJ', 'Bermuda' => 'BM', 'Bhutan' => 'BT', 'Bolivia' => 'BO', 'Bosnia and Herzegovina' => 'BA', 'Botswana' => 'BW', 'Brazil' => 'BR', 'British Indian Ocean Territory' => 'IO', 'British Virgin Islands' => 'VG', 'Brunei' => 'BN', 'Bulgaria' => 'BG', 'Burkina Faso' => 'BF', 'Burundi' => 'BI', 'Cambodia' => 'KH', 'Cameroon' => 'CM', 'Canada' => 'CA', 'Cape Verde' => 'CV', 'Cayman Islands' => 'KY', 'Central African Republic' => 'CF', 'Chad' => 'TD', 'Chile' => 'CL', 'China' => 'CN', 'Christmas Island' => 'CX', 'Cocos Islands' => 'CC', 'Colombia' => 'CO', 'Comoros' => 'KM', 'Cook Islands' => 'CK', 'Costa Rica' => 'CR', 'Croatia' => 'HR', 'Cuba' => 'CU', 'Curacao' => 'CW', 'Cyprus' => 'CY', 'Czech Republic' => 'CZ', 'Democratic Republic of the Congo' => 'CD', 'Denmark' => 'DK', 'Djibouti' => 'DJ', 'Dominica' => 'DM', 'Dominican Republic' => 'DO', 'East Timor' => 'TL', 'Ecuador' => 'EC', 'Egypt' => 'EG', 'El Salvador' => 'SV', 'Equatorial Guinea' => 'GQ', 'Eritrea' => 'ER', 'Estonia' => 'EE', 'Ethiopia' => 'ET', 'Falkland Islands' => 'FK', 'Faroe Islands' => 'FO', 'Fiji' => 'FJ', 'Finland' => 'FI', 'France' => 'FR', 'French Polynesia' => 'PF', 'Gabon' => 'GA', 'Gambia' => 'GM', 'Georgia' => 'GE', 'Germany' => 'DE', 'Ghana' => 'GH', 'Gibraltar' => 'GI', 'Greece' => 'GR', 'Greenland' => 'GL', 'Grenada' => 'GD', 'Guam' => 'GU', 'Guatemala' => 'GT', 'Guernsey' => 'GG', 'Guinea' => 'GN', 'Guinea-Bissau' => 'GW', 'Guyana' => 'GY', 'Haiti' => 'HT', 'Honduras' => 'HN', 'Hong Kong' => 'HK', 'Hungary' => 'HU', 'Iceland' => 'IS', 'India' => 'IN', 'Indonesia' => 'ID', 'Iran' => 'IR', 'Iraq' => 'IQ', 'Ireland' => 'IE', 'Isle of Man' => 'IM', 'Israel' => 'IL', 'Italy' => 'IT', 'Ivory Coast' => 'CI', 'Jamaica' => 'JM', 'Japan' => 'JP', 'Jersey' => 'JE', 'Jordan' => 'JO', 'Kazakhstan' => 'KZ', 'Kenya' => 'KE', 'Kiribati' => 'KI', 'Kosovo' => 'XK', 'Kuwait' => 'KW', 'Kyrgyzstan' => 'KG', 'Laos' => 'LA', 'Latvia' => 'LV', 'Lebanon' => 'LB', 'Lesotho' => 'LS', 'Liberia' => 'LR', 'Libya' => 'LY', 'Liechtenstein' => 'LI', 'Lithuania' => 'LT', 'Luxembourg' => 'LU', 'Macau' => 'MO', 'Macedonia' => 'MK', 'Madagascar' => 'MG', 'Malawi' => 'MW', 'Malaysia' => 'MY', 'Maldives' => 'MV', 'Mali' => 'ML', 'Malta' => 'MT', 'Marshall Islands' => 'MH', 'Mauritania' => 'MR', 'Mauritius' => 'MU', 'Mayotte' => 'YT', 'Mexico' => 'MX', 'Micronesia' => 'FM', 'Moldova' => 'MD', 'Monaco' => 'MC', 'Mongolia' => 'MN', 'Montenegro' => 'ME', 'Montserrat' => 'MS', 'Morocco' => 'MA', 'Mozambique' => 'MZ', 'Myanmar' => 'MM', 'Namibia' => 'NA', 'Nauru' => 'NR', 'Nepal' => 'NP', 'Netherlands' => 'NL', 'Netherlands Antilles' => 'AN', 'New Caledonia' => 'NC', 'New Zealand' => 'NZ', 'Nicaragua' => 'NI', 'Niger' => 'NE', 'Nigeria' => 'NG', 'Niue' => 'NU', 'North Korea' => 'KP', 'Northern Mariana Islands' => 'MP', 'Norway' => 'NO', 'Oman' => 'OM', 'Pakistan' => 'PK', 'Palau' => 'PW', 'Palestine' => 'PS', 'Panama' => 'PA', 'Papua New Guinea' => 'PG', 'Paraguay' => 'PY', 'Peru' => 'PE', 'Philippines' => 'PH', 'Pitcairn' => 'PN', 'Poland' => 'PL', 'Portugal' => 'PT', 'Puerto Rico' => 'PR', 'Qatar' => 'QA', 'Republic of the Congo' => 'CG', 'Reunion' => 'RE', 'Romania' => 'RO', 'Russia' => 'RU', 'Rwanda' => 'RW', 'Saint Barthelemy' => 'BL', 'Saint Helena' => 'SH', 'Saint Kitts and Nevis' => 'KN', 'Saint Lucia' => 'LC', 'Saint Martin' => 'MF', 'Saint Pierre and Miquelon' => 'PM', 'Saint Vincent and the Grenadines' => 'VC', 'Samoa' => 'WS', 'San Marino' => 'SM', 'Sao Tome and Principe' => 'ST', 'Saudi Arabia' => 'SA', 'Senegal' => 'SN', 'Serbia' => 'RS', 'Seychelles' => 'SC', 'Sierra Leone' => 'SL', 'Singapore' => 'SG', 'Sint Maarten' => 'SX', 'Slovakia' => 'SK', 'Slovenia' => 'SI', 'Solomon Islands' => 'SB', 'Somalia' => 'SO', 'South Africa' => 'ZA', 'South Korea' => 'KR', 'South Sudan' => 'SS', 'Spain' => 'ES', 'Sri Lanka' => 'LK', 'Sudan' => 'SD', 'Suriname' => 'SR', 'Svalbard and Jan Mayen' => 'SJ', 'Swaziland' => 'SZ', 'Sweden' => 'SE', 'Switzerland' => 'CH', 'Syria' => 'SY', 'Taiwan' => 'TW', 'Tajikistan' => 'TJ', 'Tanzania' => 'TZ', 'Thailand' => 'TH', 'Togo' => 'TG', 'Tokelau' => 'TK', 'Tonga' => 'TO', 'Trinidad and Tobago' => 'TT', 'Tunisia' => 'TN', 'Turkey' => 'TR', 'Turkmenistan' => 'TM', 'Turks and Caicos Islands' => 'TC', 'Tuvalu' => 'TV', 'U.S. Virgin Islands' => 'VI', 'Uganda' => 'UG', 'Ukraine' => 'UA', 'United Arab Emirates' => 'AE', 'United Kingdom' => 'GB', 'United States' => 'US', 'Uruguay' => 'UY', 'Uzbekistan' => 'UZ', 'Vanuatu' => 'VU', 'Vatican' => 'VA', 'Venezuela' => 'VE', 'Vietnam' => 'VN', 'Wallis and Futuna' => 'WF', 'Western Sahara' => 'EH', 'Yemen' => 'YE', 'Zambia' => 'ZM', 'Zimbabwe' => 'ZW'


	};


	@HttpPost global static void doPost() {

		//https://www.aleksey.com/xmlsec/xmldsig-verifier.html

		String soapRequestBody = RestContext.request.requestBody.toString();
		System.Debug('** soapRequestBody => ' + soapRequestBody) ;
		System.Debug('** remoteAddress => ' + RestContext.request.remoteAddress) ;

		map<String, String> parameterMap = new map<String, String> ();
		parseXMLStr(soapRequestBody, parameterMap);
		System.debug('*** parseXMLStr=' + parameterMap.keySet());

		String operationType = '' ;

		dom.Document doc = new Dom.Document();
		doc.load(soapRequestBody);
		dom.XmlNode envelope = doc.getRootElement();
		if (envelope.getChildElements().size() == 2 && envelope.getChildElements()[1].getChildElements().size() == 1) {
			string opName = envelope.getChildElements()[1].getChildElements()[0].getName();
			if (opName == 'detailsSearch' || opName == 'summarySearch') {
				operationType = opName;
			}

		}

		System.debug(operationType) ;

		String uKey = parameterMap.containskey('uniqueKey' ) ? parameterMap .get('uniqueKey' ) : '' ;

		XmlStreamWriter w = new XmlStreamWriter();
		//w.writeStartDocument('utf-8', '1.0');
		//<soap:Envelope xmlns:soap=http://schemas.xmlsoap.org/soap/envelope/ xmlns:xsi=http://www.w3.org/2001/XMLSchema-instance xmlns:xsd=http://www.w3.org/2001/XMLSchema>
		w.setDefaultNamespace(defaultNS);
		w.writeStartElement('soap-env', 'Envelope', 'http://www.w3.org/2003/05/soap-envelope');
		w.writeNamespace('soap-env', 'http://www.w3.org/2003/05/soap-envelope');
		w.writeNamespace('xsd', 'http://www.w3.org/2001/XMLSchema');
		w.writeNamespace('xsi', 'http://www.w3.org/2001/XMLSchema-instance');
		//w.writeNamespace('ds', 'http://www.w3.org/2000/09/xmldsig#');
		//w.writeNamespace(defaultPrefix, defaultNS);


		w.writeStartElement('soap-env', 'Body', 'http://www.w3.org/2003/05/soap-envelope');

		Boolean isVerified = true;
		//Verify Request
		if (!parameterMap.containsKey('DigestValue') ) {
			isVerified = false;
			System.debug ('verified failed==>Digestvalue not found') ;
		}
		else {
			Dom.XMLNode siNode  = envelope.getChildElements()[0].getChildElements()[0].getChildElements()[0].getChildElement('SignedInfo' , 'http://www.w3.org/2000/09/xmldsig#');
			if ( siNode != null && String.isNotBlank(parameterMap.get('SignatureValue')))  {
				isVerified = validateRequest(soapRequestBody, parameterMap.get('SignatureValue'));
			}
			else {
				System.debug ('verified failed==>Matcher found') ;
				isVerified = false;
			}


		}

		System.debug('*** isVerified :: ' + isVerified);

		if (!isVerified) {
			createXmlHeaders(w, '101', operationType);
			w.writeEndElement();
			w.writeEndElement();
		} else if (String.isEmpty(operationType) ) {
			createXmlHeaders(w, '999', 'noOperation');
			w.writeEndElement();
			w.writeEndElement();
		}
		else {

			String taxIdNumber = '';
			String rrCode = parameterMap.get('rrCode') ;
			if (parameterMap.containsKey('taxIdNumber') && String.isNotBlank(parameterMap.get('taxIdNumber'))) {
				taxIdNumber = parameterMap.get('taxIdNumber') ;
			}

			if (String.isNotBlank(rrCode) && String.isNotBlank(taxIdNumber)) {
				searchForData('CleanTaxId__c', parameterMap.get('taxIdNumber'), rrCode, w, operationType , ukey);
			}
			else if (parameterMap.containsKey('name3') && String.isNotBlank(parameterMap.get('name3')) && String.isNotBlank(rrCode)) {
				searchForData('Name', parameterMap.get('name1') + ';' + parameterMap.get('name3'), rrCode, w, operationType , ukey);
			} else if (parameterMap.containsKey('uniqueKey') ) {
				searchForData('uniqueKey', null, rrCode, w, operationType , ukey);
			}
			else {
				createXmlHeaders(w, '102', operationType);
				w.writeEndElement();
			}

			w.writeEndElement();
		}
		w.writeEndElement();
		w.writeEndElement();
		//w.writeEndElement();
		RestContext.response.addHeader('Content-Type', 'application/soap+xml');
		System.debug (w.getXmlString()) ;
		RestContext.response.responseBody = Blob.valueOf(w.getXmlString());


	}

	public static Boolean validateRequest(String inputString, String signature) {

		Dom.Document doc = new Dom.Document ();
		doc.load(inputString);

		//Retrieve the root element for this document.
		Dom.XMLNode address = doc.getRootElement();

		Dom.XMLNode siNode  = address.getChildElements()[0].getChildElements()[0].getChildElements()[0].getChildElement('SignedInfo' , 'http://www.w3.org/2000/09/xmldsig#');



		String retVal = '';
		retVal = PershingWebService.iterateThroughXML( siNode , retVal);

		String algorithmName = 'RSA-SHA1';
		Blob publicKey = EncodingUtil.base64Decode(publicKeyString);
		System.Debug ('*** retVal :: ' + retVal);
		Blob input = Blob.valueOf(retVal);
		System.Debug(signature);
		Boolean verified = Crypto.verify(algorithmName, input, EncodingUtil.base64Decode(signature), publicKey);

		System.debug(verified);
		return verified;

	}

	private static String parseXMLStr(String toParse, map<String, String> returnVals) {
		DOM.Document doc = new DOM.Document();
		map<String, String> parameterMap = returnVals;
		try {
			doc.load(toParse);

			DOM.XMLNode root = doc.getRootElement();
			return walkThrough(root, parameterMap);

		} catch (System.XMLException e) {
			// invalid XML
			return e.getMessage();

		}
		return '';
	}

	private static String walkThrough(DOM.XMLNode node, map<String, String> returnVals) {

		String result = '\n';
		String ElementName = '';
		String ElementValue = '';
		if (node.getNodeType() == DOM.XMLNodeType.COMMENT) {
			return 'Comment (' + node.getText() + ')';
		}
		if (node.getNodeType() == DOM.XMLNodeType.TEXT) {
			return 'Text (' + node.getText() + ')';
		}
		if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {
			result += 'Element: ' + node.getName() + ' Namespace: ' + node.getNamespace();
			ElementName = node.getName();
			if (node.getText().trim() != '') {
				result += ', text=' + node.getText().trim();
				ElementValue = node.getText().trim();
				returnVals.put(ElementName, ElementValue) ;
			}
			if (node.getAttributeCount() > 0) {
				for (Integer i = 0; i < node.getAttributeCount(); i++) {
					result += ', attribute #' + i + ':' + node.getAttributeKeyAt(i) + '=' + node.getAttributeValue(node.getAttributeKeyAt(i), node.getAttributeKeyNsAt(i));
				}
			}
			for (Dom.XMLNode child : node.getChildElements()) {
				result += walkThrough(child, returnVals);
			}

		}
		return ''; //should never reach here

	}


	private static void searchForData(String searchField, String searchTerm, String repNumber, XmlStreamWriter w, String operationType , String uKey) {

		String opType = operationType == 'summarySearch' ? 'Summary Search' : 'Details Search';
		List<Mapping_Field__c> fieldList = [Select Id, Field_API_Name__c, Output_Field_Name__c, Data_Type__c, Static_Value__c , Size__c from Mapping_Field__c Where Mapping_Header__r.OperationType__c = :opType and Active__c = true Order By Sort_Order__c];
		String queryString = 'Select Id,';
		for (Mapping_Field__c mf : fieldList) {
			if (String.isNotBlank(mf.Field_API_Name__c)) {
				queryString += mf.Field_API_Name__c + ',';
			}

		}
		queryString = queryString.substring(0, queryString.length() - 1) ;
		queryString += ' from Contact ';
		if (String.isNotBlank(uKey)) {
			queryString += 'Where Id = \'' + uKey + '\'';
		} else if (String.isNotBlank(searchField) && String.isNotBlank(searchTerm)) {
			if (searchField == 'Name') {
				String[] spltNames = searchTerm.split(';');
				if (String.isNotBlank(spltNames[0])  && spltNames[0] != 'null' ) {
					queryString += 'Where FirstName = \'' + spltNames[0] + '\'';
					queryString += ' and LastName = \'' + spltNames[1] + '\'';
				} else {
					queryString += 'Where LastName = \'' + spltNames[1] + '\'';
				}
			}
			else {
				queryString += 'Where ' + searchField + ' = \'' + searchTerm + '\'';
			}

		}

		queryString += ' and Account.Rep_Number__pc = \'' + repNumber + '\' ' ;
		System.Debug(queryString + ' and Rep_Number__c = \'' + repNumber + '\' ');

		List<sObject> dataObject = Database.Query(queryString + ' Limit 2000 ');


		//Create a map of records available for user
		set<String> recordIds = new set<String> () ;
		for (SObject ct : dataObject) {
			recordIds.add(ct.Id);
		}
		set<String> viewableRecords = new set<String>();
		System.debug(repNumber) ;
		List<User> usrList = [Select Id from User where Rep__c = :repNumber];
		System.debug(usrList) ;
		System.Debug(recordIds);


		if (searchField == 'CleanTaxId__c' && searchTerm.length() != 9) {
			createXmlHeaders(w, '102', operationType);
		}
		else {
			if (dataObject.size() == 0) {
				createXmlHeaders(w, '001', operationType);
			}
			else {
				createXmlHeaders(w, '000', operationType);
			}
		}

		if (operationType == 'summarySearch' ) {
			writeSummarySearch (w , dataObject , fieldList , uKey ) ;
		} else {
			writeDetailSearch (w , dataObject , fieldList , uKey) ;
		}


		/*
		for (sObject obj : dataObject) {
			sObject acct = obj.getSObject('Account') ;
			if (operationType == 'summarySearch' ) {
				w.writeStartElement(null, 'clientSummaries', null);
			} else {
				w.writeStartElement(null, 'clientDetail', null);
			}

			//Process name data
			w.writeStartElement(null, 'nameData', null);
			for (Mapping_Field__c mf : fieldList) {
				if (mf.Output_Field_Name__c.startsWith('nameData')) {
					//System.Debug (mf.Field_API_Name__c) ;
					if (String.isNotBlank(mf.Static_Value__c)) {
						AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], mf.Static_Value__c, mf.Data_Type__c) ;
					}
					else {
						AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], String.ValueOf(obj.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
					}

				}
			}
			w.writeEndElement();

			w.writeStartElement(null, 'address', null);
			w.writeStartElement(null, 'item', null);
			w.writeAttribute(null, null, 'xmlns', 'urn:pershing.crm.types');
			for (Mapping_Field__c mf : fieldList) {
				if (mf.Output_Field_Name__c.startsWith('address')) {
					if (String.isNotBlank(mf.Static_Value__c)) {
						AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], mf.Static_Value__c, mf.Data_Type__c) ;
					}
					else {
						//System.Debug (mf.Field_API_Name__c) ;
						if (mf.Output_Field_Name__c.contains('stateProvince')) {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], stateCodes.get(String.ValueOf(obj.get(mf.Field_API_Name__c))), mf.Data_Type__c) ;
						}
						else if (mf.Output_Field_Name__c.contains('country')) {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], countryCodes.get(String.ValueOf(obj.get(mf.Field_API_Name__c))), mf.Data_Type__c) ;
						}
						else {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], String.ValueOf(obj.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
						}
					}
				}
			}
			w.writeEndElement();
			w.writeEndElement();

			for (Mapping_Field__c mf : fieldList) {
				try {
					if (mf.Output_Field_Name__c.startsWith('nameData') == false && mf.Output_Field_Name__c.startsWith('address') == false) {
						if (String.isNotBlank(mf.Static_Value__c)) {
							AddElementToXml(w, mf.Output_Field_Name__c, mf.Static_Value__c, mf.Data_Type__c) ;
						}
						else {
							if (mf.Field_API_Name__c.startsWith('Account')) {
								if (mf.Output_Field_Name__c.contains('country')) {
									AddElementToXml(w, mf.Output_Field_Name__c, countryCodes.get(String.ValueOf(acct.get(mf.Field_API_Name__c))), mf.Data_Type__c) ;
								}
								else {
									AddElementToXml(w, mf.Output_Field_Name__c, String.ValueOf(acct.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
								}
							}
							else {
								if (mf.Output_Field_Name__c.contains('country')) {
									AddElementToXml(w, mf.Output_Field_Name__c, countryCodes.get(String.ValueOf(obj.get(mf.Field_API_Name__c))), mf.Data_Type__c) ;
								}
								else {
									AddElementToXml(w, mf.Output_Field_Name__c, String.ValueOf(obj.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
								}
							}
						}
					}
				} catch (Exception ex) {

				}
			}

			w.writeEndElement(); //end ClientSummaries

		}
		 */

		//w.writeEndElement(); //end ClientSummaries

		w.writeStartElement(null, 'errorDetail', null);
		w.writeEndElement();
		w.writeEndElement(); //End detailsSearchResponseOutput
		//w.writeEndElement();

	}

	private static void writeDetailSearch (XmlStreamWriter w  , List<sObject> dataObject , List<Mapping_Field__c> fieldList , String uKey    )  {

		for (sObject obj : dataObject) {
			sObject acct = obj.getSObject('Account') ;
			/*
			if (operationType == 'summarySearch' ) {
				w.writeStartElement(null, 'clientSummaries', null);
			} else {

			}
			 */
			w.writeStartElement(null, 'clientDetail', null);
			//Process name data
			w.writeStartElement(null, 'nameData', null);
			for (Mapping_Field__c mf : fieldList) {
				if (mf.Output_Field_Name__c.startsWith('nameData')) {
					//System.Debug (mf.Field_API_Name__c) ;
					if (String.isNotBlank(mf.Static_Value__c)) {
						AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], mf.Static_Value__c, mf.Data_Type__c) ;
					}
					else {
						AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], String.ValueOf(obj.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
					}

				}
			}
			w.writeEndElement();

			w.writeStartElement(null, 'address', null);
			w.writeStartElement(null, 'item', null);
			w.writeAttribute(null, null, 'xmlns', 'urn:pershing.crm.types');
			for (Mapping_Field__c mf : fieldList) {
				if (mf.Output_Field_Name__c.startsWith('address')) {
					String fieldValue = String.ValueOf(obj.get(mf.Field_API_Name__c)) ;
					if (String.isNotBlank(mf.Static_Value__c)) {
						AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], mf.Static_Value__c, mf.Data_Type__c) ;
					}
					else {
						//System.Debug (mf.Field_API_Name__c) ;
						if (mf.Output_Field_Name__c.contains('stateProvince')) {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], stateCodes.get(fieldValue), mf.Data_Type__c) ;
						}
						else if (mf.Output_Field_Name__c.contains('country')) {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], countryCodes.get(fieldValue), mf.Data_Type__c) ;
						}
						else {
							if (mf.Size__c != null && fieldValue.length() > mf.Size__c ) {
								AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], fieldValue.substring(0, Integer.valueOf( mf.Size__c )), mf.Data_Type__c) ;
							} else {
								AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], fieldValue, mf.Data_Type__c) ;
							}
						}
					}
				}
			}
			w.writeEndElement();
			w.writeEndElement();

			for (Mapping_Field__c mf : fieldList) {
				try {

					if (mf.Output_Field_Name__c.startsWith('nameData') == false && mf.Output_Field_Name__c.startsWith('address') == false) {

						if (String.isNotBlank(mf.Static_Value__c)) {
							AddElementToXml(w, mf.Output_Field_Name__c, mf.Static_Value__c, mf.Data_Type__c) ;
						}
						else {


							if (mf.Field_API_Name__c.startsWith('Account')) {
								String acctFieldValue = String.ValueOf(acct.get(mf.Field_API_Name__c)) ;
								if (mf.Output_Field_Name__c.contains('country')) {
									AddElementToXml(w, mf.Output_Field_Name__c, countryCodes.get(acctFieldValue), mf.Data_Type__c) ;
								}
								else {
									if (mf.Size__c != null && acctFieldValue.length() > mf.Size__c  ) {
										AddElementToXml(w, mf.Output_Field_Name__c, acctFieldValue.substring(0 , Integer.valueOf( mf.Size__c ) ), mf.Data_Type__c) ;
									} else {
										AddElementToXml(w, mf.Output_Field_Name__c, acctFieldValue, mf.Data_Type__c) ;
									}

								}
							}
							else {
								String fieldValue = String.ValueOf(obj.get(mf.Field_API_Name__c)) ;
								if (mf.Output_Field_Name__c.contains('country')) {
									AddElementToXml(w, mf.Output_Field_Name__c, countryCodes.get(fieldValue), mf.Data_Type__c) ;
								}
								else {
									if (mf.Size__c != null && fieldValue.length() > mf.Size__c  ) {
										AddElementToXml(w, mf.Output_Field_Name__c, fieldValue.substring(0, Integer.valueOf( mf.Size__c )) , mf.Data_Type__c) ;
									} else {
										AddElementToXml(w, mf.Output_Field_Name__c, fieldValue , mf.Data_Type__c) ;
									}
								}
							}
						}

					}
				} catch (Exception ex) {

				}
			}
			//AddElementToXml(w, 'uniqueKey', obj.Id, 'String') ;
			w.writeEndElement(); //end ClientSummaries

		}

	}
	private static void writeSummarySearch (XmlStreamWriter w  , List<sObject> dataObject , List<Mapping_Field__c> fieldList , String uKey    )  {

		for (sObject obj : dataObject) {
			sObject acct = obj.getSObject('Account') ;

			w.writeStartElement(null, 'clientSummaries', null);

			//Process name data
			w.writeStartElement(null, 'item', null);
			w.writeAttribute(null, null, 'xmlns', 'urn:pershing.crm.types');
			/*
			for (Mapping_Field__c mf : fieldList) {
				if (mf.Output_Field_Name__c.startsWith('nameData')) {
					//System.Debug (mf.Field_API_Name__c) ;
					if (String.isNotBlank(mf.Static_Value__c)) {
						AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], mf.Static_Value__c, mf.Data_Type__c) ;
					}
					else {
						AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], String.ValueOf(obj.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
					}

				}
			}
			 */
			//w.writeEndElement();



			for (Mapping_Field__c mf : fieldList) {
				try {
					if (mf.Output_Field_Name__c.startsWith('nameData')) {
						//System.Debug (mf.Field_API_Name__c) ;
						if (String.isNotBlank(mf.Static_Value__c)) {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], mf.Static_Value__c, mf.Data_Type__c) ;
						}
						else {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], String.ValueOf(obj.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
						}

					}

					if (mf.Output_Field_Name__c.startsWith('nameData') == false && mf.Output_Field_Name__c.startsWith('address') == false) {
						if (String.isNotBlank(mf.Static_Value__c)) {
							AddElementToXml(w, mf.Output_Field_Name__c, mf.Static_Value__c, mf.Data_Type__c) ;
						}
						else {
							if (mf.Field_API_Name__c.startsWith('Account')) {
								if (mf.Output_Field_Name__c.contains('country')) {
									AddElementToXml(w, mf.Output_Field_Name__c, countryCodes.get(String.ValueOf(acct.get(mf.Field_API_Name__c))), mf.Data_Type__c) ;
								}
								else {
									AddElementToXml(w, mf.Output_Field_Name__c, String.ValueOf(acct.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
								}
							}
							else {
								if (mf.Output_Field_Name__c.contains('country')) {
									AddElementToXml(w, mf.Output_Field_Name__c, countryCodes.get(String.ValueOf(obj.get(mf.Field_API_Name__c))), mf.Data_Type__c) ;
								}
								else {
									AddElementToXml(w, mf.Output_Field_Name__c, String.ValueOf(obj.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
								}
							}
						}
					}
				} catch (Exception ex) {

				}
			}
			w.writeStartElement(null, 'address', null);

			w.writeStartElement(null, 'item', null);
			w.writeAttribute(null, null, 'xmlns', 'urn:pershing.crm.types');
			for (Mapping_Field__c mf : fieldList) {
				if (mf.Output_Field_Name__c.startsWith('address')) {
					if (String.isNotBlank(mf.Static_Value__c)) {
						AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], mf.Static_Value__c, mf.Data_Type__c) ;
					}
					else {
						//System.Debug (mf.Field_API_Name__c) ;
						if (mf.Output_Field_Name__c.contains('stateProvince')) {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], stateCodes.get(String.ValueOf(obj.get(mf.Field_API_Name__c))), mf.Data_Type__c) ;
						}
						else if (mf.Output_Field_Name__c.contains('country')) {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], countryCodes.get(String.ValueOf(obj.get(mf.Field_API_Name__c))), mf.Data_Type__c) ;
						}
						else {
							AddElementToXml(w, mf.Output_Field_Name__c.split('\\.')[1], String.ValueOf(obj.get(mf.Field_API_Name__c)), mf.Data_Type__c) ;
						}
					}
				}
			}

			w.writeEndElement();
			w.writeEndElement();
			AddElementToXml(w, 'uniqueKey', obj.Id, 'String') ;
			w.writeEndElement();

			w.writeEndElement(); //end ClientSummaries

		}

	}

	private static void createXmlHeaders(XmlStreamWriter w, String returnCode, String operationType) {

		String opType ;
		if (operationType == 'noOperation') {
			opType = operationType;
		}
		else {
			opType = (operationType == 'summarySearch') ? 'summary' : 'details';
		}


		w.writeStartElement(null, opType + 'SearchResponse', null);
		w.writeAttribute(null, null, 'xmlns', 'urn:pershing.crm.messages');
		//w.writeAttribute('','', 'xmlns' , 'urn:pershing.crm.messages');
		w.writeStartElement(null, opType + 'SearchResponseOutput', null);
		w.writeStartElement(null, 'errorCode', null);
		w.writeCharacters('S');
		w.writeEndElement();
		w.writeStartElement(null, 'returnCode', null);
		w.writeCharacters(returnCode);
		w.writeEndElement();
		/*
		if (operationType == 'summarySearch' ) {
			w.writeStartElement(null, 'clientSummaries', null);
		} else {
			w.writeStartElement(null, 'clientDetail', null);
		}
		 */


	}

	private static void AddElementToXml(XmlStreamWriter w, String localName, String dataValue, String datatype) {
		w.writeStartElement(null, localName, null);
		if (String.isNotBlank(dataValue)) {

			w.writeCharacters(getDataValue(dataValue, datatype)) ;
		}
		w.writeEndElement();
	}


	private static String getDataValue(Object fieldValue, String DataType) {

		if (DataType == 'boolean') {
			return String.ValueOf((Boolean)fieldValue);

		}
		else if (DataType == 'date') {

			return String.ValueOf(fieldValue).split(' ')[0] ;

		}
		else if (DataType == 'datetime') {
			DateTime datetimeValue = (DateTime)fieldValue;
			return datetimeValue.format('yyyy-MM-dd');
		}
		else if (DataType == 'currency') {
			return String.ValueOf((Decimal)fieldValue);
		}
		else if (DataType == 'number') {
			return String.ValueOf((Decimal)fieldValue);
		}
		else if (DataType == 'decimal') {
			return String.ValueOf((Decimal)fieldValue);
		}
		else if (DataType == 'integer') {
			return String.ValueOf((Integer)fieldValue);
		}
		else if (DataType == 'string') {
			return (String) fieldValue ;
		}
		else {
			return '';
		}
	}


	public map<String, String> parseRequestBody(String xmlString) {

		/*
		 * String xmlString = '<soap:Envelope xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">;' ;
		 * xmlString += '<soap:Body xmlns:wsu="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-utility-1.0.xsd" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/" wsu:Id="Id-Body" >';
		 * xmlString += '<s0:summarySearch xmlns:s0="urn:pershing.crm.messages"> <generalSearchRequestInput> <userId>P6KBMH56</userId> <correspondentNumber>6KB</correspondentNumber> <officeNumber>6KB</officeNumber>';
		 * xmlString += '<rrCode>78Y</rrCode>';
		 * xmlString += '<requestType>S</requestType> <systemCode> HEFRENSALE</systemCode> <nameType>I</nameType> <name3>TEST</name3> <name3Type>X</name3Type>';
		 * xmlString += '<taxIdNumber>999</taxIdNumber> </generalSearchRequestInput> </s0:summarySearch> </soap:Body></soap:Envelope>';
		 */

		map<String, String> returnVal = new map<String, String> ();

		String regex = '(?m)<rrCode>(.*)</rrCode>';
		Pattern regexPattern = Pattern.compile(regex);
		Matcher regexMatcher = regexPattern.matcher(xmlString);
		while (regexMatcher.find()) {
			returnVal.put('rrCode', regexMatcher.group(1));
		}
		regex = '(?m)<taxIdNumber>(.*)</taxIdNumber>';
		regexPattern = Pattern.compile(regex);
		regexMatcher = regexPattern.matcher(xmlString);
		while (regexMatcher.find()) {
			returnVal.put('taxIdNumber', regexMatcher.group(1));
		} /*
  * XmlStreamReader reader = new XmlStreamReader(xmlString);
  * boolean isSafeToGetNextXmlElement = true;
  * while (isSafeToGetNextXmlElement) {
  * // Start at the beginning of the book and make sure that it is a book
  * if (reader.getEventType() == XmlTag.START_ELEMENT) {
  * if ('generalSearchRequestInput' == reader.getLocalName()) {
  * // Pass the book to the parseBook method (below)
  * boolean isSafeToGetNextXmlElement2 = true;
  * String tagName = '';
  * while (isSafeToGetNextXmlElement2) {
  * if (reader.getEventType() == XmlTag.START_ELEMENT) {
  * tagName = reader.getLocalName() ;
  * }
  * if (reader.hasNext()) {
  * reader.next();
  * }
  * else {
  * isSafeToGetNextXmlElement = false;
  * break;
  * }
  * if (reader.isCharacters() && !reader.isWhiteSpace()) {
  * returnVal.put(tagName, reader.getText());
  * }
  * }
  * }
  * } // Always use hasNext() before calling next() to confirm
  * // that we have not reached the end of the stream
  * if (reader.hasNext()) {
  * reader.next();
  * }
  * else {
  * isSafeToGetNextXmlElement = false;
  * break;
  * }
  * }
  */

		return returnVal ;
	}

	public static String iterateThroughXML(DOM.XMLNode node, String retVal) {

		string namespacePrefix = '' ;

		if (node.getNodeType() == DOM.XMLNodeType.ELEMENT) {

			if (node.getNamespace() != null) {
				namespacePrefix = node.getPrefixFor(node.getNamespace());
			}
			retval = '<' ;
			if (String.isNotBlank(namespacePrefix)) {
				retval += namespacePrefix + ':';
			}
			retval += node.getName() ;
			if (node.getAttributeCount() > 0) {
				for (Integer i = 0 ; node.getAttributeCount() > i ; i++) {
					retval += ' ' + node.getAttributeKeyAt(i) + '="' + node.getAttributeValue(node.getAttributeKeyAt(i), null) + '"';
				}
			}
			//xmlDataMap.put(node.getAttributeValue(node.getAttributeKeyAt(0), node.getAttributeKeyNsAt(0)), node.getAttributeValue(node.getAttributeKeyAt(1), node.getAttributeKeyNsAt(1)));
		}
		retval += '>';
		if (String.isNotBlank(node.getText())) {
			retVal += node.getText() ;
		}
		if (node.getChildElements().size() > 0) {


			for (Integer c = 0 ; node.getChildElements().size() > c ; c++) {
				retval += iterateThroughXML(node.getChildElements()[c], retVal) ;
			}
		}
		System.debug ('**nodename ' + node.getName() ) ;

		retVal += '</' ;
		if (String.isNotBlank(namespacePrefix)) {
			retval += namespacePrefix + ':';
		}
		retval += node.getName() + '>' ;
		return retval ;

	}



}