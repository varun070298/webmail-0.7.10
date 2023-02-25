<?xml version="1.0" encoding="UTF-8"?>
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


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" indent="yes"/>

    <xsl:variable name="imgbase" select="/GENERICMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
    <xsl:variable name="base" select="/GENERICMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
    <xsl:variable name="session-id" select="/GENERICMODEL/STATEDATA/VAR[@name='session id']/@value"/>
  
    <xsl:template match="/">

    <HTML>
      <HEAD>
        <TITLE>WebMail Administration Interface: Virtual Domain Configuration</TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
      </HEAD>
	
      <BODY BGCOLOR="#ffffff">
	<CENTER><H1>WebMail Virtual Domain Configuration</H1></CENTER>
	<FORM ACTION="{$base}/admin/domain/set?session-id={$session-id}" METHOD="POST">
	  <TABLE WIDTH="100%" CELLSPACING="0" CELLPADDING="0">
	    <TR BGCOLOR="lightblue">
	      <TD><STRONG>Domain Name</STRONG></TD>
	      <TD><STRONG>Default Host</STRONG></TD>
	      <TD><STRONG>Authentication Host</STRONG></TD>
	      <TD><STRONG>Host Restriction</STRONG></TD>
	      <TD><STRONG>Allowed Hosts</STRONG> (for Host Restriction)</TD>
	      <TD></TD>
	    </TR>
	    <xsl:for-each select="/GENERICMODEL/SYSDATA/DOMAIN">
	      <TR>
		<TD><INPUT type="TEXT" name="{NAME} DOMAIN" value="{NAME}" SIZE="20"/></TD>
		<TD><INPUT type="TEXT" name="{NAME} DEFAULT HOST" value="{DEFAULT_HOST}" SIZE="20"/></TD>
		<TD><INPUT type="TEXT" name="{NAME} AUTH HOST" value="{AUTHENTICATION_HOST}" SIZE="20"/></TD>
		<TD ALIGN="center">
		  <xsl:choose>
		    <xsl:when test="count(RESTRICTED) > 0">
		      <INPUT type="CHECKBOX" checked="checked" name="{NAME} HOST RESTRICTION"/>
		    </xsl:when>
		    <xsl:otherwise>
		      <INPUT type="CHECKBOX" name="{NAME} HOST RESTRICTION"/>
		    </xsl:otherwise>
		  </xsl:choose>
		</TD>
		<TD><INPUT type="TEXT" name="{NAME} ALLOWED HOSTS" value="{ALLOWED_HOST}" SIZE="40"/></TD>
		<TD><INPUT type="submit" name="CHANGE {NAME}" value="Change"/><INPUT type="submit" name="DELETE {NAME}" value="Delete"/></TD>
	      </TR>
	    </xsl:for-each>
	    
	    <TR>
	      <TD><INPUT type="TEXT" name="NEW DOMAIN" value="new" SIZE="20"/></TD>
	      <TD><INPUT type="TEXT" name="NEW DEFAULT HOST" SIZE="20"/></TD>
	      <TD><INPUT type="TEXT" name="NEW AUTH HOST" SIZE="20"/></TD>	    
	      <TD align="center"><INPUT type="CHECKBOX" name="NEW HOST RESTRICTION"/></TD>
	      <TD><INPUT type="TEXT" name="NEW ALLOWED HOSTS" SIZE="40"/></TD>
	      <TD><INPUT type="submit" name="ADD NEW" value="Add"/></TD>
	    </TR>
	  </TABLE>
	</FORM>
      </BODY>
	
    </HTML>

  </xsl:template>
</xsl:stylesheet>
