/* CVS ID: $Id: XMLCommon.java,v 1.1.1.1 2002/10/02 18:42:54 wastl Exp $ */
package net.wastl.webmail.xml;

import org.w3c.dom.*;

import java.io.*;
import java.util.*;

/*
 * XMLCommon.java
 *
 * Created: Sat Mar 11 15:59:22 2000
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
 * This class contains some static methods that are used commonly in other WebMail parts.
 *
 *
 * @author Sebastian Schaffert
 * @version
 */

public final class XMLCommon  {

    public static Element getElementByAttribute(Element root, String tagname, String attribute, String att_value) {
	NodeList nl=root.getElementsByTagName(tagname);
	for(int i=0; i<nl.getLength();i++) {
	    Element elem=(Element)nl.item(i);
	    if(elem.getAttribute(attribute).equals(att_value)) {
		return elem;
	    }
	}
	return null;
    }


    public static String getElementTextValue(Element e) {
	e.normalize();
	NodeList nl=e.getChildNodes();
	if(nl.getLength() <= 0) {
	    System.err.println("Elements: "+nl.getLength());
	    return "";
	} else {
	    String s="";
	    for(int i=0;i<nl.getLength();i++) {
		if(nl.item(i) instanceof CharacterData) {
		    s+=nl.item(i).getNodeValue();
		}
	    }
	    return s.trim();
	}
    }

    public static void setElementTextValue(Element e,String text) {
	setElementTextValue(e,text,false);
    }

    public static void setElementTextValue(Element e,String text, boolean cdata) {
	Document root=e.getOwnerDocument();
	e.normalize();
	if(e.hasChildNodes()) {
	    NodeList nl=e.getChildNodes();
	    
	    /* This suxx: NodeList Object is changed when removing children !!!
	       I will store all nodes that should be deleted in a Vector and delete them afterwards */
	    int length=nl.getLength();
	
	    Vector v=new Vector(nl.getLength());
	    for(int i=0;i<length;i++) {
		if(nl.item(i) instanceof CharacterData) {	
		    v.addElement(nl.item(i));
		}
	    }
	    Enumeration enum=v.elements();
	    while(enum.hasMoreElements()) {
		Node n=(Node)enum.nextElement();
		e.removeChild(n);
	    }
	}

	if(cdata) {
	    e.appendChild(root.createCDATASection(text));
	} else {
	    e.appendChild(root.createTextNode(text));
	}
    }

    public static String getTagValue(Element e, String tagname) {
	NodeList namel=e.getElementsByTagName(tagname);
	if(namel.getLength()>0) {
	    return getElementTextValue((Element)namel.item(0));
	} else {
	    return null;
	}
    }

    /**
     * Set the value of the first tag below e with name tagname to text.
     */
    public static void setTagValue(Element e,String tagname, String text) {
	setTagValue(e,tagname,text,false);
    }

    public static void setTagValue(Element e,String tagname, String text,boolean cdata) {
	try {
	    setTagValue(e,tagname,text,false,"",cdata);
	} catch(Exception ex) {}
    }

    public static void setTagValue(Element e,String tagname, String text, 
				      boolean unique,String errormsg) throws Exception
    {
	setTagValue(e,tagname,text,unique,errormsg,false);
    }

    public static void setTagValue(Element e,String tagname, String text, 
				   boolean unique,String errormsg, boolean cdata) 
	throws Exception {

	if(text == null || tagname == null) throw new NullPointerException("Text or Tagname may not be null!");

	Document root=e.getOwnerDocument();

	if(unique) {
	    // Check for double entries!
	    NodeList nl=((Element)e.getParentNode()).getElementsByTagName(tagname);
	    for(int i=0;i<nl.getLength();i++) {
		if(getElementTextValue((Element)nl.item(0)).equals(text)) {
		    throw new Exception(errormsg);
		}
	    }
	}
	NodeList namel=e.getElementsByTagName(tagname);
	Element elem;
	if(namel.getLength()<=0) {
	    System.err.println("Creating Element "+tagname+"; will set to "+text);
	    elem=root.createElement(tagname);
	    e.appendChild(elem);
	} else {
	    elem=(Element)namel.item(0);
	}
	//debugXML(root);
	setElementTextValue(elem,text,cdata);
    }

    public static void genericRemoveAll(Element parent, String tagname) {
	NodeList nl=parent.getChildNodes();
	Vector parts=new Vector();
	for(int i=0;i<nl.getLength();i++) {
	    if(nl.item(i) instanceof Element) {
		Element elem=(Element)nl.item(i);
		if(elem.getTagName().equals(tagname)) {
		    parts.addElement(elem);
		}
	    }
	}
	Enumeration enum=parts.elements();
	while(enum.hasMoreElements()) {
	    parent.removeChild((Node)enum.nextElement());
	}
    }


    public static void writeXML(Document d, OutputStream os, String sysID) throws IOException {
	// Modified by exce, start
	/**
	 * To support i18n, we have to specify the encoding of 
	 * output writer to UTF-8 when we writing the XML.
	 */
	// PrintWriter out=new PrintWriter(os);
	PrintWriter out = new PrintWriter(new OutputStreamWriter(os, "UTF-8"));
	// Modified by exce, end

	out.println("<?xml version=\"1.0\" encoding=\"UTF-8\"?>");
	out.println();
	out.println("<!DOCTYPE "+d.getDoctype().getName()+" SYSTEM \""+sysID+"\">");
	out.println();
	//d.getDocumentElement().normalize();
	writeXMLwalkTree(d.getDocumentElement(),0,out);
	out.flush();
    }
    
