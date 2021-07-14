*
*-----------------------------------------------------------------------------------*
*| getURL
*-----------------------------------------------------------------------------------*
*|
*| Archivo principal del sistema
*| Author......: Raúl Jrz (raul.jrz@gmail.com) 
*| Created.....: 08.05.2018 - 20:30
*| Last Update.: 12.07.2021 - 20:00
*| Purpose.....: Conectarse con una direccion web https, haciendo peticiones
*|               GET, POST, DELETE, PUT ...
*|
*-----------------------------------------------------------------------------------*
**
** GETURL.PRG
** Returns the contains of any given URL
**
** Version: 2.0
**
**
** Syntax & Example:
** 
** WITH NEWOBJECT('geturl','src\geturl.prg')
**		.Verbose = .T. &&Muestro estado del proceso por pantalla. (Default False)
**      .is_Log  = .T. &&Grabo los datos enviados, recibidos y errores en archivo. (Default True)
** 
**      lcResponse = .get("https://api.openweathermap.org/data/2.5/weather?q=London&appid=d3c416949b580fae2a41d287f79aa144")
** ENDWITH
**
** 
**
*-----------------------------------------------------------------------------------*
*| Revisions...: v2.00
*|  Modificado para acceder a servidores https y poder usar verbos POST, GET, PUT, DELETE ...
*|
*/
*-----------------------------------------------------------------------------------*
DEFINE CLASS getURL AS Custom
*
*-----------------------------------------------------------------------------------*
	Verbose= .F. &&If setted to TRUE, progress info will be shown.
	is_log = .T. &&If setted to TRUE, records a log of the processes.
	
	Body   = ''     && If defined, the value is sent in the body of the message.
	method = [GET]  && It is the http Verb. [POST, GET, DELETE, HEAD, PUT, CONNECT, PATCH]
	
	*----------------------------------------------------------------------------*
	FUNCTION verbose_Assign(tbNewVal)
	*
	*----------------------------------------------------------------------------*
		IF VARTYPE(tbNewVal)#'L' THEN
			WAIT WINDOWS 'Error: solo se puede asignar un valor numerico'
		ENDIF
		THIS.Verbose = tbNewVal
	ENDFUNC
	*
	*----------------------------------------------------------------------------*
	FUNCTION method_Assign(tbNewVal)
	*
	*----------------------------------------------------------------------------*
		lcPossible = [POST, GET, DELETE, HEAD, PUT, CONNECT, PATCH]
		lcNewVal   = IIF(VARTYPE(tbNewVal)='C', ALLTRIM(tbNewVal), 'GET')
		
		THIS.method= IIF(lcNewVal$lcPossible, lcNewVal, 'GET')
	ENDFUNC
	*
	*----------------------------------------------------------------------------*
	FUNCTION showVerbose
	LPARAMETERS tcMessage
	*
	*----------------------------------------------------------------------------*
		IF THIS.Verbose
			WAIT tcMessage WINDOW NOWAIT
		ENDIF
	ENDFUNC
	*
	*----------------------------------------------------------------------------*
	FUNCTION get
	LPARAMETERS tcURL
	*
	*----------------------------------------------------------------------------*
		THIS.method = 'GET'
		RETURN THIS.httpRequest(tcURL)
	ENDFUNC
	*
	*----------------------------------------------------------------------------*
	FUNCTION post
	LPARAMETERS tcURL
	*
	*----------------------------------------------------------------------------*
		THIS.method = 'POST'
		RETURN THIS.httpRequest(tcURL)
	ENDFUNC
	*
	*----------------------------------------------------------------------------*
	FUNCTION httpRequest
	LPARAMETERS tcURL
	*
	*----------------------------------------------------------------------------*
		LOCAL lcResponse
		lcResponse=''
		
	    THIS.writelog(' *---------------------------------------------------*')
		THIS.writelog(' Connected to url: '+tcURL)
		THIS.writelog(' Body.....: '+THIS.Body)
		THIS.writelog(' Method...: '+THIS.Method)

		TRY
			WITH CREATEOBJECT("WinHttp.WinHttpRequest.5.1")
				*-- Se establece la conexi?n con internet
				THIS.showVerbose("Opening Internet connection...")

				.open(THIS.method, tcURL, .F.)
				.Send(THIS.Body)
				THIS.showVerbose("Opening connection to URL..." )
		
				IF .Status = 404 THEN
					lcResponse = '#'+TRANSFORM(.Status) + ' - ' + .Statustext
					THROW "No existe la ruta "+ tcURL + lcResponse
				ENDIF
				
				IF !INLIST(.Status, 0, 200) THEN
					lcResponse = '#'+TRANSFORM(.Status) + ' - ' + .Statustext
					THROW "Error al desacargar "+ lcResponse 
				ENDIF
				
				IF THIS.is_Text(.GetAllResponseHeaders) THEN	
					lcResponse = .responseText
					THIS.writelog(' Response.: '+lcResponse)
					THIS.showVerbose("Text Format")
				ELSE
					lcResponse = .responseBody
					THIS.writelog(' Response.: una imagen')
					THIS.showVerbose("Binary Format")
				ENDIF
			ENDWITH
			THIS.showVerbose("It was received from API: "+SUBSTR(lcResponse,1,150))
			
		CATCH TO loEx
			THIS.writelog(' Error: '+loEx.UserValue)
			THIS.writelog(' URL..: '+tcURL)
			THIS.showVerbose("Error: "+loEx.UserValue)
		FINALLY
		ENDTRY

		RETURN lcResponse
	ENDFUNC	
	*
	*----------------------------------------------------------------------------*
	PROTECTED FUNCTION is_Text
	LPARAMETERS tcHeader
	*
	*----------------------------------------------------------------------------*	
		LOCAL laType[1], lbSuccess, lcType AS STRING, lnCnt AS NUMBER, lnLoop AS NUMBER
		lcType = 'text/css,text/csv,application/javascript,application/json,application/xhtml+xml,application/hal+json'
		lbSuccess = .F.
		
		ALINES(laType, lcType, ',')
		FOR EACH lcValue IN laType
			IF lcValue $ LOWER(tcHeader) THEN
				lbSuccess = .T.
				EXIT
			ENDIF
		ENDFOR

		RETURN lbSuccess
	ENDFUNC
	*
	*----------------------------------------------------------------------------*
	PROTECTED FUNCTION writelog
	LPARAMETERS tcLeyenda
	* 
	*----------------------------------------------------------------------------*
		RETURN THIS.is_log AND ;
			   STRTOFILE(TTOC(DATETIME()) + '| '+tcLeyenda+CHR(13)+CHR(10), 'request.log', 1)>0
	ENDFUNC
ENDDEFINE