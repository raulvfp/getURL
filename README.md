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

```	
        lcURLWebService= "https://api.openweathermap.org/data/2.5/weather?q=London&appid=d3c416949b580fae2a41d287f79aa144"

        WITH NEWOBJECT('geturl','src\geturl.prg')
                .Verbose = .T. &&Muestro estado del proceso por pantalla. (Default False)
                .is_Log  = .T. &&Grabo los datos enviados, recibidos y errores en archivo. (Default True)
        
                lcResponse = .get(lcURLWebService)
        ENDWITH
```
