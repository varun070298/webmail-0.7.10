/* CVS ID: $Id: StatusServer.java,v 1.1.1.1 2002/10/02 18:42:51 wastl Exp $ */
package net.wastl.webmail.server;

/**
 * StatusServer.java
 *
 * A Server object that can return a status message.
 *
 * Created: Sun Dec 31 16:07:04 2000
 *
 * @author Sebastian Schaffert
 * @version
 */

public interface StatusServer  {
    
    /**
     * Return a status message.
     */
    public String getStatus();
    
} // StatusServer
