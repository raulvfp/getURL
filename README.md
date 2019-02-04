# getURL

Esta es una clase de VFP que permite la conexión a traves de HTTP, lo que habilita para consumir servicios Restful o SOAP XML.

* support: raul.jrz@gmail.com
* url: [http://rauljrz.github.io/](http://rauljrz.github.io)


## Dependencies
**None! There is no dependency!**


## Installation
git clone https://github.com/raulvfp/getURL.git getURL


## Usage
Metodo: 
- get(lcURL) 
	+ Parameters: La dirección web de la consulta.

## Example:

`	
        lcURLWebService= "https://www.purgomalum.com/service/json?text=Prueba%20vfp9"

        oHTTP = CREATEOBJECT('geturl')
        lcRequest = oHTTP.get(lcURLWebService)
`
