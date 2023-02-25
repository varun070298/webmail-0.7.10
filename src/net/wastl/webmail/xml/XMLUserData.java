/* CVS ID $Id: XMLUserData.java,v 1.1.1.1 2002/10/02 18:42:55 wastl Exp $ */
package net.wastl.webmail.xml;

import net.wastl.webmail.config.*;
import net.wastl.webmail.server.*;
import net.wastl.webmail.misc.*;
import net.wastl.webmail.exceptions.*;

import java.util.*;
import java.text.*;


import org.w3c.dom.*;


/**
 * XMLUserData.java
 *
 * Created: Fri Mar 10 16:17:28 2000
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
 */

/**
 *
 *
 *
 * @author Sebastian Schaffert
 * @version
 */
/* 9/25/2000 devink -- modified for challenge/response authentication */

public class XMLUserData implements UserData {
    
    protected Document root;

    protected Element userdata;

    protected boolean debug;

    protected long login_time;
    protected boolean logged_in;

    public XMLUserData(Document d) {
	debug=WebMailServer.getDebug();
	root=d;
	userdata=root.getDocumentElement();
	if(userdata==null) {
	    System.err.println("UserData was null ???");
	    userdata=root.createElement("USERDATA");
	    root.appendChild(userdata);
	}
    }

    public void init(String user, String domain, String password) {
	setUserName(user);
	setDomain(domain);
	setFullName(user);
	if(domain.equals("")) { 
	  // This is a special case when the user already contains the domain
	  // e.g. QMail
	  setEmail(user);
	} else {
	    setEmail(user+"@"+domain);
	}
	try {
	    setPassword(password,password);
	} catch(InvalidPasswordException ex) {}
	// Modified by exce, start
	/**
	 * Set user's locale to WebMailServer's default locale.
	 */
	// setPreferredLocale(Locale.getDefault().toString());
	setPreferredLocale(WebMailServer.getDefaultLocale().toString());
	// Modified by exce, end
	setTheme(WebMailServer.getDefaultTheme());
	setIntVar("first login",System.currentTimeMillis());
	setIntVar("last login", System.currentTimeMillis());
	setIntVar("login count",0);
	setIntVar("max show messages",20);
	setIntVar("icon size",48);
	setBoolVar("break lines",true);
	setIntVar("max line length",79);
    }
	

    public Document getRoot() {
	return root;
    }

    public Element getUserData() {
	return userdata;
    }
    
    public DocumentFragment getDocumentFragment() {
	DocumentFragment df=root.createDocumentFragment();
	df.appendChild(userdata);
	return df;
    }


    protected void ensureElement(String tag, String attribute, String att_value) {
	NodeList nl=userdata.getElementsByTagName(tag);
	boolean flag=false;
	for(int i=0;i<nl.getLength();i++) {
	    Element e=(Element)nl.item(i);
	    if(attribute == null) {
		// No attribute required
		flag=true;
		break;
	    } else if(att_value == null) {
		if(e.getAttributeNode(attribute) != null) {
		    // Attribute exists, value is not requested
		    flag=true;
		    break;
		}
	    } else if(e.getAttribute(attribute).equals(att_value)) {
		flag=true;
		break;
	    }
	}
	if(!flag) {
	    Element elem=root.createElement(tag);
	    if(attribute != null) {
		elem.setAttribute(attribute,att_value==null?"":att_value);
	    }
	    userdata.appendChild(elem);
	}
    }

    public void login() {
	// Increase login count and last login pointer
	//setIntVar("last login",System.currentTimeMillis());
	if(!logged_in) {
	    setIntVar("login count",getIntVar("login count")+1);
	    login_time=System.currentTimeMillis();
	    logged_in=true;
	} else {
	    System.err.println("Err: Trying to log in a second time for user "+getLogin());
	}
    }

