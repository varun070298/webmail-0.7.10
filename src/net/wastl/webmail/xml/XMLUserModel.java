/* CVS ID: $Id: XMLUserModel.java,v 1.1.1.1 2002/10/02 18:42:55 wastl Exp $ */
package net.wastl.webmail.xml;

import java.util.*;

import org.w3c.dom.*;
import javax.xml.parsers.ParserConfigurationException;

import net.wastl.webmail.server.*;
import net.wastl.webmail.exceptions.*;

/*
 * XMLUserModel.java
 *
 * Created: Tue Mar 21 15:08:18 2000
 *
 * Copyright (C) 2000 Sebastian Schaffert
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
 *
 */

/**
 *
 * Mainly consists of a DOM that represents all of the data in the user's session.
 * On subtrees, there are the SYSDATA and the USERDATA DOM trees (among other stuff like folder list,
 * message list, etc)
 *
 * Many methods here are synchronized but that shouldn't hurt performance too much since the cases where several
 * Threads access the model are rare anyway
 *
 * @author Sebastian Schaffert
 * @version
 */

public class XMLUserModel extends XMLGenericModel {
    
    protected Element usermodel;

    protected Element userdata;


    public XMLUserModel(WebMailServer parent, Element rsysdata, Element ruserdata) 
	throws ParserConfigurationException {

	super(parent,rsysdata);

	usermodel=root.getDocumentElement();

	this.userdata=ruserdata;
	
	update();	
    }

    protected void initRoot() {
	// Create a new usermodel from the template file
	try {
	    root = parser.parse("file://"+parent.getProperty("webmail.xml.path")+
				System.getProperty("file.separator")+"usermodel_template.xml");
	} catch(Exception ex) {
	    System.err.println("Error parsing WebMail UserModel template "+ex.getMessage());
	    ex.printStackTrace();
	}
    }
    

    public synchronized void update() {
	// Insert the sysdata and userdata objects into the usermodel tree
	super.update();
	try {
	    NodeList nl=root.getElementsByTagName("USERDATA");
	    usermodel.replaceChild(root.importNode(userdata,true),nl.item(0));
	} catch(ArrayIndexOutOfBoundsException ex) {
	    System.err.println("The WebMail UserModel template file didn't contain a USERDATA tag.");
	} catch(DOMException ex) {
	    System.err.println("Something went wrong with the XML user model.");
	}
    }


    public synchronized Element createFolder(String id,String name,boolean holds_folders, boolean holds_messages) {
	Element folder=root.createElement("FOLDER");
	folder.setAttribute("id",id);
	folder.setAttribute("name",name);
	folder.setAttribute("holds_folders",holds_folders+"");
	folder.setAttribute("holds_messages",holds_messages+"");
	return folder;
    }

    public synchronized Element getFolder(String id) {
	return XMLCommon.getElementByAttribute(usermodel,"FOLDER","id",id);
    }

    public synchronized Element createMessageList() {
	Element messagelist = root.createElement("MESSAGELIST");
	return messagelist;
    }

    /**
     * Get messagelist for folder. Create if necessary.
     */
    public synchronized Element getMessageList(Element folder) {
	NodeList nl=folder.getChildNodes();
	Element messagelist=null;
	for(int i=0;i<nl.getLength();i++) {
	    Element tmp=(Element)nl.item(i);
	    if(tmp.getTagName().equals("MESSAGELIST")) {
		messagelist=tmp;
		break;
	    }
	}
	if(messagelist == null) {
	    messagelist=createMessageList();
	    folder.appendChild(messagelist);
	}
	return messagelist;
    }

    public synchronized void removeMessageList(Element folder) {
	XMLCommon.genericRemoveAll(folder,"MESSAGELIST");
    }

    /**
     * Check whether we already fetched this message. This can save a lot of time and CPU.
     */
    public synchronized boolean messageCached(Element folder, String msgid) {
	NodeList nl=folder.getElementsByTagName("MESSAGE");
	Element message=null;
	for(int i=0;i<nl.getLength();i++) {
	    Element test=(Element)nl.item(i);
	    if(test.getAttribute("msgid").equals(msgid)) {
		message=test;
		break;
	    }
	}
	return message!=null;
    }


    public synchronized XMLMessage getMessage(Element folder,String msgnr, String msgid) {
	NodeList nl=folder.getElementsByTagName("MESSAGE");
	Element message=null;
	for(int i=0;i<nl.getLength();i++) {
	    Element test=(Element)nl.item(i);
	    if(test.getAttribute("msgid").equals(msgid)) {
		message=test;
		break;
	    }
	}
	if(message == null) {
	    message=root.createElement("MESSAGE");
	    message.setAttribute("msgid",msgid);
	    Element msglist=getMessageList(folder);
	    msglist.appendChild(message);
	}
	message.setAttribute("msgnr",msgnr);
	return new XMLMessage(message);
    }

