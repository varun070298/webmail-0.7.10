<?xml version="1.0" encoding="ISO-8859-1"?>
<!--
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
-->

<!-- This template is part of the German translation -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>

    <xsl:variable name="imgbase" select="/USERMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
    <xsl:variable name="base" select="/USERMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
    <xsl:variable name="session-id" select="/USERMODEL/STATEDATA/VAR[@name='session id']/@value"/>
  
    <xsl:template match="/">
    
    <HTML>
      <HEAD>
        <TITLE>WebMail Error Reporting</TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
	<META CONTENT="GENERATOR" VALUE="JWebMail 0.7 XSL"/>
	<link rel="stylesheet" href="{$base}/passthrough/webmail.css"/>
      </HEAD>
      
      <BODY bgcolor="#B5C1CF" topmargin="5" leftmargin="0" marginwidth="0" marginheight="5">
	<TABLE WIDTH="100%">
	  <TR bgcolor="#A6B1C0">
	    <TD COLSPAN="2" align="center" class="testoGrande">An error ocurred</TD>
	  </TR>
	  <TR>
	    <TD class="testoNero"><SPAN class="testoGrande">Error message</SPAN></TD>
	    <TD class="testoNero">
	      <P class="testoMesg"><xsl:apply-templates select="//STATEDATA/EXCEPTION/EX_MESSAGE"/></P>
	    </TD>
	  </TR>
	  <TR>
	    <TD COLSPAN="2" ALIGN="center" class="testoNero">
	      <TABLE bgcolor="#E2E6F0" WIDTH="80%" BORDER="1">
		<TR>
		  <TD><SPAN class="testoGrande">Stack Trace</SPAN><BR/>
		    <PRE>
		      <P class="testoMesg"><xsl:apply-templates select="//STATEDATA/EXCEPTION/EX_STACKTRACE"/></P>
		    </PRE>
		  </TD>
		</TR>
	      </TABLE>
	    </TD>
	  </TR>
	  <TR bgcolor="#A6B1C0">
	    <TD COLSPAN="2" align="center" class="testoGrande">!</TD>
	  </TR>
	</TABLE>
      </BODY>
    </HTML>
  </xsl:template>
  

</xsl:stylesheet>
