*
*|--------------------------------------------------------------------------
*| getURL
*|--------------------------------------------------------------------------
*|
*| Archivo principal del sistema
*| Author......: Raúl Jrz (raul.jrz@gmail.com) 
*| Created.....: 08.05.2018 - 20:30
*| Purpose.....: Conectarse con una direccion web
*|
*************************************************
**
** GETURL.PRG
** Returns the contains of any given URL
**
** Version: 1.0
**
** Author: Victor Espina (vespinas@cantv.net)
**         Walter Valle (wvalle@develcomp.com)
**         (based on original source code from Pablo Almunia)
*
** Date: August 20, 2003
**
**
** Syntax:
** cData = GetURL(pcURL[,plVerbose])
**
** Where:
** cData	 Contents (text or binary) of requested URL.
** pcURL	 URL of the requested resource or file. If an
**           error occurs, a empty string will be returned.
**
** Example:
** cHTML=GetURL("http://www.portalfox.com")
**
**************************************************
*| Revisions...: v2.00
*|
*/
*-----------------------------------------------------------------------------------*
DEFINE CLASS getURL AS Custom
*
*-----------------------------------------------------------------------------------*
	bRelanzarThrow = .T. &&Relanza la excepcion al nivel superior
	Verbose        = .F. &&If setted to TRUE, progress info will be shown.

	*----------------------------------------------------------------------------*
	FUNCTION verbose_Assign(tbNewVal)
	*
	*----------------------------------------------------------------------------*
		TRY
			IF VARTYPE(tbNewVal)#'L' THEN
				THROW 'Error: solo se puede asignar un valor numerico'
			ENDIF
			THIS.Verbose = tbNewVal
		CATCH TO loEx
			oTmp = CREATEOBJECT('catchException',THIS.bRelanzarThrow)
			THIS.oException = loEx
		ENDTRY
		
	ENDFUNC

	*----------------------------------------------------------------------------*
	FUNCTION get
	LPARAMETERS pcURL
	*
	*----------------------------------------------------------------------------*
		*-- Se definen las funciones API necesarias
		#DEFINE INTERNET_OPEN_TYPE_PRECONFIG     0
		DECLARE LONG GetLastError IN WIN32API
		DECLARE INTEGER InternetCloseHandle IN "wininet.dll" ;
			LONG hInet
		DECLARE LONG InternetOpen IN "wininet.dll" ;
			STRING   lpszAgent, ;
			LONG     dwAccessType, ;
			STRING   lpszProxyName, ;
			STRING   lpszProxyBypass, ;
			LONG     dwFlags
		DECLARE LONG InternetOpenUrl IN "wininet.dll" ;
			LONG    hInet, ;
			STRING  lpszUrl, ;
			STRING  lpszHeaders, ;
			LONG    dwHeadersLength, ;
			LONG    dwFlags, ;
			LONG    dwContext
		DECLARE LONG InternetReadFile IN "wininet.dll" ;
			LONG     hFtpSession, ;
			STRING  @lpBuffer, ;
			LONG     dwNumberOfBytesToRead, ;
			LONG    @lpNumberOfBytesRead

		*-- Se establece la conexión con internet
		IF THIS.Verbose
			WAIT "Opening Internet connection..." WINDOW NOWAIT
		ENDIF

		LOCAL nInetHnd
		nInetHnd = InternetOpen("GETURL",INTERNET_OPEN_TYPE_PRECONFIG,"","",0)
		IF nInetHnd = 0
			RETURN ""
		ENDIF

		*-- Se establece la conexión con el recurso
		IF THIS.Verbose
			WAIT "Opening connection to URL..." WINDOW NOWAIT
		ENDIF

		LOCAL nURLHnd
		nURLHnd = InternetOpenUrl(nInetHnd,pcURL,NULL,0,0,0)
		IF nURLHnd = 0
			InternetCloseHandle( nInetHnd )
			RETURN ""
		ENDIF

		*-- Se lee el contenido del recurso
		LOCAL cURLData,cBuffer,nBytesReceived,nBufferSize
		cURLData      =""
		cBuffer       =""
		nBytesReceived=0
		nBufferSize   =0

		DO WHILE .T.
			*-- Se inicializa el buffer de lectura (bloques de 2 Kb)
			cBuffer=REPLICATE(CHR(0),2048)

			*-- Se lee el siguiente bloque
			InternetReadFile(nURLHnd,@cBuffer,LEN(cBuffer),@nBufferSize)
			IF nBufferSize = 0
				EXIT
			ENDIF

			*-- Se acumula el bloque en el buffer de datos
			cURLData=cURLData + SUBSTR(cBuffer,1,nBufferSize)
			nBytesReceived=nBytesReceived + nBufferSize

			IF THIS.Verbose
				WAIT WINDOW ALLTRIM(TRANSFORM(INT(nBytesReceived / 1024),"999,999")) + " Kb received..." NOWAIT
			ENDIF
		ENDDO
		IF THIS.Verbose
			WAIT CLEAR
		ENDIF

		*-- Se cierra la conexión a Internet
		InternetCloseHandle( nInetHnd )

		*-- Se devuelve el contenido del URL
		RETURN cURLData
	ENDFUNC
	
ENDDEFINE
