/* $Id: ErrorHandler.java,v 1.1.1.1 2002/10/02 18:42:48 wastl Exp $ */
package net.wastl.webmail.debug;

/**
 * ErrorHandler.java
 *
 *
 * Created: Tue Feb  2 12:24:40 1999
 *
 * @author Sebastian Schaffert
 * @version $Revision: 1.1.1.1 $
 */
public class ErrorHandler  {
    
    public ErrorHandler(Exception ex) {
	//System.err.println(ex.getMessage());;
	ex.printStackTrace();
    }
    
} // ErrorHandler
