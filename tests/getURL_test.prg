 */
 * @since:  1.0
 *
 * @author: Raúl Juárez <raul.jrz@gmail.com>
 * @date: 09.05.2018 - 04.02
 */
DEFINE CLASS getURL_test as FxuTestCase OF FxuTestCase.prg
*----------------------------------------------------------------------

	#IF .f.
	LOCAL THIS AS getURL_test OF getURL_test.PRG
	#ENDIF
	oObject = ''  &&Este es el objecto que va a ser evaluado
	oldPath = ''
	oldProcedure = ''
	oldDefault = ''

	*--------------------------------------------------------------------
	FUNCTION Setup
	*--------------------------------------------------------------------
		SET PATH TO "E:\Shared\Project\librery\getURL\"
		THIS.oldPath=SET('PATH')
		THIS.oldProcedure=SET('PROCEDURE')
		THIS.oldDefault=SET('DEFAULT')
		*THIS.MessageOut('Procedures: '+SET("PROCEDURE"))
		*THIS.MessageOut('Path......: '+SET("PATH"))
		*THIS.MessageOut('Default...: '+SET("DEFAULT"))
		*THIS.MessageOut('============================================================')

		SET PROCEDURE TO (ADDBS(SYS(5)+CURDIR())+'src\geturl.prg') ADDITIVE
		SET PATH TO (THIS.oldPath +";"+ADDBS(SYS(5)+CURDIR())+'progs ')
		THIS.MessageOut('Procedures: '+STRTRAN(SET("PROCEDURE"),";",CHR(13)+SPACE(12)))
		THIS.MessageOut('Path......: '+STRTRAN(SET("PATH"),";",CHR(13)+SPACE(12)))
		THIS.MessageOut('Default...: '+SET("DEFAULT"))
		THIS.MessageOut('============================================================')
		THIS.MessageOut('')
		THIS.oObject = CREATEOBJECT('geturl')

	ENDFUNC
	
	*---------------------------------------------------------------------
	FUNCTION testExisteObjecto()
	* Verifica la existencia del objecto...
	*---------------------------------------------------------------------
		THIS.AssertNotNull('No existe el objecto',THIS.oObject)
	ENDFUNC

	*--------------------------------------------------------------------
	FUNCTION TearDown
	*--------------------------------------------------------------------
		SET PATH TO      (THIS.oldPath)
		SET PROCEDURE TO (THIS.oldProcedure)
		SET DEFAULT TO   (THIS.oldDefault)
	ENDFUNC

	*--------------------------------------------------------------------
	FUNCTION test_get
	*--------------------------------------------------------------------
		lcURLWebService= 'https://www.purgomalum.com/service/json?text=Prueba%20vfp9'
		lcExpectedValue= '{"result":"Prueba vfp9"}'
		lcExpressResult= THIS.oObject.get(lcURLWebService)


		THIS.AssertEquals(lcExpectedValue, lcExpressResult,;
						'Error, no devolvio el valor esperado')
		THIS.MessageOut('Valor obtenido: '+lcExpressResult)
	RETURN

  ENDFUNC

	*--------------------------------------------------------------------
	FUNCTION testNewTest
		* 1. Change the name of the test to reflect its purpose. Test one thing only.
		* 2. Implement the test by removing these comments and the default assertion and writing your own test code.
	RETURN This.AssertNotImplemented()

  ENDFUNC


ENDDEFINE
*----------------------------------------------------------------------
* The three base class methods to call from your test methods are:
*
* THIS.AssertTrue	    (<Expression>, "Failure message")
* THIS.AssertEquals	    (<ExpectedValue>, <Expression>, "Failure message")
* THIS.AssertNotNull	(<Expression>, "Failure message")
* THIS.MessageOut       (<Expression>)
*
* Test methods (through their assertions) either pass or fail.
*----------------------------------------------------------------------

* AssertNotNullOrEmpty() example.
*------------------------------
*FUNCTION TestObjectWasCreated
*   THIS.AssertNotNullOrEmpty(THIS.oObjectToBeTested, "Test Object was not created")
*ENDFUNC