    public void logout() {
	if(logged_in) {
	    setIntVar("last login",login_time);
	    // Modified by exce, start
	    logged_in = false;
	    // Modified by exce, end
	} else {
	    System.err.println("Err: Logging out a user that wasn't logged in.");
	}
    }

    public void addMailHost(String name, String host, String login, String password) {
	// First, check whether a mailhost with this name already exists.
	// Delete, if yes.
	try {
	    //System.err.println("Adding mailhost "+name);
	    if(getMailHost(name) != null) {
		removeMailHost(name);
	    }	
	    Element mailhost=root.createElement("MAILHOST");
	    mailhost.setAttribute("name",name);
	    mailhost.setAttribute("id",Long.toHexString(Math.abs(name.hashCode()))+Long.toHexString(System.currentTimeMillis()));
	    
	    Element mh_login=root.createElement("MH_LOGIN");
	    XMLCommon.setElementTextValue(mh_login,login);
	    mailhost.appendChild(mh_login);
	    
	    Element mh_pass=root.createElement("MH_PASSWORD");
	    XMLCommon.setElementTextValue(mh_pass,Helper.encryptTEA(password));
	    mailhost.appendChild(mh_pass);
	    
	    Element mh_uri=root.createElement("MH_URI");
	    XMLCommon.setElementTextValue(mh_uri,host);
	    mailhost.appendChild(mh_uri);
	    
	    userdata.appendChild(mailhost);
	    //System.err.println("Done mailhost "+name);
	    //XMLCommon.writeXML(root,System.err,"");
	} catch(Exception ex) {
	    ex.printStackTrace();
	}
    }

    public void removeMailHost(String id) {
	Element n=XMLCommon.getElementByAttribute(userdata,"MAILHOST","id",id);
	if(n!=null) {
	    userdata.removeChild(n);
	}
    }

    public MailHostData getMailHost(String id) {
	final Element mailhost=XMLCommon.getElementByAttribute(userdata,"MAILHOST","id",id);
	return new MailHostData() {

		public String getPassword() {
		    return Helper.decryptTEA(XMLCommon.getTagValue(mailhost,"MH_PASSWORD"));
		}

		public void setPassword(String s) {
		    XMLCommon.setTagValue(mailhost,"MH_PASSWORD",Helper.encryptTEA(s));
		}

		public String getLogin() {
		    return XMLCommon.getTagValue(mailhost,"MH_LOGIN");
		}

 		public String getName() { 
		    return mailhost.getAttribute("name"); 
		}

		public void setLogin(String s) {
		    XMLCommon.setTagValue(mailhost,"MH_LOGIN",s);
		}

 		public void setName(String s) { 
		    mailhost.setAttribute("name",s);
		}

		public String getHostURL() {
		    return XMLCommon.getTagValue(mailhost,"MH_URI");
		}

		public void setHostURL(String s) {
		    XMLCommon.setTagValue(mailhost,"MH_URI",s);
		}

		public String getID() {
		    return mailhost.getAttribute("id");
		}
	    };
    }

    public Enumeration mailHosts() { 
	final NodeList nl=userdata.getElementsByTagName("MAILHOST");
	return new Enumeration() {
		int i=0;
		public boolean hasMoreElements() {
		    return i<nl.getLength();
		}

		public Object nextElement() {
		    Element e=(Element)nl.item(i++);
		    return e.getAttribute("id");
		}
	    };
    }
 
    public int getMaxShowMessages() { 
	int retval=(int)getIntVarWrapper("max show messages");
	return retval==0?20:retval;
    }

    public void setMaxShowMessages(int i) { 
	setIntVarWrapper("max show messages",i);
    }

    /**
     * As of WebMail 0.7.0 this is different from the username, because it
     * consists of the username and the domain.
     * @see getUserName()
     */
    public String getLogin() { 
	return getUserName()+"@"+getDomain(); 
    }

    public String getFullName() {
	return XMLCommon.getTagValue(userdata,"FULL_NAME");
    }
    public void setFullName(String s) { 
	XMLCommon.setTagValue(userdata,"FULL_NAME",s);
    }