    /**
     * Return the WORK element that stores messages that are currently edited.
     */
    public synchronized XMLMessage getWorkMessage() {
	NodeList nl=usermodel.getElementsByTagName("WORK");
	Element work;
	if(nl.getLength()>0) {
	    work=(Element)nl.item(0);
	} else {
	    work=root.createElement("WORK");
	    usermodel.appendChild(work);
	}
	nl=work.getElementsByTagName("MESSAGE");

	XMLMessage message;
	if(nl.getLength() > 0) {
	    message = new XMLMessage((Element)nl.item(0));
	} else {
	    message=new XMLMessage(root.createElement("MESSAGE"));
	    work.appendChild(message.getMessageElement());
	    message.setAttribute("msgnr","0");
	    message.setAttribute("msgid",WebMailServer.generateMessageID("webmailuser"));
	    XMLMessagePart multipart=message.createPart("multi");
	    multipart.createPart("text");
	}
	return message;
    }

    public synchronized void clearWork() {
	NodeList nl=usermodel.getElementsByTagName("WORK");	
	if(nl.getLength() > 0) {
	    Element work=(Element)nl.item(0);
	    NodeList nl2=work.getChildNodes();
	    Vector v=new Vector();
	    for(int i=0;i<nl2.getLength();i++) {
		v.addElement(nl2.item(i));
	    }
	    Enumeration enum=v.elements();
	    while(enum.hasMoreElements()) {
		work.removeChild((Node)enum.nextElement());
	    }
	}
    }

    /**
     * Set the current work message (for forwarding and replying).
     * Note that this method uses importNode, therefore the newly
     * cloned message element is returned by this method.
     */
    public synchronized XMLMessage setWorkMessage(XMLMessage message) {
	clearWork();
	NodeList nl=usermodel.getElementsByTagName("WORK");
	Element work;
	if(nl.getLength()>0) {
	    work=(Element)nl.item(0);
	} else {
	    work=root.createElement("WORK");
	    usermodel.appendChild(work);
	}
	
	Element newmessage=(Element)root.importNode(message.getMessageElement(),true);
	work.appendChild(newmessage);	
	return new XMLMessage(newmessage);
    }
	


    public synchronized Element createMailhost(String name, String id,String url) {
	Element mh=root.createElement("MAILHOST_MODEL");
	mh.setAttribute("name",name);
	mh.setAttribute("id",id);
	if(url != null) {
	    mh.setAttribute("url",url);
	}
	return mh;
    }

    /**
     * Add a previously created Mailhost to the DOM.
     * The Mailhost should already contain all the subfolders.:-)
     */
    public synchronized void addMailhost(Element mh) {
	String name=mh.getAttribute("name");
	Element elem=XMLCommon.getElementByAttribute(usermodel,"MAILHOST_MODEL","name",name);
	if(elem == null) {
	    usermodel.appendChild(mh);
	} else {
	    usermodel.replaceChild(mh,elem);
	}
    }

    protected synchronized Element setCurrent(String type, String id) {
	NodeList nl=usermodel.getElementsByTagName("CURRENT");
	Element current=null;
	for(int i=0;i<nl.getLength();i++) {
	    if(((Element)nl.item(i)).getAttribute("type").equals(type)) {
		current=(Element)nl.item(i);
		break;
	    }
	}
	if(current == null) {
	    current = root.createElement("CURRENT");
	    current.setAttribute("type",type);
	    usermodel.appendChild(current);
	}
	current.setAttribute("id",id);
	return current;
    }

    protected synchronized Element getCurrent(String type, String id) {
	NodeList nl=usermodel.getElementsByTagName("CURRENT");
	Element current=null;
	for(int i=0;i<nl.getLength();i++) {
	    if(((Element)nl.item(i)).getAttribute("type").equals(type)) {
		current=(Element)nl.item(i);
		break;
	    }
	}
	return current;
    }

    public Element setCurrentMessage(String id) {
	return setCurrent("message",id);
    }

    public Element setCurrentFolder(String id) {
	return setCurrent("folder",id);
    }

    public Element getCurrentMessage(String id) {
	return getCurrent("message",id);
    }

    public Element getCurrentFolder(String id) {
	return getCurrent("folder",id);
    }

} // XMLUserModel
