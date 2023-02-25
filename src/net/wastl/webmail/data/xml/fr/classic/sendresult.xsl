<?xml version="1.0" encoding="ISO-8859-1"?>
<!-- CVS ID: $Id: sendresult.xsl,v 1.1.1.1 2002/10/02 18:42:40 wastl Exp $ -->

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
<!-- This is part of the French translation of WebMail - Christian SENET - senet@lpm.u-nancy.fr - 2002 -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
  <xsl:output method="html" encoding="UTF-8"/>
  
  <xsl:variable name="imgbase" select="/USERMODEL/STATEDATA/VAR[@name='img base uri']/@value"/>
  <xsl:variable name="base" select="/USERMODEL/STATEDATA/VAR[@name='base uri']/@value"/>
  <xsl:variable name="session-id" select="/USERMODEL/STATEDATA/VAR[@name='session id']/@value"/>
  
  <xsl:variable name="work" select="/USERMODEL/WORK/MESSAGE[position()=1]"/>

    <xsl:template match="/">

    <HTML>
      <HEAD>
        <TITLE>Boite aux Lettres WebMail de <xsl:value-of select="/USERMODEL/USERDATA/FULL_NAME"/>: Resultat Envoi Message</TITLE>
	<META CONTENT="AUTHOR" VALUE="Sebastian Schaffert"/>
	<META CONTENT="GENERATOR" VALUE="WebMail 0.7 XSL"/>
      </HEAD>
      
      <BODY bgcolor="#ffffff">
	<TABLE WIDTH="100%" BGCOLOR="#eae723" BORDER="0" CELLSPACING="0" >
	  <TR bgcolor="#dddddd">
	    <TD VALIGN="CENTER" COLSPAN="2" WIDTH="30%"><IMG SRC="{$imgbase}/images/btn-compose.png" BORDER="0"/></TD>
	    <TD VALIGN="CENTER" ALIGN="right" WIDTH="70%">
	      <FONT SIZE="+2"><STRONG>Envoi du message</STRONG></FONT><BR/>
	      <STRONG>Sujet: </STRONG><xsl:value-of select="$work/HEADER/SUBJECT"/><BR/>
	      <STRONG>A: </STRONG><xsl:value-of select="$work/HEADER/TO"/><BR/>
	      <STRONG>Date: </STRONG><xsl:value-of select="/USERMODEL/STATEDATA/VAR[@name='date']/@value"/>
	    </TD>
	  </TR>
	  <TR>
	    <TD COLSPAN="3" ALIGN="center"><STRONG>R�sultat d�livrance du Message</STRONG></TD>
	  </TR>
	  <TR>
	    <TD COLSPAN="2"><STRONG>status d'envoi</STRONG></TD>
	    <TD><xsl:value-of select="/USERMODEL/STATEDATA/VAR[@name='send status']/@value"/></TD>
	  </TR>

	  <!-- Only show the section for valid addresses if there actually were any -->
	  <xsl:if test="/USERMODEL/STATEDATA/VAR[@name='valid sent addresses']/@value != ''">
	    <TR>
	      <TD COLSPAN="3"><STRONG>d�livr� aux adresses</STRONG></TD>
	    </TR>
	    <TR>
	      <TD WIDTH="8%"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></TD>
	      <TD><EM>valide</EM></TD>
	      <TD><xsl:value-of select="/USERMODEL/STATEDATA/VAR[@name='valid sent addresses']/@value"/></TD>
	    </TR>
	  </xsl:if>

	  <!-- Only show the section for invalid addresses if there actually were any -->
	  <xsl:if test="/USERMODEL/STATEDATA/VAR[@name='valid unsent addresses']/@value != '' or /USERMODEL/STATEDATA/VAR[@name='invalid unsent addresses']/@value != ''">
	    <TR>
	      <TD COLSPAN="3"><STRONG>not delivered to addresses</STRONG></TD>
	    </TR>
	    <xsl:if test="/USERMODEL/STATEDATA/VAR[@name='valid unsent addresses']/@value != ''">
	      <TR>
		<TD WIDTH="8%"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></TD>
		<TD><EM>valide</EM></TD>
		<TD><xsl:value-of select="/USERMODEL/STATEDATA/VAR[@name='valid unsent addresses']/@value"/></TD>
	      </TR>
	    </xsl:if>
	    <xsl:if test="/USERMODEL/STATEDATA/VAR[@name='invalid unsent addresses']/@value != ''">
	      <TR>
		<TD WIDTH="8%"><xsl:text disable-output-escaping="yes">&amp;nbsp;</xsl:text></TD>
		<TD><EM>invalide</EM></TD>
		<TD><xsl:value-of select="/USERMODEL/STATEDATA/VAR[@name='invalid unsent addresses']/@value"/></TD>
	      </TR>	  
	    </xsl:if>
	  </xsl:if>
	</TABLE>
	
	<A HREF="{$base}/compose?session-id={$session-id}&amp;continue=1"><IMG SRC="{$imgbase}/images/arrow-left.png" BORDER="0"/> Retour � la composition ...</A>
      </BODY>
    </HTML>
  </xsl:template>

  
  
</xsl:stylesheet>