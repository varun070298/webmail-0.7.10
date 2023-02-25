/* CVS ID: $Id: URLHandlerTree.java,v 1.1.1.1 2002/10/02 18:42:51 wastl Exp $ */
package net.wastl.webmail.server;

import java.util.*;

/*
 * URLHandlerTree.java
 *
 * Created: Thu Sep  2 13:20:23 199
 *
 * Copyright (C) 1999-2000 Sebastian Schaffert
 * 
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */
/**
 * A tree structure to improve (speed up) access to URLs
 *
 * @author Sebastian Schaffert
 * @version
 */

public class URLHandlerTree implements URLHandlerTreeNode {
    
    URLHandler handler;

    String url;

    Hashtable nodes;
    
    StringTokenizer t;

    public URLHandlerTree(String url) {
	nodes=new Hashtable();
	this.url=url; 
   }
   
    public String getURL() {
	return url;
    }

    public void addHandler(String url, URLHandler h) {
	if(url.equals("/") || url.equals("") || url==null) {
	    handler=h;
	} else {
	    t=new StringTokenizer(url,"/");
 	    String subtree_name=t.nextToken();
	    URLHandlerTree subtree=(URLHandlerTree)nodes.get(subtree_name);
	    if(subtree == null) {
		if(this.url.endsWith("/")) {
		    subtree=new URLHandlerTree(this.url+subtree_name);
		} else {
		    subtree=new URLHandlerTree(this.url+"/"+subtree_name);
		}
		nodes.put(subtree_name,subtree);
	    }
	    subtree.addHandler(url.substring(subtree_name.length()+1,url.length()),h);		
	}
    }
    
    public URLHandler getHandler(String url) {
	if(url.equals("/") || url.equals("") || url==null) {
	    /* We are the handler */
	    return handler;
	} else {	    	
	    t=new StringTokenizer(url,"/");
 	    String subtree_name=t.nextToken();
	    URLHandlerTree subtree=(URLHandlerTree)nodes.get(subtree_name);
	    if(subtree == null) {
		/* If there is no subtree, we are the handler! */
		return handler;
	    } else {
		/* Else there is a subtree*/
		URLHandler uh=subtree.getHandler(url.substring(subtree_name.length()+1,url.length()));
		if(uh != null) {
		    /* It has a handler */
		    return uh;
		} else {
		    /* It has no handler, we are handler */
		    return handler;
		}
	    }	    
	}
    }
 
    public String toString() {
	return nodes.toString();
    }

} // URLHandlerTree