    public String getSignature() { 
	return XMLCommon.getTagValue(userdata,"SIGNATURE");
    }
    public void setSignature(String s) { 
	XMLCommon.setTagValue(userdata,"SIGNATURE",s,true);
    }

    public String getEmail() { 
	return XMLCommon.getTagValue(userdata,"EMAIL");
    }
    public void setEmail(String s) { 
	XMLCommon.setTagValue(userdata,"EMAIL",s);
    }

    public Locale getPreferredLocale() { 
	String loc=XMLCommon.getTagValue(userdata,"LOCALE");
	StringTokenizer t=new StringTokenizer(loc,"_");
	String language=t.nextToken().toLowerCase();
	String country="";
	if(t.hasMoreTokens()) {
	    country=t.nextToken().toUpperCase();
	}
	return new Locale(language,country);
    }

    public void setPreferredLocale(String newloc) { 
	XMLCommon.setTagValue(userdata,"LOCALE",newloc);
    }

    public String getTheme() {
	String retval=XMLCommon.getTagValue(userdata,"THEME");
	if(retval.equals("")) {
	    return WebMailServer.getDefaultTheme();
	} else {
	    return retval;
	}
    }

    public void setTheme(String theme) {
	XMLCommon.setTagValue(userdata,"THEME",theme);
    }

    private String formatDate(long date) {
	TimeZone tz=TimeZone.getDefault();
	DateFormat df=DateFormat.getDateTimeInstance(DateFormat.LONG, DateFormat.DEFAULT, getPreferredLocale());
	df.setTimeZone(tz);
	String now=df.format(new Date(date));
	return now;
    }	

    public String getFirstLogin() {
	long date=getIntVarWrapper("first login");
	return formatDate(date);
    }

    public String getLastLogin() { 
	long date=getIntVarWrapper("last login");
	return formatDate(date);
    }

    public String getLoginCount() { 
	return getIntVarWrapper("login count")+"";
    }

    public boolean checkPassword(String s) { 
	String password=XMLCommon.getTagValue(userdata,"PASSWORD");
	if(password.startsWith(">")) {
	    password=password.substring(1);
	}
	return password.equals(Helper.crypt(password,s));
    }

    public void setPassword(String newpasswd, String verify) throws InvalidPasswordException {
	if(newpasswd.equals(verify)) {
	    Random r=new Random();
	    // Generate the crypted password; avoid problems with XML parsing
	    String crypted=">";
	    while(crypted.lastIndexOf(">") >= 0 || crypted.lastIndexOf("<") >= 0) {
		// This has to be some integer between 46 and 127 for the Helper
		// class
		String seed=(char)(r.nextInt(80)+46) + "" + (char)(r.nextInt(80)+46);
		System.err.println("Seed: "+seed);
		crypted=Helper.crypt(seed,newpasswd);
	    }
	    XMLCommon.setTagValue(userdata,"PASSWORD",crypted);
	} else {
	    throw new InvalidPasswordException("The passwords did not match!");
	}
    }

    public void setPasswordData(String data) {
        XMLCommon.setTagValue(userdata, "PASSDATA", data);
    }

    public String getPasswordData() {
        return XMLCommon.getTagValue(userdata, "PASSDATA");
    }

    public int getMaxLineLength() {
	int retval=(int)getIntVarWrapper("max line length");
	return retval==0?79:retval;
    }

    public void setMaxLineLength(int i) {
	setIntVarWrapper("max line length",i);
    }

    public boolean wantsBreakLines() {
	return getBoolVarWrapper("break lines");
    }

    public void setBreakLines(boolean b) {
	setBoolVarWrapper("break lines",b);
    }

    public boolean wantsShowImages() {
	return getBoolVarWrapper("show images");
    }

    public void setShowImages(boolean b) {
	setBoolVarWrapper("show images",b);
    }