    protected static void writeXMLwalkTree(Node node, int indent, PrintWriter out) {
	if(node == null) {
	    System.err.println("??? Node was null ???");
	    return;
	}
	if(node.hasChildNodes()) {
	    if(node instanceof Element) {
		Element elem=(Element)node;
		//elem.normalize();
		out.print("\n");
		for(int j=0;j<indent;j++) {
		    out.print(" ");
		}
		out.print("<"+elem.getTagName());
		NamedNodeMap attrs=elem.getAttributes();
		for(int i=0;i<attrs.getLength();i++) {
		    Attr a=(Attr)attrs.item(i);
		    out.print(" "+a.getName()+"=\""+a.getValue()+"\"");
		}
		out.print(">");
		NodeList nl=node.getChildNodes();
		for(int i=0;i<nl.getLength();i++) {
		    writeXMLwalkTree(nl.item(i),indent+2,out);
		}
// 		for(int j=0;j<indent;j++) {
// 		    out.print(" ");
// 		}
		out.println("</"+elem.getTagName()+">");
	    }
	} else {
	    if(node instanceof Element) {
		Element elem=(Element)node;
		out.print("\n");
		for(int j=0;j<indent;j++) {
		    out.print(" ");
		}
		out.print("<"+elem.getTagName());
		NamedNodeMap attrs=elem.getAttributes();
		for(int i=0;i<attrs.getLength();i++) {
		    Attr a=(Attr)attrs.item(i);
		    out.print(" "+a.getName()+"=\""+a.getValue()+"\"");
		}
		out.println("/>");
	    } else if(node instanceof CDATASection) {
		CDATASection cdata=(CDATASection)node;
// 		for(int j=0;j<indent;j++) {
// 		    out.print(" ");
// 		}
		out.print("<![CDATA["+cdata.getData()+"]]>");
	    } else if(node instanceof Text) {
		Text text=(Text)node;
		StringBuffer buf=new StringBuffer(text.getData().length());
		for(int i=0;i<text.getData().length();i++) {
		    if(text.getData().charAt(i) == '\n' ||
		       text.getData().charAt(i) == '\r' || 
		       text.getData().charAt(i) == ' ' ||
		       text.getData().charAt(i) == '\t') {
			if(buf.length()>0 && buf.charAt(buf.length()-1)!=' ') {
			    buf.append(' ');
			}
		    } else {
			buf.append(text.getData().charAt(i));
		    }
		}
		if(buf.length() > 0 && !buf.toString().equals(" ")) {
		    StringBuffer buf2=new StringBuffer(buf.length()+indent);
// 		    for(int j=0;j<indent;j++) {
// 			buf2.append(' ');
// 		    }
		    buf2.append(buf.toString());
		    out.print(buf2);
		}
	    }
	}
    }

    /**
     * This is a helper function to deal with problems that occur when importing Nodes from
     * JTidy Documents to Xerces Documents.
     */
    public static Node importNode(Document d, Node n, boolean deep) {
	Node r=cloneNode(d,n);
	if(deep) {
	    NodeList nl=n.getChildNodes();
	    for(int i=0;i<nl.getLength();i++) {
		Node n1=importNode(d,nl.item(i),deep);
		r.appendChild(n1);
	    }
	}
	return r;
    }
		    
    public static Node cloneNode(Document d,Node n) {
	Node r=null;
	switch(n.getNodeType()) {
	case Node.TEXT_NODE: 
	    r = d.createTextNode(((Text)n).getData());
	    break;
	case Node.CDATA_SECTION_NODE:
	    r = d.createCDATASection(((CDATASection)n).getData());
	    break;
	case Node.ELEMENT_NODE:
	    r = d.createElement(((Element)n).getTagName());
	    NamedNodeMap map=n.getAttributes();
	    for(int i=0;i<map.getLength();i++) {
		((Element)r).setAttribute(((Attr)map.item(i)).getName(),
					  ((Attr)map.item(i)).getValue());
	    }
	    break;	    
	}
	return r;
    }

    public static synchronized void debugXML(Document d) {	
   	try {
	    FileOutputStream fout=new FileOutputStream("/tmp/webmail.xml."+System.currentTimeMillis());
	    PrintWriter out=new PrintWriter(fout);
	    out.println("Debugging XML:");
	    out.println("==============================================================");

	    writeXML(d,fout,"test");
// 	    OutputFormat of=new OutputFormat(Method.XML,"ISO-8859-1",true);
// 	    of.setIndenting(true);
// 	    of.setIndent(2);
// 	    of.setDoctype(null,d.getDoctype().getName());
// 	    of.setStandalone(false);
// 	    System.err.println("Doctype system:"+of.getDoctypeSystem());
// 	    XMLSerializer ser=new XMLSerializer(System.out,of);
// 	    ser.serialize(d.getDocumentElement());
	    out.println("==============================================================");	    
	    fout.flush();
	    fout.close();
	} catch(Exception ex) {
	    ex.printStackTrace();
	}
    }
} // XMLCommon
