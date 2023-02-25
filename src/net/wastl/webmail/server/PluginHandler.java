/* CVS ID: $Id: PluginHandler.java,v 1.1.1.1 2002/10/02 18:42:51 wastl Exp $ */
package net.wastl.webmail.server;

import net.wastl.webmail.config.*;
import net.wastl.webmail.misc.Queue;
import net.wastl.webmail.exceptions.WebMailException;
import java.io.*;
import java.util.*;

/**
 * PluginHandler.java
 *
 * Handle WebMail Plugins
 *
 * Created: Tue Aug 31 15:28:45 1999
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
 *
 *
 *
 * @author Sebastian Schaffert
 * @version
 */

public class PluginHandler  {
    
    WebMailServer parent;
    String plugin_list;
    Vector plugins;

    public PluginHandler(WebMailServer parent) throws WebMailException {
	this.parent=parent;
	this.plugin_list=parent.getProperty("webmail.plugins");
	if(plugin_list == null) {
	    throw new WebMailException("Error: No Plugins defined (Property webmail.plugins).");
	}
	plugins=new Vector();
	registerPlugins();
    }


     /**
     * Initialize and register WebMail Plugins.
     */
    public void registerPlugins() {
	parent.getStorage().log(Storage.LOG_INFO,"Initializing WebMail Plugins ...");
	//	System.setProperty("java.class.path",System.getProperty("java.class.path")+System.getProperty("path.separator")+pluginpath);



	StringTokenizer tok=new StringTokenizer(plugin_list,":;, ");

	Class plugin_class=null;
	try {
	    plugin_class=Class.forName("net.wastl.webmail.server.Plugin");
	} catch(ClassNotFoundException ex) {
	    parent.getStorage().log(Storage.LOG_CRIT,"===> Could not find interface 'Plugin'!!");
	    System.exit(1);
	}

	PluginDependencyTree pt=new PluginDependencyTree("");
	Queue q=new Queue();
	
	int count=0;
	
	while(tok.hasMoreTokens()) {
	    String name=(String)tok.nextToken();
	    try {
		Class c=Class.forName(name);
		if(plugin_class.isAssignableFrom(c)) {
		    Plugin p=(Plugin) c.newInstance();
		    q.queue(p);
		    plugins.addElement(p);
		    //System.err.print(p.getName()+" ");
		    //System.err.flush();
		    count++;
		}
	    } catch(Exception ex) {
		parent.getStorage().log(Storage.LOG_ERR,"could not register plugin \""+name+"\"!");
		ex.printStackTrace();
	    }
	}
	
	parent.getStorage().log(Storage.LOG_INFO,count+" plugins loaded correctly.");


	count=0;
	while(!q.isEmpty()) {
	    Plugin p=(Plugin)q.next();
	    if(!pt.addPlugin(p)) {
		q.queue(p);
	    }
	}
	pt.register(parent);
	parent.getStorage().log(Storage.LOG_INFO,count+" plugins initialized.");
    };
   
    public Enumeration getPlugins() {
	return plugins.elements();
    }

    /**
     * A filter to find WebMail Plugins.
     */
    class FFilter implements FilenameFilter {
	FFilter() {
	}
	
	public boolean accept(File f, String s) {
	    if(s.endsWith(".class")) {
		return true;
	    } else {
		return false;
	    }
	}	
    }

} // PluginHandler
