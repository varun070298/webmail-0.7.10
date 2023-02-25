/* $Id: DocumentNotFoundException.java,v 1.1.1.1 2002/10/02 18:42:48 wastl Exp $ */
package net.wastl.webmail.exceptions;


/**
 * DocumentNotFoundException.java
 *
 *
 * Created: Sun Feb  7 12:53:14 1999
 *
 * @author Sebastian Schaffert
 * @version $Revision: 1.1.1.1 $
 */
public class DocumentNotFoundException extends WebMailException {
    
    public DocumentNotFoundException() {
	super();
    }

    public DocumentNotFoundException(String s) {
	super(s);
    }
    
} // DocumentNotFoundException