    public boolean wantsShowFancy() { 
	return getBoolVarWrapper("show fancy");
    }
    public void setShowFancy(boolean b) {
	setBoolVarWrapper("show fancy",b);
    }

    public boolean wantsSetFlags() { 
	return getBoolVarWrapper("set message flags");
    }
    public void setSetFlags(boolean b) {
	setBoolVarWrapper("set message flags",b);
    }

    public void setSaveSent(boolean b) {
	setBoolVarWrapper("save sent messages",b);
    }
    public boolean wantsSaveSent() {
	return getBoolVarWrapper("save sent messages");
    }
    public String getSentFolder() { 
	return XMLCommon.getTagValue(userdata,"SENT_FOLDER");
    }
    public void setSentFolder(String s) { 
	XMLCommon.setTagValue(userdata,"SENT_FOLDER",s);
    }

    public String getDomain() {
	return XMLCommon.getTagValue(userdata,"USER_DOMAIN");
    }
    public void setDomain(String s) {
	XMLCommon.setTagValue(userdata,"USER_DOMAIN",s);
    }

    /**
     * Return the username without the domain (in contrast to getLogin()).
     * @see getLogin()
     */
    public String getUserName() {
	return XMLCommon.getTagValue(userdata,"LOGIN"); 
    }

    public void setUserName(String s) { 
	XMLCommon.setTagValue(userdata,"LOGIN",s);
    }

    public void setIntVar(String var, long value) {
	setIntVarWrapper(var,value);
    }

    public long getIntVar(String var) {
	return getIntVarWrapper(var);
    }

    public void setBoolVar(String var, boolean value) {
	setBoolVarWrapper(var,value);
    }

    public boolean getBoolVar(String var) {
	return getBoolVarWrapper(var);
    }

    /**
     * Wrapper method for setting all bool vars
     */
    protected void setIntVarWrapper(String var, long value) {
	ensureElement("INTVAR","name",var);
	Element e=XMLCommon.getElementByAttribute(userdata,"INTVAR","name",var);
	e.setAttribute("value",value+"");
	if(debug) System.err.println("XMLUserData ("+getUserName()+"@"+getDomain()+"): Setting '"+var+"' to '"+value+"'");
    }
	
    protected long getIntVarWrapper(String var) {
	ensureElement("INTVAR","name",var);
	Element e=XMLCommon.getElementByAttribute(userdata,"INTVAR","name",var);
	long r=0;
	try {
	    r=Long.parseLong(e.getAttribute("value"));
	} catch(NumberFormatException ex) {
	    System.err.println("Warning: Not a valid number in '"+var+"' for user "+
			       getUserName()+"@"+getDomain());
	}
	return r;
    }

    /**
     * Wrapper method for setting all bool vars
     */
    protected void setBoolVarWrapper(String var, boolean value) {
	ensureElement("BOOLVAR","name",var);
	Element e=XMLCommon.getElementByAttribute(userdata,"BOOLVAR","name",var);
	e.setAttribute("value",value?"yes":"no");
	if(debug) System.err.println("XMLUserData ("+getUserName()+"@"+getDomain()+"): Setting '"+var+"' to '"+value+"'");
    }
	
    protected boolean getBoolVarWrapper(String var) {
	ensureElement("BOOLVAR","name",var);
	Element e=XMLCommon.getElementByAttribute(userdata,"BOOLVAR","name",var);
	return (e.getAttribute("value").toUpperCase().equals("YES") || 
		e.getAttribute("value").toUpperCase().equals("TRUE"));
    }

    /**
     * Set all boolvars to "false".
     *
     */
    public void resetBoolVars() {
	NodeList nl=root.getElementsByTagName("BOOLVAR");
	for(int i=0;i<nl.getLength();i++) {
	    Element elem=(Element)nl.item(i);
	    elem.setAttribute("value","no");
	}
    }
    
} // XMLUserData
